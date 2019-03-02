include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :user do
    sequence(:login)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "password"
    password_confirmation "password"
    address "New York, NY, USA"
    city "New York"
    country "United States"
    state "New York"
    zip "94101"
    bday "10.01.2014"
    full_name "Ivan ivanov"

    factory :admin do
      after(:create) {|user| user.add_role(:admin)}
    end
    factory :moderator do
      after(:create) {|user| user.add_role(:moderator)}
    end
  end
  factory :advertisement do
    user 
    content "lorem ipsum"
    image {fixture_file_upload('spec/fixtures/files/image.jpg', 'image/jpg')}
  end
  factory :comment do
    content "Lorem ipsum"
  end
end