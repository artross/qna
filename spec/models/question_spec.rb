require 'rails_helper'
require_relative './concerns/authorable_spec'
require_relative './concerns/attachable_spec'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it_behaves_like "authorable"
  it_behaves_like "attachable"
end
