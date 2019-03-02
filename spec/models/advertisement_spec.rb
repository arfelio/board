require 'spec_helper'
describe "Advertisement" do
  subject { @advertisement }

  before(:each) do
    @advertisement = FactoryGirl.create(:advertisement)
  end

  context "fields" do
    it { should respond_to(:user) }
    it { should respond_to(:content) }
    it { should respond_to(:image) }
  end
  context 'associations' do
    it { should have_many(:comment) }
    it { should belong_to(:user) }
  end
  context "validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:content) }

    describe "then content is too long" do
      before do
        @advertisement.content = "a"*1001
      end
      it { should_not be_valid }
    end
  end
end
