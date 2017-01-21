class RenameAttachmentsAttachBoxColumns < ActiveRecord::Migration[5.0]
  def change
    remove_index :attachments, [:attach_box_id, :attach_box_type]
    rename_column :attachments, :attach_box_id, :attachable_id
    rename_column :attachments, :attach_box_type, :attachable_type
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
