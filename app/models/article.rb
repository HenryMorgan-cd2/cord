class Article < ApplicationRecord

  has_many :comments
  belongs_to :author, optional: true
  # has_one :page

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(id: :desc) }

end
