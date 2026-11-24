require 'spec_helper'

describe "advertisement index" do
  subject { page }

  let(:alice) { FactoryBot.create(:user) }
  let(:bob)   { FactoryBot.create(:user) }

  describe "filtering by category" do
    let!(:bikes) { Category.create!(title: "Bikes") }
    let!(:cars)  { Category.create!(title: "Cars") }
    let!(:bike_ad) { FactoryBot.create(:advertisement, user: alice, category: bikes, content: "Red mountain bike") }
    let!(:car_ad)  { FactoryBot.create(:advertisement, user: alice, category: cars, content: "Old blue sedan") }

    before do
      visit advertisements_path
      click_link "Bikes"
    end

    it { is_expected.to have_content("Red mountain bike") }
    it { is_expected.not_to have_content("Old blue sedan") }
  end

  describe "filtering by user" do
    let!(:alice_ad) { FactoryBot.create(:advertisement, user: alice, content: "Alice sells a lamp") }
    let!(:bob_ad)   { FactoryBot.create(:advertisement, user: bob, content: "Bob sells a chair") }

    before { visit advertisements_path(user_id: bob.id) }

    it { is_expected.to have_content("Bob sells a chair") }
    it { is_expected.not_to have_content("Alice sells a lamp") }
  end

  describe "search" do
    let!(:by_title)   { FactoryBot.create(:advertisement, user: alice, title: "Vintage Guitar", content: "Barely used") }
    let!(:by_content) { FactoryBot.create(:advertisement, user: alice, title: "Music stuff", content: "Amp for a guitar") }
    let!(:unrelated)  { FactoryBot.create(:advertisement, user: alice, title: "Sofa", content: "Comfortable sofa") }

    describe "with a matching query" do
      before { visit advertisements_path(query: "GUITAR") }

      it { is_expected.to have_content("Barely used") }
      it { is_expected.to have_content("Amp for a guitar") }
      it { is_expected.not_to have_content("Comfortable sofa") }
    end

    describe "with no matches" do
      before { visit advertisements_path(query: "piano") }

      it { is_expected.not_to have_selector(".advertisement") }
    end

    describe "with LIKE wildcards in the query" do
      before { visit advertisements_path(query: "%") }

      it { is_expected.not_to have_selector(".advertisement") }
    end
  end

  describe "pagination" do
    before do
      11.times { |n| FactoryBot.create(:advertisement, user: alice, content: "Ad number #{n}") }
      visit advertisements_path
    end

    it { is_expected.to have_selector(".advertisement", count: 10) }
    it { is_expected.to have_selector("nav ul.pagination li.page-item.active", text: "1") }
    it { is_expected.to have_link("2", href: advertisements_path(page: 2)) }

    describe "second page" do
      before { visit advertisements_path(page: 2) }

      it { is_expected.to have_selector(".advertisement", count: 1) }
    end
  end

  # With many pages will_paginate collapses the middle into a gap ("…"), which
  # BootstrapLinkRenderer renders as a disabled page item.
  describe "pagination with many pages" do
    before do
      now = Time.current
      Advertisement.insert_all(
        Array.new(125) { |n| { user_id: alice.id, content: "Bulk ad #{n}", created_at: now, updated_at: now } }
      )
      visit advertisements_path
    end

    it { is_expected.to have_selector("ul.pagination li.page-item.disabled span.page-link", text: "…") }
    it { is_expected.to have_link("13", href: advertisements_path(page: 13)) }
    # Page 1 of 13 shows 1–9, then the gap, then 12 and 13
    it { is_expected.not_to have_link("11", href: advertisements_path(page: 11)) }
  end

  # Images are optional, and Rails 5.1+ asset helpers are stricter about the path
  # they are given (assets.unknown_asset_fallback = false).
  describe "an advertisement without an image" do
    let!(:advertisement) { FactoryBot.create(:advertisement, user: alice, image: nil, content: "No picture here") }

    describe "in the list" do
      before { visit advertisements_path }

      it { is_expected.to have_content("No picture here") }
    end

    describe "on its own page" do
      before { visit advertisement_path(advertisement) }

      it { is_expected.to have_content("No picture here") }
    end
  end
end
