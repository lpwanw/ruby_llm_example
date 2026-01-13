class Document < ApplicationRecord
  has_neighbors :embedding

  belongs_to :user
  belongs_to :parent_document, class_name: "Document", optional: true
  has_many :chunks, class_name: "Document",
           foreign_key: :parent_document_id,
           dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  after_create_commit :process_document_async, if: :original?

  scope :originals, -> { where(parent_document_id: nil) }
  scope :for_user, ->(user) { where(user: user) }
  scope :embedded, -> { where.not(embedding: nil) }

  # Search documents by semantic similarity
  def self.search(query_text, user:, limit: 3)
    embedding = generate_embedding(query_text)
    return none if embedding.nil?

    for_user(user)
      .embedded
      .nearest_neighbors(:embedding, embedding, distance: "cosine")
      .limit(limit)
  end

  def self.generate_embedding(text)
    response = RubyLLM.embed(text)
    response.vectors
  rescue => e
    Rails.logger.error("Embedding generation failed: #{e.message}")
    nil
  end

  def original?
    parent_document_id.nil?
  end

  def embedded?
    embedding.present?
  end

  def processing?
    original? && !embedded? && chunks.empty?
  end

  private

  def process_document_async
    DocumentProcessingJob.perform_later(id)
  end
end
