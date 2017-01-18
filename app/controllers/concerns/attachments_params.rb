module AttachmentsParams
  extend ActiveSupport::Concern

  def extract_attachments_params!(params, target)
    target[:attachments_attributes] = params.permit(attachments_attributes: [file: []])
                                            .to_h
                                            .fetch(:attachments_attributes, [])
                                            .map { |k,v| v[:file] }
                                            .flatten
                                            .map { |f| { file: f } } if params[:attachments_attributes]
  end
end
