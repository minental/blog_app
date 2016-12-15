require 'rails_helper'

describe "PostsController" do
  it "routes get index" do
    expect(get: "posts").to route_to(
                                controller: "posts",
                                action: "index")
  end


    it "routes get show" do
      expect(get: "posts/1").to route_to(
                                  controller: "posts",
                                  action: "show",
                                  id: "1")
    end

    it "routes post create" do
      expect(post: "posts").to route_to(
                                      controller: "posts",
                                      action: "create")
    end

    it "routes get edit" do
      expect(get: "posts/1/edit").to route_to(
                                            controller: "posts",
                                            action: "edit",
                                            id: "1")
    end

    it "routes patch update" do
      expect(patch: "posts/1").to route_to(
                                       controller: "posts",
                                       action: "update",
                                       id: "1")
    end

    it "routes delete destroy" do
      expect(delete: "posts/1").to route_to(
                                          controller: "posts",
                                          action: "destroy",
                                          id: "1")
    end

    it " does not route to get new" do
      expect(get: "posts/new").to_not be_routable
    end
end