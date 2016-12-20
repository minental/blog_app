require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build(:category) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid with blank name" do
    subject.name = ""
    expect(subject).to_not be_valid
  end
  it "is not valid with name length greater than 51" do
    subject.name = "a"*51
    expect(subject).to_not be_valid
  end
end
