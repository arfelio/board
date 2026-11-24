FactoryBot.define do
  factory :user do
    sequence(:login)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password { "password" }
    password_confirmation { "password" }
    address { "New York, NY, USA" }
    city { "New York" }
    country { "United States" }
    state { "New York" }
    zip { "94101" }
    bday { "10.01.2014" }
    sequence(:full_name)  { |n| "Person #{n}" }

    factory :admin do
      after(:create) {|user| user.add_role(:admin)}
    end
    factory :moderator do
      after(:create) {|user| user.add_role(:moderator)}
    end
  end
  factory :advertisement do
    user 
    content { "lorem ipsum" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg') }
  end
  factory :comment do
    user
    advertisement
    content { "Lorem ipsum" }
  end
end