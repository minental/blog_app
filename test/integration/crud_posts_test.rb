require 'test_helper'

class CrudPostsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  fixtures :users

  def setup
    @user = users(:one);
  end

  test 'should create post' do
    get '/users/1', params: { user: {id: 1}, session: {user_id: 1} }
    assert_difference'Post.count' do
      post '/posts', params: { post: { title: 'title',
                               content: 'content',
                               picture: 'picture_path' }, session: {user_id: 1} }
    end
  end

  test 'should edit post' do

  end

  test 'should delete post' do

  end
end
