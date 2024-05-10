class UsersController < ApplicationController
  def index
      matching_users = User.all

      @list_of_users = matching_users.order({ :username => :asc})

      #@current_accepted_requests = FollowRequest.where({:sender_id => current_user.id, :status => "accepted"})
      #@current_pending_requess = FollowRequest.where({:sender_id => current_user.id, :status => "pending"})
      #@current_rejected_requests = FollowRequest.where({:sender_id => current_user.id, :status => "rejected"})

      #@the_accepted_requests = current_accepted_request
      #@the_pending_requests = current_pending_request
      #@the_rejected_requests = current_rejected_request


      render({:template => "users/index"})
  end


  def show
    url_username = params.fetch("path_username")

    matching_usernames= User.where({:username => url_username})
    @the_user = matching_usernames.first
    
    
    #defensive coding example here!!!!! - Dane
    if @the_user == nil
      redirect_to("/404")
    else
      render({:template => "users/show"})
    end
  end

  def feed
    url_username = params.fetch("path_username")

    matching_usernames= User.where({:username => url_username})
    @the_user = matching_usernames.first
    #@user_leaders = @the_user.leaders
    #@leader_photos= Photo.where({:owner_id => @user_leaders.username})
    #@leader_photos = Photos.where({:owner_id => user_leaders.id})

    render({:template => "/users/feed"})
    #defensive coding example here!!!!! - Dane
    #if @the_user == nil
      #redirect_to("/404")
    #else
      #render({:template => "users/"+@the_user.username+"/feed"})
    #end
  end


  def create
    input_username = params.fetch("query_username")
  
    a_new_user = User.new
    a_new_user.username = input_username 
  
    a_new_user.save
  
    redirect_to("/users/"+a_new_user.username)
  
  end

  def update
    query_username = params.fetch("query_username")
    input_username = params.fetch("path_id")
  
    matching_users= User.where({:username => input_username})
    the_user = matching_users.first
  
    the_user.username = query_username
  
    the_user.save
  
    redirect_to("/users/"+the_user.username)
  end

end
