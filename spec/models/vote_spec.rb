require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it_behaves_like "authorable"
end
