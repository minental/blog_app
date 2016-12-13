require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { described_class.new(title: "post1",
                                content: "post1",
                                user_id: 1) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid with blank title" do
    subject.title = ""
    expect(subject).to_not be_valid
  end
  it "is not valid with title length greater than 40" do
    subject.title = "a"*41
    expect(subject).to_not be_valid
  end
  it "is not valid with blank content" do
    subject.content = ""
    expect(subject).to_not be_valid
  end
  it "is not valid with content length greater than 150" do
    subject.content = "a"*151
    expect(subject).to_not be_valid
  end
  it "is not valid without user id" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end
end
