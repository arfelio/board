require 'spec_helper'

# belongs_to is required by default since the Rails 5.0 defaults were switched on.
# Optional associations are marked with `optional: true` in the models.
describe "required associations", type: :model do
  it "requires a comment to have a user and an advertisement" do
    comment = Comment.new(content: "Hello")

    expect(comment).not_to be_valid
    expect(comment.errors[:user]).to include("must exist")
    expect(comment.errors[:advertisement]).to include("must exist")
  end

  it "allows an advertisement without a category" do
    advertisement = FactoryBot.build(:advertisement, category: nil)

    expect(advertisement).to be_valid
  end

  it "allows global roles without a resource" do
    expect(Role.new(name: "admin")).to be_valid
  end
end
