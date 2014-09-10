require 'spec_helper'
describe User do
  subject { @user }

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  context "fields" do
    it {should respond_to(:email)}
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:login) }
    it { should respond_to(:address) }
    it { should respond_to(:city) }
    it { should respond_to(:state) }
    it { should respond_to(:country) }
    it { should respond_to(:bday) }
    it { should respond_to(:full_name) }
    it { should respond_to(:zip) }
    it { should respond_to(:provider) }
    it { should respond_to(:uid) }
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) }
  end

  context "associations" do
    it { should have_many(:comment) }
    it { should have_many(:advertisement) }
    it { should have_and_belong_to_many(:role) }
  end

  context "validations" do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:login) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:bday) }
    it { should validate_presence_of(:zip) }

    describe "when login is too long" do
      before { @user.login = "a"*51 }
      it { should_not be_valid }
    end
    describe "when address is too long" do
      before { @user.address = "a"*51 }
      it { should_not be_valid }
    end
    describe "when city is too long" do
      before { @user.city = "a"*51 }
      it { should_not be_valid }
    end
    describe "when state is too long" do
      before { @user.state = "a"*51 }
      it { should_not be_valid }
    end
    describe "when country is too long" do
      before { @user.country = "a"*51 }
      it { should_not be_valid }
    end
    describe "when full_name is too long" do
      before { @user.full_name = "a"*51 }
      it { should_not be_valid }
    end
    describe "when birthday is too long" do
      before { @user.bday = "a"*51 }
      it { should_not be_valid }
    end
    describe "when zipcode is too long" do
      before { @user.zip = "a"*11 }
      it { should_not be_valid }
    end
  end
end