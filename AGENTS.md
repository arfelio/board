# AGENTS.md

Message board app: users post advertisements (with images) in categories, others comment. Roles: admin, moderator, user.

## Stack

- Ruby **4.0.9** (`.ruby-version`), Rails **8.1.4** (Zeitwerk autoloader), Bundler **4.0.20** (ships with Ruby 4.0), Puma
- SQLite everywhere, production included (decided: no PostgreSQL)
- Views: Haml + Bootstrap **5.3** (`bootstrap` gem, compiled by `sassc-rails`), jQuery + `jquery_ujs` (remote forms, `method: :delete` links), Sprockets 4 (entry points in `app/assets/config/manifest.js`), terser for production JS
- Auth: Devise 5 (email + password only; Facebook login was removed). Authorization: CanCanCan 3 (`app/models/ability.rb`) + rolify 6
- Uploads: CarrierWave 3 + MiniMagick 5 (local `public/uploads` in dev/test); needs the ImageMagick CLI (`brew install imagemagick`)
- Tests: rspec-rails **7.1** (`expect` / `is_expected` syntax), Capybara 3.40 (rack_test, no JS driver), FactoryBot 6.4, shoulda-matchers 6.5

An upgrade to current Rails/Ruby is planned in stages. See `UPGRADE_PLAN.md` and update its status line when a stage lands.

## Setup (Apple Silicon)

```sh
CFLAGS="-Wno-error=implicit-function-declaration -Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion" rbenv install 4.0.9
gem install bundler -v 4.0.20  # already the default bundler of Ruby 4.0.9
brew install imagemagick                                  # CLI used by mini_magick (ImageMagick 6 or 7)
cp .env.example .env               # then fill in values (see Gotchas)
bundle install
```


## Commands

```sh
RAILS_ENV=test bin/rails db:create db:schema:load          # prepare test DB
bundle exec rspec                                          # full suite (218 examples, 2 pending placeholders; 100% line coverage)
bin/ci                                                     # setup + zeitwerk:check + specs with eager loading, like GitHub CI (config/ci.rb)
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

- `coffee-script` is only there because `gmaps4rails` ships its JavaScript as CoffeeScript (`//= require gmaps/google`); the app itself has no CoffeeScript. Remove both together.
- After changing gems or Sprockets config, clear `tmp/cache` if assets behave oddly (stale Sprockets 3 cache entries caused "not declared to be precompiled" errors during the Sprockets 4 move).
- Ruby 4.0 moved more libraries (e.g. `benchmark`) out of the default install: if boot fails with "cannot load such file -- X", update the gem that requires X or add `gem "X"` to the Gemfile.
- Some gems declare a lower `required_ruby_version` than they really need, so after a `bundle update` always run the suite.
- Roles come from rolify: the association is `roles` / `role_ids` (there is no `role`). The default `user` role is assigned in `before_create`; moving it to `after_create` breaks user creation with `role_ids` (join rows get saved twice).
- Zeitwerk loads `app/`: each file must define the constant its path implies (`app/models/foo_bar.rb` → `FooBar`). Check with `bin/rails zeitwerk:check`.
- Run the suite with `RUBYOPT=-W:deprecated` to see Ruby and Rails deprecation warnings; there are currently none.
- Factories build uploads with `Rack::Test::UploadedFile`: since Rails 6.1, `fixture_file_upload` only works inside test cases, not in factories.
- `config.load_defaults 7.2` turns on YJIT, but only if Ruby was built with it: rbenv/ruby-build include YJIT only when Rust (`brew install rust`) is installed at build time. Without it the setting does nothing.
- If `ruby -rsocket -e 1` fails after building Ruby, an extension silently failed to compile; check the "Following extensions are not compiled" section of the ruby-build log.
- Framework defaults come from `config.load_defaults` in `config/application.rb`. Don't put framework settings in `config/initializers/`: gems load ActiveRecord/ActionController before initializers run, so those values are silently ignored. `belongs_to` is required by default; optional associations say `optional: true`.
- Bootstrap 5 markup: inputs need `form-control` / `form-select` / `form-check-input` (nothing is styled by default); wrap forms in `.form-narrow`. Flash keys map to alert colours in `ApplicationHelper#flash_alert_class` (each alert also gets a `flash-<key>` class, used by specs). Pagination goes through `BootstrapLinkRenderer` (`app/lib/`), applied by `ApplicationHelper#will_paginate`.
- Ad images are optional: guard `image_tag` with `if ….image.present?` (since Rails 5.1, `image_tag(nil)` raises).
- The comment form is `remote: true`: its CSRF token comes from the `csrf-token` meta tag via jquery_ujs, not from a hidden field. Keep `csrf_meta_tags` in the layout.
- A database created under Rails 4.2 needs `bin/rails db:environment:set RAILS_ENV=<env>` once before `db:schema:load` works.
- `db/schema.rb` is generated; don't hand-edit or lint it.
- `therubyracer` was removed on purpose; ExecJS uses Node.js.
- Secrets live in environment variables (`.env` locally, git-ignored, loaded by dotenv-rails; see `.env.example`). Since Rails 7.1 there is no `config/secrets.yml`: development and test generate their own `secret_key_base`, and production reads `ENV["SECRET_KEY_BASE"]`. Devise uses the same key (`config.secret_key` in `config/initializers/devise.rb`). Never commit real secrets.
