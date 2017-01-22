require 'rails_helper'

shared_examples_for "authorable" do
  it { should belong_to(:author).class_name("User") }
end
