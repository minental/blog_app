require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  subject(:ability){ Ability.new(user) }
  let(:category) { create(:category) }
  let(:unapproved_post) { create(:post, user_id: user.id) }
  let(:approved_post) { create(:post, user_id: user.id, approved: true) }
  let(:another_user) { create(:user) }
  let(:another_user_post) { create(:post, user_id: another_user.id, approved: true) }


  context "for a guest" do
    let(:user) { User.new(role: 0) }

    it{ is_expected.to          be_able_to(:read, User.new) }
    it{ is_expected.to          be_able_to(:read, create(:post, approved:true)) }
    it{ is_expected.to          be_able_to(:create, User.new) }
    it{ is_expected.to          be_able_to(:reset_password, nil) }

    it{ is_expected.not_to      be_able_to(:read, Post.new) }
    it{ is_expected.not_to      be_able_to(:create, Post.new) }
    it{ is_expected.not_to      be_able_to(:create, Comment.new) }
    it{ is_expected.not_to      be_able_to(:create, Category.new) }
    it{ is_expected.not_to      be_able_to(:update, Post.new) }
    it{ is_expected.not_to      be_able_to(:update, Comment.new) }
    it{ is_expected.not_to      be_able_to(:update, User.new) }
    it{ is_expected.not_to      be_able_to(:update, Category.new) }
    it{ is_expected.not_to      be_able_to(:destroy, User.new) }
    it{ is_expected.not_to      be_able_to(:destroy, Post.new) }
    it{ is_expected.not_to      be_able_to(:destroy, Comment.new) }
    it{ is_expected.not_to      be_able_to(:destroy, Category.new) }

    it{ is_expected.not_to      be_able_to(:like, Post.new) }
    it{ is_expected.not_to      be_able_to(:dislike, Post.new) }
  end

  context "for a user" do
    let(:user) { create(:user) }

    it{ is_expected.to          be_able_to(:read, user) }
    it{ is_expected.to          be_able_to(:read, approved_post) }
    it{ is_expected.to          be_able_to(:create, Post.new) }
    it{ is_expected.to          be_able_to(:create, Comment.new) }
    it{ is_expected.to          be_able_to(:update, approved_post) }
    it{ is_expected.to          be_able_to(:update, user) }
    it{ is_expected.to          be_able_to(:destroy, user) }
    it{ is_expected.to          be_able_to(:destroy, approved_post) }
    it{ is_expected.to          be_able_to(:like, approved_post) }
    it{ is_expected.to          be_able_to(:dislike, approved_post) }

    it{ is_expected.not_to      be_able_to(:read, unapproved_post) }
    it{ is_expected.not_to      be_able_to(:create, User.new) }
    it{ is_expected.not_to      be_able_to(:create, Category.new) }
    it{ is_expected.not_to      be_able_to(:update, another_user_post) }
    it{ is_expected.not_to      be_able_to(:update, another_user) }
    it{ is_expected.not_to      be_able_to(:update, Comment.new) }
    it{ is_expected.not_to      be_able_to(:update, category) }
    it{ is_expected.not_to      be_able_to(:destroy, another_user) }
    it{ is_expected.not_to      be_able_to(:destroy, another_user_post) }
    it{ is_expected.not_to      be_able_to(:destroy, Comment.new) }
    it{ is_expected.not_to      be_able_to(:destroy, category) }
    it{ is_expected.not_to      be_able_to(:reset_password, nil) }
  end

  context "for an admin" do
    let(:user) { create(:user, :admin) }

    it{ is_expected.to          be_able_to(:read, user) }
    it{ is_expected.to          be_able_to(:read, approved_post) }
    it{ is_expected.to          be_able_to(:read, unapproved_post) }
    it{ is_expected.to          be_able_to(:create, User.new) }
    it{ is_expected.to          be_able_to(:create, Post.new) }
    it{ is_expected.to          be_able_to(:create, Comment.new) }
    it{ is_expected.to          be_able_to(:create, Category.new) }
    it{ is_expected.to          be_able_to(:update, user) }
    it{ is_expected.to          be_able_to(:update, another_user) }
    it{ is_expected.to          be_able_to(:update, approved_post) }
    it{ is_expected.to          be_able_to(:update, another_user_post) }
    it{ is_expected.to          be_able_to(:update, Comment.new) }
    it{ is_expected.to          be_able_to(:update, category) }
    it{ is_expected.to          be_able_to(:destroy, user) }
    it{ is_expected.to          be_able_to(:destroy, another_user) }
    it{ is_expected.to          be_able_to(:destroy, approved_post) }
    it{ is_expected.to          be_able_to(:destroy, another_user_post) }
    it{ is_expected.to          be_able_to(:destroy, Comment.new) }
    it{ is_expected.to          be_able_to(:destroy, category) }
    it{ is_expected.to          be_able_to(:like, Post.new) }
    it{ is_expected.to          be_able_to(:dislike, Post.new) }
  end
end