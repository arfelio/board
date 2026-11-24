require 'spec_helper'
describe "Advertisement" do
  subject(:advertisement) { FactoryBot.create(:advertisement, user: user) }
  let(:user) {  FactoryBot.create(:user)}
  

  context "fields" do
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:image) }
  end
  context 'associations' do
    it { is_expected.to have_many(:comment) }
    it { is_expected.to belong_to(:user) }
  end
  context "validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:content) }

    describe "then content is too long" do
      before do
        advertisement.content = "a"*1001
      end
      it { is_expected.not_to be_valid }
    end
  end
end
