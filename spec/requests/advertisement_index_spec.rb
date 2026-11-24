require 'spec_helper'

describe "advertisement index" do
  subject { page }

  let(:alice) { FactoryGirl.create(:user) }
  let(:bob)   { FactoryGirl.create(:user) }

  describe "filtering by category" do
    let!(:bikes) { Category.create!(title: "Bikes") }
    let!(:cars)  { Category.create!(title: "Cars") }
    let!(:bike_ad) { FactoryGirl.create(:advertisement, user: alice, category: bikes, content: "Red mountain bike") }
    let!(:car_ad)  { FactoryGirl.create(:advertisement, user: alice, category: cars, content: "Old blue sedan") }

    before do
      visit advertisements_path
      click_link "Bikes"
    end

    it { should have_content("Red mountain bike") }
    it { should_not have_content("Old blue sedan") }
  end

  describe "filtering by user" do
    let!(:alice_ad) { FactoryGirl.create(:advertisement, user: alice, content: "Alice sells a lamp") }
    let!(:bob_ad)   { FactoryGirl.create(:advertisement, user: bob, content: "Bob sells a chair") }

    before { visit advertisements_path(user_id: bob.id) }

    it { should have_content("Bob sells a chair") }
    it { should_not have_content("Alice sells a lamp") }
  end

  describe "search" do
    let!(:by_title)   { FactoryGirl.create(:advertisement, user: alice, title: "Vintage Guitar", content: "Barely used") }
    let!(:by_content) { FactoryGirl.create(:advertisement, user: alice, title: "Music stuff", content: "Amp for a guitar") }
    let!(:unrelated)  { FactoryGirl.create(:advertisement, user: alice, title: "Sofa", content: "Comfortable sofa") }

    describe "with a matching query" do
      before { visit advertisements_path(query: "GUITAR") }

      it { should have_content("Barely used") }
      it { should have_content("Amp for a guitar") }
      it { should_not have_content("Comfortable sofa") }
    end

    describe "with no matches" do
      before { visit advertisements_path(query: "piano") }

      it { should_not have_selector("li.span4") }
    end

    describe "with LIKE wildcards in the query" do
      before { visit advertisements_path(query: "%") }

      it { should_not have_selector("li.span4") }
    end
  end

  describe "pagination" do
    before do
      11.times { |n| FactoryGirl.create(:advertisement, user: alice, content: "Ad number #{n}") }
      visit advertisements_path
    end

    it { should have_selector("li.span4", count: 10) }
    it { should have_selector("div.pagination") }

    describe "second page" do
      before { visit advertisements_path(page: 2) }

      it { should have_selector("li.span4", count: 1) }
    end
  end
end
