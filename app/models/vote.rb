class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true, required: false
end
