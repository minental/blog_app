require 'rails_helper'

describe "routes for Sessions" do

  it "routes get login" do
    expect(get: "login").to route_to(
                                controller: "sessions",
                                action: "new")
  end


  it "routes post login" do
    expect(post: "login").to route_to(
                                  controller: "sessions",
                                  action: "create")
  end

  it "routes delete logout" do
    expect(delete: "logout").to route_to(
                                       controller: "sessions",
                                       action: "destroy")
  end
end