require 'spec_helper'
require 'carrierwave/test/matchers'

# Image processing is disabled globally in test (config/initializers/carrierwave.rb),
# so the upload specs never resize anything. This spec turns it on to make sure the
# thumbnail version is really generated (it would catch a broken RMagick/MiniMagick setup).
describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:advertisement) { FactoryBot.create(:advertisement) }
  let(:uploader)      { ImageUploader.new(advertisement, :image) }
  let(:fixture)       { Rails.root.join('spec/fixtures/files/image.jpg') } # 800x531

  before do
    ImageUploader.enable_processing = true
    File.open(fixture) { |f| uploader.store!(f) }
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  it "keeps the original size" do
    expect(uploader).to have_dimensions(800, 531)
  end

  it "scales the thumb version down to fit 200x200" do
    expect(uploader.thumb).to have_dimensions(200, 133)
  end

  it "only accepts image extensions" do
    expect(uploader.extension_white_list).to match_array %w(jpg jpeg gif png)
  end
end
