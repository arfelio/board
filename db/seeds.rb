# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users live in real cities with known coordinates, so their profile maps show
# something. Seeding doesn't call the geocoder (Nominatim allows one request per
# second, and Faker street addresses are made up): the lookup is stubbed to find
# nothing, which keeps the coordinates given here.
Geocoder.configure(lookup: :test)
Geocoder::Lookup::Test.set_default_stub([])

CITIES = [
  { city: "Paris",     state: "Ile-de-France", country: "France",         latitude: 48.8566, longitude: 2.3522 },
  { city: "Berlin",    state: "Berlin",        country: "Germany",        latitude: 52.5200, longitude: 13.4050 },
  { city: "Madrid",    state: "Madrid",        country: "Spain",          latitude: 40.4168, longitude: -3.7038 },
  { city: "Rome",      state: "Lazio",         country: "Italy",          latitude: 41.9028, longitude: 12.4964 },
  { city: "Vienna",    state: "Vienna",        country: "Austria",        latitude: 48.2082, longitude: 16.3738 },
  { city: "Amsterdam", state: "North Holland", country: "Netherlands",    latitude: 52.3676, longitude: 4.9041 },
  { city: "Lisbon",    state: "Lisbon",        country: "Portugal",       latitude: 38.7223, longitude: -9.1393 },
  { city: "London",    state: "England",       country: "United Kingdom", latitude: 51.5072, longitude: -0.1276 }
].freeze

def seed_user(email)
  User.create!(CITIES.sample.merge(
    email: email, password: "password", password_confirmation: "password",
    address: Faker::Address.street_address, zip: Faker::Address.zip_code,
    bday: Date.today, full_name: Faker::Name.name, login: Faker::Lorem.word))
end

Role.create!(name: "moderator")
Role.create!(name: "admin")
seed_user("admin@mail.com").add_role(:admin)
seed_user("moderator@mail.com").add_role(:moderator)
15.times { seed_user(Faker::Internet.unique.email) }

categories = 7.times do
	Category.create(title: Faker::Lorem.word ).save!
end
advertisements = 25.times do
	Advertisement.create(user_id: (1..15).to_a.sample,
		                   remote_image_url: "http://res.cloudinary.com/arfelio1702274/image/upload/v1416515306/adverts/ruby-on-rails-for-beginners-1-638.jpg",
		                   content: Faker::Lorem.paragraph(sentence_count: 12),
		                   title: Faker::Lorem.word,
		                   category_id:(1..7).to_a.sample).save!
end
comments = 100.times do
	Comment.create(user_id:(1..15).to_a.sample,
		             advertisement_id: (1..25).to_a.sample,
		             content: Faker::Lorem.paragraph(sentence_count: 3)  ).save!
end
