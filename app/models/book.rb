class Book < ActiveRecord::Base

  belongs_to :author
  belongs_to :category
  has_many :favorites
  has_many :users, :through => :favorites

  validates :name, :presence => true
  validates :isbn, :presence => true, :uniqueness => true
  validates :image, :presence => true
  validates :year, :presence => true

end
