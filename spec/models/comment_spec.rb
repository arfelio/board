require 'spec_helper'
describe "Comment" do
  subject { @comment }
  before do
    @comment = FactoryBot.create(:comment)
  end

  context "fields" do
    it { is_expected.to respond_to(:content)}
  end
  context "validations" do
    it { is_expected.to validate_presence_of(:content)}
  end
end
