require 'json'
require 'time'
require 'date'

class Api::V1::PostsController < ApplicationController
  # uncomment if testing with postman or CORS
  protect_from_forgery with: :null_session

  def index
    zone = ActiveSupport::TimeZone.new("Eastern Time (US & Canada)")
    time = DateTime.now.in_time_zone(zone)
    @post = Post.all.where(helperStatus: false)
    if params[:search] != 'NA'
      @post = @post.where("title LIKE ?", "%" + params[:search] + "%").or(@post.where('"taskDetails" LIKE ?', "%" + params[:search] + "%"))
    end
    if params[:location] != 'NA'
      @post = @post.where("location LIKE ?", "%" + params[:location] + "%")
    end
    @post = @post.where.not(email: current_user.email)
    if params[:sort] == 'postdate'
      @post = @post.order(created_at: :desc)
    end
    if params[:sort] == 'credit'
      @post = @post.order(credit: :desc)
    end
    @post = @post.select{ |p|
      DateTime.strptime(p.endTime + " EST","%m/%d/%Y %H:%M %Z")>time
    }
    ActiveRecord::Base.include_root_in_json = false
    json_post = JSON.parse(@post.to_json)
    json_post.each do |p|
      @comments = Comment.where(commentee: p['email'])
      p['comments'] = JSON.parse(@comments.to_json)
    end
    render json: json_post
  end

  def create
    post = Post.create!(post_params)
    render json: post
  end

  def cur_posts
    post = Post.where({email: current_user.email, helperComplete: false}).order(created_at: :desc)
    render json: post
  end

  def pre_posts
    post = Post.where({email: current_user.email, helperComplete: true}).order(created_at: :desc)
    render json: post
  end

  def help_history
    post = Post.where(helperEmail: current_user.email).order(created_at: :desc)
    render json: post
  end

  def comment
    Comment.create!(comment_params)
    render json: {"message": "ok"}
  end

  def help
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      post = nil
    end
    if post
      unless post.helperStatus
        post.update(helperStatus: true, helperEmail: current_user.email)
      end
      render json: post
    else
      render json: { error: "Post not found!" }, status: 404
    end
  end

  def cancel
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      post = nil
    end
    if post
      if post.helperStatus and post.helperEmail == current_user.email
        post.update(helperStatus: false, helperEmail: nil)
      end
      render json: post
    else
      render json: { error: "Post not found!" }, status: 404
    end
  end

  def complete
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      post = nil
    end
    if post
      if post.helperStatus and post.helperEmail == current_user.email
        post.update(helperComplete: true)
      end
      render json: post
    else
      render json: { error: "Post not found!" }, status: 404
    end
  end

  def complete2
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      post = nil
    end
    if post
      if post.helperComplete and !post.requesterComplete and post.email == current_user.email
        post.update(requesterComplete: true)
        helper = User.find_by_email(post.helperEmail)
        helper.update_attribute(:credit, helper.credit + post.credit)
        requester = User.find_by_email(current_user.email)
        requester.update_attribute(:credit, requester.credit - post.credit)
      end
      render json: post
    else
      render json: { error: "Post not found!" }, status: 404
    end
  end

  def show
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      post = nil
    end
    if post
      render json: post
    else
      render json: { error: "Post not found!" }, status: 404
    end
  end

  def update
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      post = nil
    end
    unless post
      render json: { error: "Post not found!" }, status: 404
      return
    end
    if post.update(update_params)
      render json: { message: 'Post updated!' }
    else
      render json: { error: 'Failed to update the post!' }, status: 400
    end
  end

  def destroy
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      post = nil
    end
    post&.destroy
    render json: { message: 'Post deleted!' }
  end

  def comment_params
    params.permit(:postID, :commenter, :commentee, :content)
  end

  def post_params
    params.require(:post).permit(:title, :location, :room, :startTime, :endTime, :taskDetails, :credit, :email, :helperStatus, :helperEmail, :helperComplete, :requesterComplete).with_defaults(helperStatus: false, helperEmail: "null", helperComplete: false, requesterComplete: false)
  end

  def update_params
    params.permit(:title, :location, :room, :startTime, :endTime, :taskDetails, :credit)
  end

end
