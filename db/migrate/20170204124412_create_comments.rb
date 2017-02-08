class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.timestamps
    end
    add_reference :comments, :author, references: :users, index: true
    add_foreign_key :comments, :users, column: :author_id
  end
end
