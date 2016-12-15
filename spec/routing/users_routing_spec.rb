require 'rails_helper'

describe "UsersController" do
  it "routes get index" do
    expect(get: "users").to route_to(
                                controller: "users",
                                action: "index")
  end


  it "routes get show" do
    expect(get: "users/1").to route_to(
                                  controller: "users",
                                  action: "show",
                                  id: "1")
  end

  it "routes get edit" do
    expect(get: "users/1/edit").to route_to(
                                       controller: "users",
                                       action: "edit",
                                       id: "1")
  end

  it "routes patch update" do
    expect(patch: "users/1").to route_to(
                                    controller: "users",
                                    action: "update",
                                    id: "1")
  end

  it "routes delete destroy" do
    expect(delete: "users/1").to route_to(
                                     controller: "users",
                                     action: "destroy",
                                     id: "1")
  end

  it "routes to new" do
    expect(get: "/signup").to route_to(
                                  controller: "users",
                                  action: "new")
  end

  it "routes to create" do
    expect(post: "/signup").to route_to(
                                   controller: "users",
                                   action: "create")
  end

  it " does not route to get new" do
    expect(get: "users/new").to_not be_routable
  end

  it "does not route post create" do
    expect(post: "users").to_not be_routable
  end
end