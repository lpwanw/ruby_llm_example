# Handles real-time message streaming for chat conversations
# Uses Turbo Streams for DOM updates via ActionCable
class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find_by(id: params[:chat_id])

    if chat && chat.user_id == current_user&.id
      stream_for chat
    else
      reject
    end
  end

  def unsubscribed
    # Cleanup if needed
  end
end
