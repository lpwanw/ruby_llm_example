class Chat < ApplicationRecord
  acts_as_chat messages_foreign_key: :chat_id

  belongs_to :user
  belongs_to :model, optional: true

  validates :user, presence: true

  scope :recent, -> { order(updated_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

  # Broadcast to user-specific stream for sidebar updates
  after_create_commit :broadcast_sidebar_prepend
  after_destroy_commit :broadcast_sidebar_remove

  def display_title
    title.presence || first_message_preview || "New Chat"
  end

  # Auto-generate title from first user message
  def generate_title_from_message(message)
    return if title.present?
    return unless message.role == "user"

    snippet = message.content.to_s.truncate(50, omission: "...")
    update_column(:title, snippet) if snippet.present?
  end

  private

  def first_message_preview
    first_user_message = messages.where(role: "user").order(:created_at).first
    first_user_message&.content&.truncate(50, omission: "...")
  end

  def broadcast_sidebar_prepend
    broadcast_prepend_to(
      "user_#{user_id}_chats",
      target: "sidebar-chats",
      partial: "chats/sidebar_chat_item",
      locals: { chat: self }
    )
  end

  def broadcast_sidebar_remove
    broadcast_remove_to("user_#{user_id}_chats")
  end
end
