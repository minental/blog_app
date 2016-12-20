require 'rails_helper'

describe "CategoriesController" do
  it "routes get index" do
    expect(get: "categories").to route_to(
                                controller: "categories",
                                action: "index")
  end

  it "routes post create" do
    expect(post: "categories").to route_to(
                                      controller: "categories",
                                      action: "create")
  end

  it "routes get edit" do
    expect(get: "categories/1/edit").to route_to(
                                            controller: "categories",
                                            action: "edit",
                                            id: "1")
  end

  it "routes patch update" do
    expect(patch: "categories/1").to route_to(
                                         controller: "categories",
                                         action: "update",
                                         id: "1")
  end

  it "routes delete destroy" do
    expect(delete: "categories/1").to route_to(
                                          controller: "categories",
                                          action: "destroy",
                                          id: "1")
  end


  it "routes get show" do
    expect(get: "categories/1").to_not be_routable
  end

  it " does not route to get new" do
    expect(get: "categories/new").to_not be_routable
  end
end