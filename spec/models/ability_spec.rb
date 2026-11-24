require 'spec_helper'

describe Ability, type: :model do
  let(:owner)          { FactoryGirl.create(:user) }
  let(:other_user)     { FactoryGirl.create(:user) }
  let(:category)       { Category.create!(title: "Cars") }
  let(:advertisement)  { FactoryGirl.create(:advertisement, user: owner) }
  let(:comment)        { FactoryGirl.create(:comment, user: owner, advertisement: advertisement) }

  describe "guest" do
    subject { Ability.new(nil) }

    it { should be_able_to(:read, Advertisement) }
    it { should be_able_to(:read, Comment) }
    it { should be_able_to(:read, User) }
    it { should_not be_able_to(:read, Category) }

    it { should_not be_able_to(:create, Advertisement) }
    it { should_not be_able_to(:update, advertisement) }
    it { should_not be_able_to(:destroy, advertisement) }
    it { should_not be_able_to(:create, Comment) }
    it { should_not be_able_to(:update, comment) }
    it { should_not be_able_to(:create, User) }
  end

  describe "user" do
    subject { Ability.new(owner) }

    it { should be_able_to(:read, Advertisement) }
    it { should be_able_to(:create, Advertisement) }
    it { should be_able_to(:update, advertisement) }
    it { should be_able_to(:destroy, advertisement) }

    it { should be_able_to(:create, Comment) }
    it { should be_able_to(:update, comment) }
    it { should be_able_to(:destroy, comment) }

    it { should be_able_to(:read, other_user) }
    it { should_not be_able_to(:update, other_user) }
    it { should_not be_able_to(:destroy, other_user) }
    it { should_not be_able_to(:create, User) }

    it { should_not be_able_to(:read, Category) }
    it { should_not be_able_to(:create, Category) }

    context "with someone else's records" do
      subject { Ability.new(other_user) }

      it { should be_able_to(:read, advertisement) }
      it { should_not be_able_to(:update, advertisement) }
      it { should_not be_able_to(:destroy, advertisement) }
      it { should be_able_to(:read, comment) }
      it { should_not be_able_to(:update, comment) }
      it { should_not be_able_to(:destroy, comment) }
    end
  end

  describe "moderator" do
    subject { Ability.new(FactoryGirl.create(:moderator)) }

    it { should be_able_to(:update, advertisement) }
    it { should be_able_to(:destroy, advertisement) }
    it { should be_able_to(:update, comment) }
    it { should be_able_to(:destroy, comment) }
    it { should be_able_to(:manage, category) }

    it { should be_able_to(:read, other_user) }
    it { should_not be_able_to(:update, other_user) }
    it { should_not be_able_to(:destroy, other_user) }
    it { should_not be_able_to(:create, User) }
  end

  describe "admin" do
    subject { Ability.new(FactoryGirl.create(:admin)) }

    it { should be_able_to(:manage, advertisement) }
    it { should be_able_to(:manage, comment) }
    it { should be_able_to(:manage, category) }
    it { should be_able_to(:manage, other_user) }
    it { should be_able_to(:create, User) }
  end
end
