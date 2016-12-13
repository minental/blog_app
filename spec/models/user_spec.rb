require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(name: "user",
                                email: "user@example.com",
                                password: "qwerty",
                                password_confirmation: "qwerty") }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid with blank name" do
    subject.name = ""
    expect(subject).to_not be_valid
  end
  it "is not valid with name length greater than 50" do
    subject.name = "a"*51
    expect(subject).to_not be_valid
  end
  it "is not valid with blank email" do
    subject.email = ""
    expect(subject).to_not be_valid
  end
  it "is not valid with email length greater than 255" do
    subject.email = "user@email.com" + "a"*256
    expect(subject).to_not be_valid
  end
  it "is not valid with wrong format email" do
    subject.email = "user@email"
    expect(subject).to_not be_valid
  end
  it "is not valid with blank password" do
    subject.password = ""
    subject.password_confirmation = ""
    expect(subject).to_not be_valid
  end
  it "is not valid with password length less than 6" do
    subject.password = "pass"
    expect(subject).to_not be_valid
  end
  it "is not valid with password confirmation not matching password" do
    subject.password_confirmation = "password"
    expect(subject).to_not be_valid
  end
end
