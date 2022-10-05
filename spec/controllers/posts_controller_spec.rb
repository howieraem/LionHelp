require 'rails_helper'

describe Api::V1::PostsController do
  let!(:post1) {FactoryBot.create(:post)}
  let!(:test_user) {
    User.create!(email: "admin@columbia.edu", firstName: "a", lastName: "b", password: "test1234")
  }
  let!(:test_user2) {
    User.create!(email: "a@columbia.edu", firstName: "a", lastName: "a", password: "test1234")
  }

  describe 'GET index' do
    it 'should render the index template' do
      Post.create({ :id => 20, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      old_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = old_controller
      get :index, params: { search: "a", location: "b", sort: ""}
      expect(response).to have_http_status(200)
      #expect(response.request.env["action_controller.instance"]).to eql([])
    end

    it 'should show all the post on the page when search and location give NA value' do
      Post.create({ :id => 20, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      old_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = old_controller
      get :index, params: { search: "NA", location: "NA", sort: ""}
      expect(response).to have_http_status(200)
    end

    it 'should sort post by postdate' do
      Post.create({ :id => 20, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      old_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = old_controller
      get :index, params: { search: "NA", location: "NA", sort: "postdate"}
      expect(response).to have_http_status(200)
    end

    it 'should sort post by credit' do
      Post.create({ :id => 20, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      old_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = old_controller
      get :index, params: { search: "NA", location: "NA", sort: "credit"}
      expect(response).to have_http_status(200)
    end

    it 'merge comment into the place' do
      old_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = old_controller
      Post.create({ :id => 20, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2022 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      Comment.create({ :commenter => "abc@columbia.edu", :commentee => "a@columbia.edu", :content => "Instant Help! Really appreciate it!", :postID => 2 })
      get :index, params: { search: "NA", location: "NA", sort: "NA"}
      expect(response).to have_http_status(200)
    end

  end

  describe 'POST #create' do
    it 'creates a new post' do
      expect {post :create, params: {post: FactoryBot.attributes_for(:post)}
      }.to change { Post.count }.by(1)
    end
  end

  describe 'GET #help' do
    it 'should redirect to a new page if post exist and make update if helperStatus false' do
      Post.create({ :id => 20, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      old_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = old_controller
      get :help,  params: { id: 20 }
      post2 = Post.find(20)
      expect(response).to have_http_status(200)
      expect(post2.helperStatus).to eql(true)
      expect(post2.helperEmail).to eql("admin@columbia.edu")
    end

    it 'should redirect to a new page if post exist and skip update if helperStatus true' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => true, :helperEmail => "admin@columbia.edu", :helperComplete => false, :requesterComplete => false })
      old_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = old_controller
      get :help,  params: { id: 1 }
      post3 = Post.find(1)
      expect(response).to have_http_status(200)
      expect(post3.helperStatus).to eql(true)
      expect(post3.helperEmail).to eql("admin@columbia.edu")
    end

    it 'should raise error if post not exist' do
      get :help,  params: { id: 2 }
      expect(JSON.parse(response.body)["error"]).to eql('Post not found!')
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET #cancel' do
    it 'should redirect to a new page if post exist and make update if helperStatus true and helperEmail matches' do
      Post.create({ :id => 20, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => true, :helperEmail => "admin@columbia.edu", :helperComplete => false, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :cancel,  params: { id: 20 }
      post2 = Post.find(20)
      expect(response).to have_http_status(200)
      expect(post2.helperStatus).to eql(false)
      expect(post2.helperEmail).to eql(nil)
    end

    it 'should redirect to a new page if post exist and skip update if helperStatus false' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :cancel,  params: { id: 1 }
      post3 = Post.find(1)
      expect(response).to have_http_status(200)
      expect(post3.helperStatus).to eql(false)
      expect(post3.helperEmail).to eql(nil)
    end

    it 'should redirect to a new page if post exist and skip update if helperEmail does not match' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => true, :helperEmail => "b@columbia.edu", :helperComplete => false, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :cancel,  params: { id: 1 }
      post4 = Post.find(1)
      expect(response).to have_http_status(200)
      expect(post4.helperStatus).to eql(true)
      expect(post4.helperEmail).to eql("b@columbia.edu")
    end

    it 'should raise error if post not exist' do
      get :cancel,  params: { id: 2 }
      expect(JSON.parse(response.body)["error"]).to eql('Post not found!')
      expect(response).to have_http_status(404)
    end
  end

  describe 'PUT #update' do
    it 'updates an existing post with valid parameters' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      put :update, params: { id: 1, title: "b", location: "c", startTime: "11/14/2021 20:50", endTime: "11/14/2021 20:59", taskDetails: "x", credit: 3 }
      post = Post.find(1)
      expect(post.title).to eq("b")
      expect(post.location).to eq("c")
      expect(post.startTime).to eq("11/14/2021 20:50")
      expect(post.endTime).to eq("11/14/2021 20:59")
      expect(post.taskDetails).to eq("x")
      expect(post.credit).to eq(3)
    end

    it 'cannot updates an existing post with invalid parameters' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      put :update, params: { id: 1, title: nil, location: nil, startTime: "11/14/2021 20:50", endTime: "11/14/2021 20:59", taskDetails: "x", credit: "x" }
      expect(response).to have_http_status(400)
    end

    it 'cannot edit a nonexistent post' do
      put :update, params: { id: 1, title: "b", location: "c", startTime: "11/14/2021 20:50", endTime: "11/14/2021 20:59", taskDetails: "x", credit: 3 }
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET #cur_posts' do
    it 'returns posts the user posted and have not confirmed completeness' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "admin@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => false, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :cur_posts
      posts = JSON.parse(response.body)
      expect(posts.length).to eq(1)
    end
  end

  describe 'GET #pre_posts' do
    it 'returns posts the user posted and both sides have confirmed completeness' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "admin@columbia.edu", :helperStatus => false, :helperEmail => nil, :helperComplete => true, :requesterComplete => true })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :pre_posts
      posts = JSON.parse(response.body)
      expect(posts.length).to eq(1)
    end
  end

  describe 'GET #help_history' do
    it 'returns posts the user has clicked help' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => "admin@columbia.edu", :helperComplete => false, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :help_history
      posts = JSON.parse(response.body)
      expect(posts.length).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'should render an existing post' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => false, :helperEmail => "admin@columbia.edu", :helperComplete => false, :requesterComplete => false })
      get :show, params: { id: 1 }
      expect(response).to have_http_status(200)
    end

    it 'should not render a nonexistent post' do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE #destroy' do
    let!(:post1) { FactoryBot.create(:post) }

    it 'destroys an existing post' do
      expect { delete :destroy, params: { id: post1.id }
      }.to change(Post, :count).by(-1)
    end

    it 'does nothing if post id does not exist' do
      expect { delete :destroy, params: { id: 0 }
      }.to change(Post, :count).by(0)
    end
  end

  describe 'POST #comment' do
    it 'creates a new comment' do
      expect {post :comment, params: {postID: 1, commentee: 'a@a.com', commenter: 'b@b.com', content: 'c'}
      }.to change { Comment.count }.by(1)
    end
  end

  describe 'GET #complete' do
    it 'marks a post complete by the helper' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => true, :helperEmail => "admin@columbia.edu", :helperComplete => false, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :complete,  params: { id: 1 }
      post = Post.find(1)
      expect(response).to have_http_status(200)
      expect(post.helperComplete).to eql(true )
    end

    it 'does not mark a post complete if the current user is not the helper' do
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => true, :helperEmail => "b@columbia.edu", :helperComplete => false, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      get :complete,  params: { id: 1 }
      post = Post.find(1)
      expect(response).to have_http_status(200)
      expect(post.helperComplete).to eql(false )
    end

    it 'should raise error if post not exist' do
      get :complete,  params: { id: 2 }
      expect(JSON.parse(response.body)["error"]).to eql('Post not found!')
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET #complete2' do
    it 'marks a post complete by the requester and gives credit to the helper' do
      credit = 2
      requester_email = "a@columbia.edu"
      helper_email = "admin@columbia.edu"
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => credit, :email => requester_email, :helperStatus => true, :helperEmail => helper_email, :helperComplete => true, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: requester_email, password: "test1234", :user => {"email"=>requester_email}}
      @controller = tmp_controller
      pre_credit = User.find_by_email(helper_email).credit
      get :complete2,  params: { id: 1 }
      expect(User.find_by_email(helper_email).credit - pre_credit).to eq(credit)
      expect(response).to have_http_status(200)
      post = Post.find(1)
      expect(post.requesterComplete).to eql(true )
    end

    it 'does not mark a post complete if the current user is not the requester' do
      helper_email = "admin@columbia.edu"
      Post.create({ :id => 1, :title => "a", :location => "b", :startTime => "11/14/2021 20:34", :endTime => "11/14/2021 20:34", :taskDetails => "xxx", :credit => 2, :email => "a@columbia.edu", :helperStatus => true, :helperEmail => helper_email, :helperComplete => true, :requesterComplete => false })
      tmp_controller = @controller
      @controller = Api::V1::UsersController.new
      post :login, params: {email: "admin@columbia.edu", password: "test1234", :user => {"email"=>"admin@columbia.edu"}}
      @controller = tmp_controller
      pre_credit = User.find_by_email(helper_email).credit
      get :complete2,  params: { id: 1 }
      expect(User.find_by_email(helper_email).credit - pre_credit).to eq(0)
      expect(response).to have_http_status(200)
      post = Post.find(1)
      expect(post.requesterComplete).to eql(false )
    end

    it 'should raise error if post not exist' do
      get :complete2,  params: { id: 2 }
      expect(JSON.parse(response.body)["error"]).to eql('Post not found!')
      expect(response).to have_http_status(404)
    end
  end
end