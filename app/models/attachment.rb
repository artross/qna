class Attachment < ApplicationRecord
  belongs_to :attach_box, polymorphic: true, required: false

  mount_uploader :file, FileUploader
end
