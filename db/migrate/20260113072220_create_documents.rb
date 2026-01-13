class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.vector :embedding, limit: 768  # Gemini embedding-001 dimensions
      t.string :source_type, default: "text"
      t.integer :chunk_index, default: 0
      t.references :parent_document, foreign_key: { to_table: :documents }
      t.timestamps
    end

    add_index :documents, :embedding, using: :hnsw, opclass: :vector_cosine_ops
  end
end
