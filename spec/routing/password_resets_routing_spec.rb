require 'rails_helper'

describe "PasswordResetsController" do
  it "routes get new" do
    expect(get: "password_resets/new").to route_to(
                                          controller: "password_resets",
                                          action: "new")
  end

  it "routes post create" do
    expect(post: "password_resets").to route_to(
                                           controller: "password_resets",
                                           action: "create")
  end

  it "routes get edit" do
    expect(get: "password_resets/1/edit").to route_to(
                                                 controller: "password_resets",
                                                 action: "edit",
                                                 id: "1")
  end

  it "routes patch update" do
    expect(patch: "password_resets/1").to route_to(
                                              controller: "password_resets",
                                              action: "update",
                                              id: "1")
  end

  it "routes get index" do
    expect(get: "password_resets").to_not be_routable
  end

  it "routes get show" do
    expect(get: "password_resets/1").to_not be_routable
  end

  it "routes delete destroy" do
    expect(delete: "password_resets/1").to_not be_routable
  end
end