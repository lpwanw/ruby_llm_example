class AddUserToChats < ActiveRecord::Migration[8.1]
  def change
    add_reference :chats, :user, foreign_key: true, index: true
    add_column :chats, :title, :string
  end
end
