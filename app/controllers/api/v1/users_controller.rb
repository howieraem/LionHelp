class Api::V1::UsersController < ApplicationController
  # uncomment if testing with postman or CORS
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def get
    user = User.where(id: params[:id]).pluck(:email, :firstName, :lastName, :credit)
    if user.length > 0
      render json: { email: user[0][0], firstName: user[0][1], lastName: user[0][2], credit: user[0][3] }
    else
      render json: { error: 'User not found!' }, status: 404
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      login
    else
      render json: { error: user.errors.full_messages[0] }, status: 400
    end
  end

  def login
    token = login_and_issue_token(params[:email], params[:password])
    if token
      render json: {
        user: UserSerializer.new(current_user),
        token: token
      }
    else
      render json: { error: 'Incorrect email or password.' }, status: 401
    end
  end

  def get_cur_usr
    if current_user
      render json: {
        user: UserSerializer.new(current_user)
      }
    else
      render json: { error: 'You are not authorized.' }, status: 401
    end
  end

  def edit_profile
    # Note: update_attribute() skips validation
    user = User.find(params[:id])
    if params.has_key?(:firstName)
      if params[:firstName].nil? || params[:firstName].length == 0
        render json: { error: 'Your first name cannot be blank!' }, status: 400
        return
      end
      user.update_attribute(:firstName, params[:firstName])
    end
    if params.has_key?(:lastName)
      if params[:lastName].nil? || params[:lastName].length == 0
        render json: { error: 'Your last name cannot be blank!' }, status: 400
        return
      end
      user.update_attribute(:lastName, params[:lastName])
    end
    render json: { message: 'User profile updated!' }
  end

  def record_not_found(error)
    render json: { error: error.message }, status: 404
  end

  def user_params
    params.permit(:email, :password, :firstName, :lastName)
  end

end
