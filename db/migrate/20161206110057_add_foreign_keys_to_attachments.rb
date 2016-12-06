class AddForeignKeysToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :attach_box_id, :integer
    add_column :attachments, :attach_box_type, :string
    add_index :attachments, [:attach_box_id, :attach_box_type]
  end
end
