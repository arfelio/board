require 'spec_helper'

describe Advertisement, ".text_search", type: :model do
  let(:user) { FactoryBot.create(:user) }
  let!(:guitar)  { FactoryBot.create(:advertisement, user: user, title: "Vintage Guitar", content: "Barely used") }
  let!(:amp)     { FactoryBot.create(:advertisement, user: user, title: "Amp", content: "Works with any guitar") }
  let!(:sale)    { FactoryBot.create(:advertisement, user: user, title: "Sofa", content: "50% off this week") }

  it "matches title or content, case-insensitively" do
    expect(Advertisement.text_search("gUiTaR")).to match_array [guitar, amp]
  end

  it "ignores surrounding whitespace" do
    expect(Advertisement.text_search("  sofa ")).to eq [sale]
  end

  it "treats % and _ literally" do
    expect(Advertisement.text_search("50%")).to eq [sale]
    expect(Advertisement.text_search("%")).to eq [sale]
    expect(Advertisement.text_search("_")).to be_empty
  end

  it "returns everything for a blank query" do
    expect(Advertisement.text_search("")).to match_array [guitar, amp, sale]
    expect(Advertisement.text_search(nil)).to match_array [guitar, amp, sale]
  end
end
