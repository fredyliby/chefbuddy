require "open-uri"
class Recipe < ActiveRecord::Base
	belongs_to :user
	has_many :ingredients
	has_many :directions
	accepts_nested_attributes_for :ingredients, 
	reject_if: proc { |attributes|attributes['name'].blank?}, 
	allow_destroy: true
	accepts_nested_attributes_for :directions, 
	reject_if: proc { |attributes|attributes['step'].blank?}, 
	allow_destroy: true
	validates :title, :description, :image, presence: true
	has_attached_file :image, styles: { medium: "300x200#", large: "500x400" }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/


	def picture_from_url(url)
		self.picture = open(url)
	end
end
