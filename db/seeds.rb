# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create(name:"moderator").save
Role.create(name:"admin").save
admin = User.create(email:"admin@mail.com",password:"password",password_confirmation:"password",
	        address: Faker::Address.street_address,city: Faker::Address.city,
	        country: Faker::Address.country, state: Faker::Address.state,
	        bday: Date.today,full_name:Faker::Name.name,
	        login: Faker::Lorem.word,zip: Faker::Address.zip ).save!
moderator = User.create(email:"moderator@mail.com",password:"password",password_confirmation:"password",	        address: Faker::Address.street_address,city: Faker::Address.city,
	        country: Faker::Address.country, state: Faker::Address.state,
	        bday: Date.today,full_name:Faker::Name.name,
	        login: Faker::Lorem.word,zip: Faker::Address.zip ).save!
15.times do
	User.create(email: Faker::Internet.email,password:"password",password_confirmation:"password",
	        address: Faker::Address.street_address,city: Faker::Address.city,
	        country: Faker::Address.country, state: Faker::Address.state,
	        bday: Date.today,full_name:Faker::Name.name,
	        login: Faker::Lorem.word,zip: Faker::Address.zip ).save!
end
categories = 7.times do
	Category.create(title: Faker::Lorem.word ).save!
end
advertisements = 25.times do
	Advertisement.create(user_id: (1..15).to_a.sample,
		                   remote_image_url: "http://res.cloudinary.com/arfelio1702274/image/upload/v1416515306/adverts/ruby-on-rails-for-beginners-1-638.jpg",
		                   content: Faker::Lorem.paragraph(12),
		                   title: Faker::Lorem.word,
		                   category_id:(1..7).to_a.sample).save!
end
comments = 100.times do
	Comment.create(user_id:(1..15).to_a.sample,
		             advertisement_id: (1..25).to_a.sample,
		             content: Faker::Lorem.paragraph(3)  ).save!
end
