# Helper methods for broadcasting chat updates via Turbo Streams
module ChatBroadcastHelper
  # Append a chunk of streamed LLM response content
  def broadcast_message_chunk(chat, content, message_id)
    Turbo::StreamsChannel.broadcast_append_to(
      chat,
      target: "message-content-#{message_id}",
      html: content
    )
  end

  # Toggle typing indicator visibility
  def broadcast_typing_indicator(chat, visible:)
    action = visible ? :remove_class : :add_class
    css_class = "hidden"

    Turbo::StreamsChannel.broadcast_action_to(
      chat,
      action: action,
      target: "typing-indicator",
      attribute: "class",
      classes: css_class
    )
  end

  # Replace message with final complete version
  def broadcast_message_complete(chat, message)
    Turbo::StreamsChannel.broadcast_replace_to(
      chat,
      target: "message-#{message.id}",
      partial: "messages/message",
      locals: { message: message }
    )
  end

  # Append new message to chat
  def broadcast_new_message(chat, message)
    Turbo::StreamsChannel.broadcast_append_to(
      chat,
      target: "messages",
      partial: "messages/message",
      locals: { message: message }
    )
  end
end
