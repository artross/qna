class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: [:destroy]
  before_action :find_attachable, only: [:destroy]

  def destroy
    if @attachment.attachable.author_id == current_user.id
      if @attachment.destroy
        flash[:notice] = "File successfully removed."
      else
        flash.now[:alert] = "Something went wrong..."
      end
    else
      flash.now[:alert] = "Unable to delete another's file!"
      render :'questions/index'
    end
  end

  private

    def find_attachment
      @attachment = Attachment.find(params[:id])
    end

    def find_attachable
      @attachable = @attachment.attachable
    end
end
