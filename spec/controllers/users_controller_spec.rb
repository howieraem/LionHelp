require 'rails_helper'

describe Api::V1::UsersController do
    let!(:test_user) {
      User.create!(email: "admin@columbia.edu", firstName: "a", lastName: "b", password: "test1234")
    }

    describe 'POST login' do
      it 'user should login successful' do
        post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST login' do
      it 'user should login fail' do
        post :login, params: {email: "admin1@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
        expect(JSON.parse(response.body)["error"]).to eql('Incorrect email or password.')
        expect(response).to have_http_status(401)
      end
    end


    describe 'POST user create' do
      it 'user register fail of format error' do
        expect {post :create, params: {email: "admin@gmail.edu", firstName: "a", lastName: "b", password: "test1234"}
        expect(JSON.parse(response.body)["error"]).to eql('Email wrong format, please use your LionMail.')
        }.to change { User.count }.by(0)
      end
    end

    describe 'POST user create' do
      it 'user register fail of uniq email error' do
        expect {post :create, params: {email: "admin@columbia.edu", firstName: "a", lastName: "b", password: "test1234"}
        expect(JSON.parse(response.body)["error"]).to eql('Email has already been taken')
        }.to change { User.count }.by(0)
      end
    end

    describe 'POST user create' do
      it 'user register successful' do
        expect {post :create, params: {email: "admin200@columbia.edu", firstName: "a", lastName: "b", password: "test1234"}
          }.to change { User.count }.by(1)
      end
    end

    describe 'GET user get' do
      it 'get a user\'s profile' do
        User.create({ :id => 1, :email => "a@columbia.edu", :firstName => "a", :lastName => "b", :password => "test1234"})
        get :get, params: {id: 1}
        json = JSON.parse(response.body)
        expect(json['email']).to eql('a@columbia.edu')
        expect(json['firstName']).to eq('a')
        expect(json['lastName']).to eq('b')
        expect(json['credit']).to eq(1000)
      end
    end

    describe 'GET user get non-existent' do
      it 'get a user\'s profile which does not exist' do
        get :get, params: {id: 2}
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eql('User not found!')
      end
    end

    describe 'PUT user edit_profile' do
      it 'update user attribute(s)' do
        User.create({ :id => 1, :email => "a@columbia.edu", :firstName => "a", :lastName => "b", :password => "test1234"})
        put :edit_profile, params: {:id => 1, :firstName => "b", :lastName => "c"}
        expect(response).to have_http_status(200)
        user = User.find(1)
        expect(user.firstName).to eq("b")
        expect(user.lastName).to eq("c")
      end
    end

    describe 'PUT user edit_profile invalid' do
      it 'update user attribute(s) with invalid data' do
        User.create({ :id => 1, :email => "a@columbia.edu", :firstName => "a", :lastName => "b", :password => "test1234"})
        put :edit_profile, params: {:id => 1, :firstName => ""}
        expect(JSON.parse(response.body)["error"]).to eq('Your first name cannot be blank!')
        expect(response).to have_http_status(400)

        put :edit_profile, params: {:id => 1, :lastName => ""}
        expect(JSON.parse(response.body)["error"]).to eq('Your last name cannot be blank!')
        expect(response).to have_http_status(400)
      end
    end

    describe 'PUT user edit_profile non-existent' do
      it 'update attribute(s) of a user that does not exist' do
        put :edit_profile, params: {:id => 2, :firstName => "b", :lastName => "c"}
        expect(response).to have_http_status(404)
      end
    end

    describe "GET get_cur_usr" do
      it 'get user id and email with a token in header' do
        post :create, params: {email: "b@columbia.edu", firstName: "a", lastName: "b", password: "test1234"}
        token = JSON.parse(response.body)["token"]
        request.headers["Authorization"] = token
        get :get_cur_usr
        user_data = JSON.parse(response.body)["user"]
        expect(user_data["email"]).to eq("b@columbia.edu")
      end
    end

    describe "GET get_cur_usr no token" do
      it 'cannot get user id and email without a token in header' do
        get :get_cur_usr
        expect(response).to have_http_status(401)
      end
    end
  end