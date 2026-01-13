require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "belongs to user" do
    chat = chats(:one)
    assert_equal users(:one), chat.user
  end

  test "requires user" do
    chat = Chat.new
    assert_not chat.valid?
    assert_includes chat.errors[:user], "must exist"
  end

  test "display_title returns title when present" do
    chat = chats(:one)
    assert_equal "Test Chat 1", chat.display_title
  end

  test "display_title returns Chat ID when title blank" do
    chat = Chat.new(user: users(:one))
    chat.save!
    assert_equal "Chat #{chat.id}", chat.display_title
  end

  test "recent scope orders by updated_at desc" do
    older_chat = chats(:two)
    newer_chat = chats(:one)

    recent = Chat.recent
    assert_equal newer_chat, recent.first
  end

  test "for_user scope filters by user" do
    user_one_chats = Chat.for_user(users(:one))
    assert_includes user_one_chats, chats(:one)
    assert_includes user_one_chats, chats(:two)
    assert_not_includes user_one_chats, chats(:other_user_chat)
  end

  test "destroying user destroys associated chats" do
    user = users(:one)
    chat_ids = user.chats.pluck(:id)

    assert chat_ids.any?
    user.destroy

    chat_ids.each do |id|
      assert_nil Chat.find_by(id: id)
    end
  end
end
