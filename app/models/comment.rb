# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  photo_id   :integer
#
class Comment < ApplicationRecord
  
  #belongs_to :photo, required: true, class_name: "Photo", foreign_key: "photo_id", counter_cache: true
  #belongs_to :author, required: true, class_name: "User", foreign_key: "author_id", counter_cache: true
  
  validates(:commenter, { :presence => true })

  def commenter
    my_author_id = self.author_id

    matching_users = User.where({ :id => my_author_id })

    the_user = matching_users.at(0)

    return the_user
  end

end
