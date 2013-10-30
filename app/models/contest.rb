class Contest < ActiveRecord::Base
  has_many :user
  belongs_to :referee
  has_many :matches, as: :manager
end
