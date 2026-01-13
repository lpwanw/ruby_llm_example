# Handles message creation and triggers LLM response
class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    content = message_params[:content]

    if content.present?
      # Create user message immediately for instant display
      @message = @chat.messages.create!(role: "user", content: content)

      # Auto-generate chat title from first message
      @chat.generate_title_from_message(@message)

      # Enqueue LLM response job
      LlmResponseJob.perform_later(@chat.id, @message.id)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end
    else
      redirect_to @chat, alert: "Message cannot be empty"
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
