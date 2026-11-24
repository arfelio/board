require 'spec_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  let(:owner)          { FactoryBot.create(:user) }
  let(:other_user)     { FactoryBot.create(:user) }
  let(:category)       { Category.create!(title: "Cars") }
  let(:advertisement)  { FactoryBot.create(:advertisement, user: owner) }
  let(:comment)        { FactoryBot.create(:comment, user: owner, advertisement: advertisement) }

  describe "guest" do
    subject { Ability.new(nil) }

    it { is_expected.to be_able_to(:read, Advertisement) }
    it { is_expected.to be_able_to(:read, Comment) }
    it { is_expected.to be_able_to(:read, User) }
    it { is_expected.not_to be_able_to(:read, Category) }

    it { is_expected.not_to be_able_to(:create, Advertisement) }
    it { is_expected.not_to be_able_to(:update, advertisement) }
    it { is_expected.not_to be_able_to(:destroy, advertisement) }
    it { is_expected.not_to be_able_to(:create, Comment) }
    it { is_expected.not_to be_able_to(:update, comment) }
    it { is_expected.not_to be_able_to(:create, User) }
  end

  describe "user" do
    subject { Ability.new(owner) }

    it { is_expected.to be_able_to(:read, Advertisement) }
    it { is_expected.to be_able_to(:create, Advertisement) }
    it { is_expected.to be_able_to(:update, advertisement) }
    it { is_expected.to be_able_to(:destroy, advertisement) }

    it { is_expected.to be_able_to(:create, Comment) }
    it { is_expected.to be_able_to(:update, comment) }
    it { is_expected.to be_able_to(:destroy, comment) }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.not_to be_able_to(:update, other_user) }
    it { is_expected.not_to be_able_to(:destroy, other_user) }
    it { is_expected.not_to be_able_to(:create, User) }

    it { is_expected.not_to be_able_to(:read, Category) }
    it { is_expected.not_to be_able_to(:create, Category) }

    context "with someone else's records" do
      subject { Ability.new(other_user) }

      it { is_expected.to be_able_to(:read, advertisement) }
      it { is_expected.not_to be_able_to(:update, advertisement) }
      it { is_expected.not_to be_able_to(:destroy, advertisement) }
      it { is_expected.to be_able_to(:read, comment) }
      it { is_expected.not_to be_able_to(:update, comment) }
      it { is_expected.not_to be_able_to(:destroy, comment) }
    end
  end

  describe "moderator" do
    subject { Ability.new(FactoryBot.create(:moderator)) }

    it { is_expected.to be_able_to(:update, advertisement) }
    it { is_expected.to be_able_to(:destroy, advertisement) }
    it { is_expected.to be_able_to(:update, comment) }
    it { is_expected.to be_able_to(:destroy, comment) }
    it { is_expected.to be_able_to(:manage, category) }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.not_to be_able_to(:update, other_user) }
    it { is_expected.not_to be_able_to(:destroy, other_user) }
    it { is_expected.not_to be_able_to(:create, User) }
  end

  describe "admin" do
    subject { Ability.new(FactoryBot.create(:admin)) }

    it { is_expected.to be_able_to(:manage, advertisement) }
    it { is_expected.to be_able_to(:manage, comment) }
    it { is_expected.to be_able_to(:manage, category) }
    it { is_expected.to be_able_to(:manage, other_user) }
    it { is_expected.to be_able_to(:create, User) }
  end
end
