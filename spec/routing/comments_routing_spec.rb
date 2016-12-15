require "rails_helper"

describe "routes for Comments" do

  it "routes post create" do
    expect(post: "posts/1/comments").to route_to(
                                controller: "comments",
                                post_id: "1",
                                action: "create")
  end

  it "routes get edit" do
    expect(get: "posts/1/comments/1/edit").to route_to(
                                       controller: "comments",
                                       post_id: "1",
                                       action: "edit",
                                       id: "1")
  end

  it "routes patch update" do
    expect(patch: "posts/1/comments/1").to route_to(
                                    controller: "comments",
                                    post_id: "1",
                                    action: "update",
                                    id: "1")
  end

  it "routes delete destroy" do
    expect(delete: "posts/1/comments/1").to route_to(
                                     controller: "comments",
                                     post_id: "1",
                                     action: "destroy",
                                     id: "1")
  end

  it "does not route to get index" do
    expect(get: "posts/1/comments").to_not be_routable
  end

  it " does not route to get new" do
    expect(get: "posts/1/comments/new").to_not be_routable
  end

  it "does not route get show" do
    expect(get: "posts/1/comments/1").to_not be_routable
  end
end