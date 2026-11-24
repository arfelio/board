# AGENTS.md

Message board app: users post advertisements (with images) in categories, others comment. Roles: admin, moderator, user.

## Stack

- Ruby **2.4.10** (`.ruby-version`), Rails **4.2.11.3**, Bundler **1.17.3**
- SQLite in development and test; `config/database.yml` points production at PostgreSQL, but the `pg` gem is not in the Gemfile yet
- Views: Haml + Bootstrap 2 (`bootstrap-sass`), CoffeeScript, Sprockets
- Auth: Devise + omniauth-facebook. Authorization: CanCanCan (`app/models/ability.rb`) + rolify
- Uploads: CarrierWave + RMagick (local `public/uploads` in dev/test)
- Tests: RSpec **2.99** (old `should` syntax), Capybara 2.1 (rack_test, no JS driver), FactoryGirl

An upgrade to current Rails/Ruby is planned in stages. See `UPGRADE_PLAN.md` and update its status line when a stage lands.

## Setup (Apple Silicon)

```sh
CFLAGS="-Wno-error=implicit-function-declaration -Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion" rbenv install 2.4.10
gem install bundler -v 1.17.3
brew install imagemagick@6          # rmagick 2.16 does not work with ImageMagick 7
PKG_CONFIG_PATH=/opt/homebrew/opt/imagemagick@6/lib/pkgconfig PATH=/opt/homebrew/opt/imagemagick@6/bin:$PATH \
  CFLAGS="-Wno-int-conversion -Wno-incompatible-pointer-types" gem install rmagick -v 2.16.0
bundle _1.17.3_ install
```

rmagick ignores `--with-cflags`; it only reads the `CFLAGS` env var.

## Commands

```sh
RAILS_ENV=test bundle exec rake db:create db:schema:load   # prepare test DB
bundle exec rspec                                          # full suite (123 examples, 2 pending placeholders)
bundle exec rake db:seed                                   # dev data
bundle exec rails s
```

Seeded logins (password `password`): `admin@mail.com` (admin), `moderator@mail.com` (moderator).
Seeding prints "Geocoding API's response was not valid JSON": geocoder has no API key configured; users still save, without coordinates.

## Workflow

- `master` is protected: changes go through a PR, and the GitHub Actions `test` job (`.github/workflows/ci.yml`) must pass. This applies to admins too.
- CodeFactor also reports on PRs (Brakeman, bundler-audit and style checks). It is not a required check.
- Run `bundle exec rspec` before pushing.

## Gotchas

- **Gem pins in the Gemfile are deliberate** (`nokogiri ~> 1.10.10`, `rails-html-sanitizer < 1.5`, `loofah < 2.19`, `tilt ~> 2.0.11`, `rake < 11`). They are the last versions that work with Ruby 2.4 / haml 5 / rspec-rails 2.99. Lift them only together with the Ruby/Rails bump that allows it.
- Roles come from rolify: the association is `roles` / `role_ids` (there is no `role`). The default `user` role is assigned in `before_create`; moving it to `after_create` breaks user creation with `role_ids` in Rails 4.2.
- `db/schema.rb` is generated; don't hand-edit or lint it.
- `therubyracer` was removed on purpose; ExecJS uses Node.js.
- Facebook OAuth credentials and `secret_key_base` are currently hardcoded in `config/initializers/` (step 0 of the upgrade plan moves them out). Don't add more secrets to the repo.
