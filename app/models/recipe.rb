class Recipe < ActiveRecord::Base
	  validates :title, :description, :image, presence: true
	has_attached_file :image, styles: { medium: "200x200#" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
