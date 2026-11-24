require 'spec_helper'
describe User, type: :model do
  subject { @user }

  before(:each) do
    @user = FactoryBot.create(:user)
  end

  context "fields" do
    it {is_expected.to respond_to(:email)}
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:login) }
    it { is_expected.to respond_to(:address) }
    it { is_expected.to respond_to(:city) }
    it { is_expected.to respond_to(:state) }
    it { is_expected.to respond_to(:country) }
    it { is_expected.to respond_to(:bday) }
    it { is_expected.to respond_to(:full_name) }
    it { is_expected.to respond_to(:zip) }
    it { is_expected.to respond_to(:latitude) }
    it { is_expected.to respond_to(:longitude) }
  end

  context "associations" do
    it { is_expected.to have_many(:comment) }
    it { is_expected.to have_many(:advertisement) }
    it { is_expected.to have_and_belong_to_many(:roles) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:login) }
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:bday) }
    it { is_expected.to validate_presence_of(:zip) }

    describe "when login is too long" do
      before { @user.login = "a"*1151 }
      it { is_expected.not_to be_valid }
    end
    describe "when address is too long" do
      before { @user.address = "a"*151 }
      it { is_expected.not_to be_valid }
    end
    describe "when city is too long" do
      before { @user.city = "a"*151 }
      it { is_expected.not_to be_valid }
    end
    describe "when state is too long" do
      before { @user.state = "a"*151 }
      it { is_expected.not_to be_valid }
    end
    describe "when country is too long" do
      before { @user.country = "a"*151 }
      it { is_expected.not_to be_valid }
    end
    describe "when full_name is too long" do
      before { @user.full_name = "a"*151 }
      it { is_expected.not_to be_valid }
    end
    describe "when birthday is too long" do
      before { @user.bday = "a"*151 }
      it { is_expected.not_to be_valid }
    end
    describe "when zipcode is too long" do
      before { @user.zip = "a"*11 }
      it { is_expected.not_to be_valid }
    end
  end
end