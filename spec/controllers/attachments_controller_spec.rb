require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    log_user_in

    context "with an author's question" do
      let(:question) { create(:question, author: @user) }
      let(:attachment) { create(:attachment_to_question, attach_box: question) }

      it 'removes attachment from DB' do
        attachment
        expect { delete :destroy, params: { id: attachment, format: :js } }.to change(question.attachments, :count).by(-1)
      end
    end

    context "with another's question" do
      let(:attachment) { create(:attachment_to_question) }

      it "doesn't remove attachment from DB" do
        attachment
        expect { delete :destroy, params: { id: attachment, format: :js } }.not_to change(Attachment, :count)
      end

      it "redirects to question's index view" do
        delete :destroy, params: { id: attachment, format: :js }
        expect(response).to render_template :'questions/index'
      end
    end
  end
end
