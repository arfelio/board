require 'spec_helper'

describe "categories/new" do
  before(:each) do
    assign(:category, Category.new(title: "MyString"))
  end

  it "renders new category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", categories_path, "post" do
      assert_select "input#category_title[name=?]", "category[title]"
    end
  end
end
