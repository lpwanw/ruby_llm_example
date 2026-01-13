require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @chat = chats(:one)
    @other_user_chat = chats(:other_user_chat)
  end

  test "create redirects when not signed in" do
    post chat_messages_url(@chat), params: { message: { content: "Hello" } }
    assert_redirected_to new_user_session_path
  end

  test "create creates user message" do
    sign_in @user

    assert_difference("Message.count", 1) do
      post chat_messages_url(@chat), params: { message: { content: "Hello, AI!" } }
    end

    message = Message.last
    assert_equal "user", message.role
    assert_equal "Hello, AI!", message.content
    assert_equal @chat, message.chat
  end

  test "create redirects to chat on html request" do
    sign_in @user
    post chat_messages_url(@chat), params: { message: { content: "Hello" } }
    assert_redirected_to @chat
  end

  test "create responds with turbo stream" do
    sign_in @user
    post chat_messages_url(@chat),
         params: { message: { content: "Hello" } },
         as: :turbo_stream

    assert_response :success
  end

  test "create returns 404 for other user chat" do
    sign_in @user
    post chat_messages_url(@other_user_chat), params: { message: { content: "Hello" } }
    assert_response :not_found
  end

  test "create enqueues llm response job" do
    sign_in @user

    assert_enqueued_with(job: LlmResponseJob) do
      post chat_messages_url(@chat), params: { message: { content: "Hello" } }
    end
  end
end
