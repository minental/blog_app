require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { described_class.new(content: "comment1",
                                post_id: 1) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid with blank content" do
    subject.content = ""
    expect(subject).to_not be_valid
  end
  it "is not valid with content length greater than 100" do
    subject.content = "a"*101
    expect(subject).to_not be_valid
  end
  it "is not valid without post id" do
    subject.post_id = nil
    expect(subject).to_not be_valid
  end
end
