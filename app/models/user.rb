# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  comments_count         :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer
#  private                :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         validates(:username, {
          :presence => true,
          :uniqueness => { :case_sensitive => false },
        })
      
        has_many  :likes, class_name: "Like", foreign_key: "fan_id", dependent: :destroy
        has_many  :followerrequests, class_name: "Followrequest", foreign_key: "recipient_id", dependent: :destroy
        has_many  :comments, class_name: "Comment", foreign_key: "author_id", dependent: :destroy
        has_many  :followrequests, class_name: "Followrequest", foreign_key: "sender_id", dependent: :destroy
        has_many :recipients, through: :followrequests, source: :recipient
        has_many :senders, through: :followerrequests, source: :sender


        def comments
          my_id = self.id
      
          matching_comments = Comment.where({ :author_id => my_id })
      
          return matching_comments
        end
      
        def own_photos
          my_id = self.id
      
          matching_photos = Photo.where({ :owner_id => my_id })
      
          return matching_photos
        end
      
        def likes
          my_id = self.id
      
          matching_likes = Like.where({ :fan_id => my_id })
      
          return matching_likes
        end
      
        def liked_photos
          my_likes = self.likes
          
          array_of_photo_ids = Array.new
      
          my_likes.each do |a_like|
            array_of_photo_ids.push(a_like.photo_id)
          end
      
          matching_photos = Photo.where({ :id => array_of_photo_ids })
      
          return matching_photos
        end
      
        def commented_photos
          my_comments = self.comments
          
          array_of_photo_ids = Array.new
      
          my_comments.each do |a_comment|
            array_of_photo_ids.push(a_comment.photo_id)
          end
      
          matching_photos = Photo.where({ :id => array_of_photo_ids })
      
          unique_matching_photos = matching_photos.distinct
      
          return unique_matching_photos
        end
      
        def sent_follow_requests
          my_id = self.id
      
          matching_follow_requests = FollowRequest.where({ :sender_id => my_id })
      
          return matching_follow_requests
        end
      
        def received_follow_requests
          my_id = self.id
      
          matching_follow_requests = FollowRequest.where({ :recipient_id => my_id })
      
          return matching_follow_requests
        end
      
        def accepted_sent_follow_requests
          my_sent_follow_requests = self.sent_follow_requests
      
          matching_follow_requests = my_sent_follow_requests.where({ :status => "accepted" })
      
          return matching_follow_requests
        end
      
        def accepted_received_follow_requests
          my_received_follow_requests = self.received_follow_requests
      
          matching_follow_requests = my_received_follow_requests.where({ :status => "accepted" })
      
          return matching_follow_requests
        end
      
        def followers
          my_accepted_received_follow_requests = self.accepted_received_follow_requests
          
          array_of_user_ids = Array.new
      
          my_accepted_received_follow_requests.each do |a_follow_request|
            array_of_user_ids.push(a_follow_request.sender_id)
          end
      
          matching_users = User.where({ :id => array_of_user_ids })
      
          return matching_users
        end
      
        def leaders
          my_accepted_sent_follow_requests = self.accepted_sent_follow_requests
          
          array_of_user_ids = Array.new
      
          my_accepted_sent_follow_requests.each do |a_follow_request|
            array_of_user_ids.push(a_follow_request.recipient_id)
          end
      
          matching_users = User.where({ :id => array_of_user_ids })
      
          return matching_users
        end
      
        def feed
          array_of_photo_ids = Array.new
      
          my_leaders = self.leaders
          
          my_leaders.each do |a_user|
            leader_own_photos = a_user.own_photos
      
            leader_own_photos.each do |a_photo|
              array_of_photo_ids.push(a_photo.id)
            end
          end
      
          matching_photos = Photo.where({ :id => array_of_photo_ids })
      
          return matching_photos
        end
      
        def discover
          array_of_photo_ids = Array.new
      
          my_leaders = self.leaders
          
          my_leaders.each do |a_user|
            leader_liked_photos = a_user.liked_photos
      
            leader_liked_photos.each do |a_photo|
              array_of_photo_ids.push(a_photo.id)
            end
          end
      
          matching_photos = Photo.where({ :id => array_of_photo_ids })
      
          return matching_photos
        end









end
