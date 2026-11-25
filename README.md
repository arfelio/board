# Board

[![CI](https://github.com/arfelio/board/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/arfelio/board/actions/workflows/ci.yml)

A small classifieds board built with Ruby on Rails. Users post advertisements with an image, comment on them, and have a profile with their location. Admins and moderators manage the content.

It started in August 2014 as a Ruby on Rails test task, written on Rails 4.0 and Ruby 2.x. In 2026 it was upgraded to the current Rails and Ruby (see [Upgrade from Rails 4 to Rails 8](#upgrade-from-rails-4-to-rails-8)).

## Stack

| | Version |
|---|---|
| Ruby | 4.0.9 (`.ruby-version`) |
| Rails | 8.1.4 |
| Database | SQLite |
| Views | Haml 7, Bootstrap 5.3, Turbo, Sprockets |
| Authentication | Devise 5 (email and password) |
| Authorization | CanCanCan 3 + rolify 6 |
| Maps | Leaflet + OpenStreetMap tiles, geocoding with Nominatim (no API key) |
| Image uploads | CarrierWave 3 + MiniMagick (ImageMagick) |
| Tests | RSpec 7, Capybara 3 (Cuprite for browser specs), FactoryBot, shoulda-matchers |

## Running it locally

You need:

- Ruby 4.0.9 (for example with [rbenv](https://github.com/rbenv/rbenv): `rbenv install 4.0.9`)
- ImageMagick, for resizing uploaded images
- Node.js, which compiles the JavaScript assets

On macOS:

    brew install imagemagick node

Then:

    git clone https://github.com/arfelio/board.git
    cd board
    bundle install
    cp .env.example .env     # optional: SECRET_KEY_BASE is only needed in production
    bin/setup                # creates and seeds the database, then starts the server

Open http://localhost:3000. Later, start the server with `bin/dev`.

The seed data comes with two accounts (password `password`):

- `admin@mail.com`: administrator
- `moderator@mail.com`: moderator

Seeding needs an internet connection, because it downloads a sample image for the advertisements. Seeded users live in real European cities, so their profiles show a map.

Addresses are geocoded with [Nominatim](https://nominatim.org/), OpenStreetMap's free geocoder, whenever a user's address changes. Its [usage policy](https://operations.osmfoundation.org/policies/nominatim/) asks apps to identify themselves: set `GEOCODER_USER_AGENT` in `.env` to your app's name and a contact address.

## Running the tests

    bundle exec rspec        # the full suite (254 examples)
    bin/ci                   # what CI runs: setup, Zeitwerk check, specs with eager loading

The specs tagged `js: true` run in headless Google Chrome (through Cuprite), so Chrome or Chromium needs to be installed. A coverage report is written to `coverage/index.html` (100% line coverage). GitHub Actions runs the suite on every push to `master` and on every pull request, and `master` only accepts pull requests that pass it.

## Upgrade from Rails 4 to Rails 8

In 2026 the app went from **Rails 4.0.9 on Ruby 2.3.8** to **Rails 8.1.4 on Ruby 4.0.9**. That's eleven years of Rails releases.

- **One stage at a time.** Rails was upgraded one minor version at a time (4.2, 5.0, 5.1 … 8.1), with Ruby raised in between. Each stage was its own pull request and had to pass the full test suite and CI before the next one started.
- **Tests first.** Before any version bump, tests were added for the main flows: sign-up and sign-in, ads with images, comments, search, pagination and the permissions of each role. That took the suite from 123 to 218 examples and 100% line coverage.
- **Security.** Secrets that were hardcoded in the repository moved to environment variables. Facebook login was removed, because its app had been deactivated. 224 Dependabot alerts were resolved.
- **Front end.** Bootstrap 2 was replaced with Bootstrap 5.3. Ruby Sass and CoffeeScript were replaced with maintained tools.
- **Bugs.** Several old bugs surfaced along the way and were fixed: search crashed, editing a comment could crash, ads without an image broke the list, and the zip code check accepted almost anything.

The upgrade was done with the help of [Claude Code](https://claude.com/claude-code), which helped a lot and made it possible to do the whole upgrade in about half a day.

[UPGRADE_PLAN.md](UPGRADE_PLAN.md) has the full plan with every stage, the gems that were replaced, and what's still planned: moving the front end to Turbo and Propshaft.

## Original task (2014)

This is the original specification, translated from Russian. Some items differ in the current app; see [Differences from the original task](#differences-from-the-original-task) below.

### Users

- Sign-up for new users.
- The profile has: login, full name, birthday, email, address, city, state, country, zip, password and password confirmation (all required).
- The user's location is detected automatically when the address fields (address, city, state, zip, country) change, and shown on a map on the profile edit and sign-up pages, using Google Maps v3.
- Users can edit their profile.
- Password recovery.
- Other users can view a user's profile, with a map of their location.

### Advertisements

- Users can create, edit and delete advertisements.
- Users can add and edit comments on an advertisement.
- An advertisement has an author, text and an image.
- The text uses Textile markup; all other HTML is shown as text, not rendered. For example, if a user enters `<h1>Hello</h1> *world*`, readers see "&lt;h1&gt;Hello&lt;/h1&gt;" as plain text and "world" in bold.
- Commenting uses AJAX: adding or deleting a comment doesn't reload the page.
- Only an administrator, a moderator or the comment's author can delete a comment.
- Visitors who aren't signed in can only view advertisements and user profiles.
- The advertisement list shows a thumbnail, the author, and the beginning of the text (up to 160 characters, without cutting words).
- Advertisements can be searched by author, content, address, tags and text.

### Roles

There are three roles: administrator, moderator and user.

- **Administrator:** manages users (adds, edits, deletes them and sets their roles). The first administrator is created from the console or by a migration; the task asked to document how (see below).
- **Moderator:** manages all advertisements and comments.
- **User:** adds and edits their own advertisements and comments.

To make an existing user an administrator from the console:

    bin/rails runner 'User.find_by(email: "someone@example.com").add_role(:admin)'

The seed data (`db/seeds.rb`) already creates `admin@mail.com` as an administrator.

### Pages

- Every page links to the user list, the advertisement list, editing your own profile, and signing out.
- The home page lists the advertisements.
- Advertisement page.
- Sign-in.
- Sign-up.
- Profile.

### Differences from the original task

- **Maps:** OpenStreetMap (Leaflet and Nominatim) instead of Google Maps v3, whose 2014 setup no longer worked. The map is on the profile and edit-profile pages; the sign-up page has none, because there is no location until the account is saved.

These gaps are known and will be covered a bit later:

- **Search:** covers an advertisement's title and text, not author, address or tags.
- **Advertisement list:** shows the full text, not the first 160 characters.
- **Social login** (Twitter, Facebook or Google, from a later version of the task) was removed: Facebook login stopped working when its app was deactivated.
