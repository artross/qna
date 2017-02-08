module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, as: :attachable, dependent: :destroy
    accepts_nested_attributes_for :attachments, reject_if: :all_blank
  end

  def attachments_array_for_broadcasting
    attachments.select{ |a| a.persisted? }.map do |a|
      { id: a.id, fileName: a.file.file.filename, path: a.file.url }
    end || []
  end
end
