require 'spec_helper'
describe "Comment" do
  subject { @comment }
  before do
    @comment = FactoryGirl.create(:comment)
  end

  context "fields" do
    it { should respond_to(:content)}
  end
  context "validations" do
    it { should validate_presence_of(:content)}
  end
end
