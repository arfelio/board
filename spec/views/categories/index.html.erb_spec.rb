require 'spec_helper'

describe "categories/index" do
  before(:each) do
    assign(:categories, [
      Category.create!(title: "Title"),
      Category.create!(title: "Title")
    ])
  end

  it "renders a list of categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "ul li .thumbnail", 2
  end
end
