# Background job for streaming LLM responses via Turbo Streams
class LlmResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_id, user_message_id)
    chat = Chat.find(chat_id)
    full_response = ""
    assistant_message = nil

    begin
      # complete() processes the conversation and creates assistant message
      # User message was already created by controller
      response = chat.complete do |chunk|
        next if chunk.content.blank?

        full_response << chunk.content

        # On first content chunk, get assistant message and show bubble
        if assistant_message.nil?
          broadcast_typing(chat, visible: false)
          assistant_message = chat.messages.where(role: "assistant").last
          broadcast_new_message(chat, assistant_message) if assistant_message
        end

        # Stream content to the message bubble
        if assistant_message
          broadcast_content_update(chat, assistant_message, full_response)
        end
      end

      # Refresh to get updated token counts
      assistant_message&.reload

      # Broadcast final state with token info
      broadcast_message_complete(chat, assistant_message) if assistant_message

    rescue StandardError => e
      Rails.logger.error("LLM Error: #{e.message}")
      Rails.logger.error(e.backtrace.first(5).join("\n"))

      # Get or create error message
      assistant_message ||= chat.messages.where(role: "assistant").last
      if assistant_message
        assistant_message.update!(content: "Sorry, I encountered an error: #{e.message}")
        broadcast_message_complete(chat, assistant_message)
      else
        error_msg = chat.messages.create!(role: "assistant", content: "Sorry, I encountered an error: #{e.message}")
        broadcast_new_message(chat, error_msg)
      end
    ensure
      broadcast_typing(chat, visible: false)
    end
  end

  private

  def broadcast_typing(chat, visible:)
    html = if visible
      <<~HTML
        <div id="typing-indicator" class="max-w-4xl mx-auto px-4 pb-6">
          #{render_typing_indicator}
        </div>
      HTML
    else
      '<div id="typing-indicator" class="hidden max-w-4xl mx-auto px-4 pb-6"></div>'
    end

    Turbo::StreamsChannel.broadcast_replace_to(chat, target: "typing-indicator", html: html)
  end

  def broadcast_new_message(chat, message)
    Turbo::StreamsChannel.broadcast_append_to(
      chat,
      target: "messages",
      partial: "messages/message",
      locals: { message: message }
    )
  end

  def broadcast_content_update(chat, message, content)
    Turbo::StreamsChannel.broadcast_replace_to(
      chat,
      target: "message-content-#{message.id}",
      html: "<div id=\"message-content-#{message.id}\" class=\"text-gray-900 dark:text-gray-100 whitespace-pre-wrap break-words leading-relaxed\" aria-live=\"polite\">#{ERB::Util.html_escape(content)}</div>"
    )
  end

  def broadcast_message_complete(chat, message)
    Turbo::StreamsChannel.broadcast_replace_to(
      chat,
      target: "message-#{message.id}",
      partial: "messages/message",
      locals: { message: message }
    )
  end

  def render_typing_indicator
    ApplicationController.render(partial: "chats/typing_indicator")
  end
end
