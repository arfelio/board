require 'spec_helper'

describe "categories/show" do
  before(:each) do
    @category = assign(:category, Category.create!(title: "Title"))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Title/)
  end
end
