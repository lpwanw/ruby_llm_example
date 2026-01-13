require "test_helper"

class LlmResponseJobTest < ActiveJob::TestCase
  setup do
    @chat = chats(:one)
    @user_message = messages(:user_message)
  end

  test "job creates assistant message" do
    # Skip if no LLM configured for test environment
    skip "LLM not configured for testing" unless llm_configured?

    assert_difference("Message.count", 1) do
      LlmResponseJob.perform_now(@chat.id, @user_message.id)
    end

    assistant_message = Message.last
    assert_equal "assistant", assistant_message.role
    assert_not_empty assistant_message.content
  end

  test "job handles errors gracefully" do
    # Test with invalid chat ID
    assert_nothing_raised do
      assert_raises(ActiveRecord::RecordNotFound) do
        LlmResponseJob.perform_now(-1, @user_message.id)
      end
    end
  end

  private

  def llm_configured?
    # Check if LLM is configured and accessible
    ENV["OPENAI_API_KEY"].present? ||
      ENV["ANTHROPIC_API_KEY"].present? ||
      ENV["GEMINI_API_KEY"].present?
  end
end
