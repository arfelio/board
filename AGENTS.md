# AGENTS.md

Message board app: users post advertisements (with images) in categories, others comment. Roles: admin, moderator, user.

## Stack

- Ruby **2.4.10** (`.ruby-version`), Rails **5.0.7.2**, Bundler **1.17.3**
- SQLite everywhere, production included (decided: no PostgreSQL)
- Views: Haml + Bootstrap 2 (`bootstrap-sass`), CoffeeScript, Sprockets
- Auth: Devise (email + password only; Facebook login was removed). Authorization: CanCanCan (`app/models/ability.rb`) + rolify
- Uploads: CarrierWave + MiniMagick (local `public/uploads` in dev/test); needs the ImageMagick CLI (`brew install imagemagick`)
- Tests: RSpec **3.9** (`expect` / `is_expected` syntax), Capybara 2.18 (rack_test, no JS driver), FactoryBot 5, shoulda-matchers 3.1

An upgrade to current Rails/Ruby is planned in stages. See `UPGRADE_PLAN.md` and update its status line when a stage lands.

## Setup (Apple Silicon)

```sh
CFLAGS="-Wno-error=implicit-function-declaration -Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion" rbenv install 2.4.10
gem install bundler -v 1.17.3
brew install imagemagick                                  # CLI used by mini_magick (ImageMagick 6 or 7)
cp .env.example .env               # then fill in values (see Gotchas)
bundle _1.17.3_ install
```


## Commands

```sh
RAILS_ENV=test bin/rails db:create db:schema:load          # prepare test DB
bundle exec rspec                                          # full suite (212 examples, 2 pending placeholders)
bin/rails db:seed                                          # dev data
bundle exec rails s
```

Seeded logins (password `password`): `admin@mail.com` (admin), `moderator@mail.com` (moderator).
Seeding prints "Geocoding API's response was not valid JSON": geocoder has no API key configured; users still save, without coordinates.

## Workflow

- `master` is protected: changes go through a PR, and the GitHub Actions `test` job (`.github/workflows/ci.yml`) must pass. This applies to admins too.
- CodeFactor also reports on PRs (Brakeman, bundler-audit and style checks). It is not a required check.
- Run `bundle exec rspec` before pushing.

## Gotchas

- **Gem pins in the Gemfile are deliberate** (`nokogiri ~> 1.10.10`, `rails-html-sanitizer < 1.5`, `loofah < 2.19`, `tilt ~> 2.0.11`). They are the last versions that work with Ruby 2.4 / haml 5. Lift them only together with the Ruby/Rails bump that allows it.
- Roles come from rolify: the association is `roles` / `role_ids` (there is no `role`). The default `user` role is assigned in `before_create`; moving it to `after_create` breaks user creation with `role_ids` (join rows get saved twice).
- Rails 5.0 framework defaults are set in `config/application.rb`, not in an initializer: gems load ActiveRecord/ActionController before initializers run, so framework config set there is silently ignored. `belongs_to` is required by default; optional associations say `optional: true`.
- The comment form is `remote: true`: its CSRF token comes from the `csrf-token` meta tag via jquery_ujs, not from a hidden field. Keep `csrf_meta_tags` in the layout.
- A database created under Rails 4.2 needs `bin/rails db:environment:set RAILS_ENV=<env>` once before `db:schema:load` works.
- `db/schema.rb` is generated; don't hand-edit or lint it.
- `therubyracer` was removed on purpose; ExecJS uses Node.js.
- Secrets live in environment variables: `.env` locally (git-ignored, loaded by dotenv-rails), see `.env.example`. `SECRET_KEY_BASE` is read via `config/secrets.yml` (test has a fixed non-secret value, so CI needs no `.env`); Devise falls back to it. Never commit real secrets.
