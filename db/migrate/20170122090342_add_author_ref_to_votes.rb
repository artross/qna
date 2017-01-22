class AddAuthorRefToVotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :votes, :author, references: :users, index: true
    add_foreign_key :votes, :users, column: :author_id
  end
end
