# Manages chat conversations for authenticated users
class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [ :show, :destroy ]
  before_action :set_chats_for_sidebar

  def index
    # Renders empty state with sidebar
  end

  def show
    @messages = @chat.messages.order(:created_at)
    @message = Message.new
  end

  def create
    @chat = current_user.chats.build

    if @chat.save
      redirect_to @chat
    else
      redirect_to chats_path, alert: "Could not create conversation"
    end
  end

  def destroy
    @chat.destroy
    next_chat = current_user.chats.recent.first

    if next_chat
      redirect_to chat_path(next_chat), notice: "Conversation deleted"
    else
      redirect_to chats_path, notice: "Conversation deleted"
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end

  def set_chats_for_sidebar
    @chats = current_user.chats.recent.select(:id, :title, :updated_at)
  end
end
