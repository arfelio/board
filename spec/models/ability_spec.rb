require 'spec_helper'
require "cancan/matchers"
describe "Ability" do
  context "guest ability" do
    user = User.new
    ability = Ability.new(user)
    it "should can read all" do
      ability.should be_able_to(:read,:all)
    end
  end
  context "logged user ability" do
    user1 = FactoryGirl.create(:user,email:"example@mail.com")
    ability = Ability.new(user1)
    after(:all)  { User.delete_all }

    it "should be able to manage his advertisements" do
      ability.should be_able_to(:manage, Advertisement.new(:user => user1))
    end
    it "should be able to create advertisement" do
      ability.should be_able_to(:create, Advertisement)
    end
    it "should be able to read another advertisements" do
      ability.should be_able_to(:read, Advertisement)
    end
    it "should be able to manage his comments" do
      ability.should be_able_to(:manage, Comment)
    end
    it "should be able to create comments" do
      ability.should be_able_to(:create, Comment)
    end
    it "should be able to read another comments" do
      ability.should be_able_to(:read, Comment)
    end

    it "should be able to read  user profiles" do
      ability.should be_able_to(:read, User)
    end
    it "should not be able to manage  user roles" do
      ability.should_not be_able_to(:manage, Role)
    end
  end
  context "moderator ability" do
    user2 = FactoryGirl.create(:moderator,email:"moderator@mail.com")
    ability = Ability.new(user2)
    after(:all)  { User.delete_all }

    it "should be able to manage all advertisements" do
      ability.should be_able_to(:manage, Advertisement)
    end
    it "should be able to manage all comments" do
      ability.should be_able_to(:manage, Comment)
    end
    it "should  be able to read all users" do
      ability.should be_able_to(:read, User)
    end
    it "should not be able to manage users role" do
      ability.should_not be_able_to(:manage, Role)
    end
  end
  context "admin ability" do
    user3 = FactoryGirl.create(:admin, email:"admin@mail.com")
    ability = Ability.new(user3)
    after(:all) { User.delete_all}

    it "should be able to manage all" do
      ability.should be_able_to(:manage,:all)
    end
  end
end


















