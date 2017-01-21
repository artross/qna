class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, required: false

  mount_uploader :file, FileUploader
end
