require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @chat = chats(:one)
    @other_user_chat = chats(:other_user_chat)
  end

  # Authentication tests
  test "index redirects when not signed in" do
    get chats_url
    assert_redirected_to new_user_session_path
  end

  test "show redirects when not signed in" do
    get chat_url(@chat)
    assert_redirected_to new_user_session_path
  end

  test "create redirects when not signed in" do
    post chats_url
    assert_redirected_to new_user_session_path
  end

  # Index tests
  test "index shows user chats" do
    sign_in @user
    get chats_url
    assert_response :success
    assert_select "h1", "Conversations"
  end

  # Show tests
  test "show displays chat" do
    sign_in @user
    get chat_url(@chat)
    assert_response :success
    assert_select "h1", @chat.display_title
  end

  test "show returns 404 for other user chat" do
    sign_in @user
    get chat_url(@other_user_chat)
    assert_response :not_found
  end

  # Create tests
  test "create creates new chat" do
    sign_in @user
    assert_difference("Chat.count", 1) do
      post chats_url
    end
    assert_redirected_to chat_url(Chat.last)
  end

  # Destroy tests
  test "destroy deletes chat" do
    sign_in @user
    assert_difference("Chat.count", -1) do
      delete chat_url(@chat)
    end
    assert_redirected_to chats_url
  end

  test "destroy returns 404 for other user chat" do
    sign_in @user
    delete chat_url(@other_user_chat)
    assert_response :not_found
  end
end
