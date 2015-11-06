class Recipe < ActiveRecord::Base
	has_attached_file :image, styles: { medium: "90x90#" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
