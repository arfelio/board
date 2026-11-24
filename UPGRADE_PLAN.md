# Upgrade plan: Rails 4.2 / Ruby 2.4 → Rails 8.1 / Ruby 4.0

**Status:** Stage 1 done (Rails 5.0.7.2, Ruby 2.4.10). Next: the Stage 1 follow-ups below, then Stage 2 (Rails 5.1, Ruby 2.5).

Target: the latest releases as of November 2026, **Rails 8.1.4.1** and **Ruby 4.0.9**.

## Approach

- Upgrade Rails **one minor version at a time**. Each release warns about what the next one removes, so skipping a version hides those warnings.
- Raise Ruby in between, as far as the current Rails version supports.
- **One stage = one PR.** For each stage:
  1. Bump the versions in `Gemfile` / `.ruby-version` and in `.github/workflows/ci.yml` if needed.
  2. Run `bin/rails app:update` (or `rake rails:update` on 4.2) and review each config diff.
  3. Fix failing specs and deprecation warnings until there are none.
  4. Merge once CI passes.
  5. Turn on that version's `new_framework_defaults` one at a time, in a follow-up PR.
- Update the **Status** line above and the status in `AGENTS.md` after each stage.

## Stage 0: Preparation (on Rails 4.2)

- [x] **Remove hardcoded secrets.** `secret_key_base` now comes from `SECRET_KEY_BASE` (`.env` locally), and a new value was generated. The Facebook app was deactivated by Facebook, so Facebook login was removed instead of resetting its secret.
- [x] **Add tests for the main flows** before changing anything else: sign up and log in, creating, editing and deleting ads with an image upload, comments, pagination, and the permissions of each role (admin / moderator / user / guest, per `app/models/ability.rb`).
- [x] Update the test tools: `rspec-rails` 3.9 (specs converted with `transpec`), `factory_bot_rails` 5.2, `capybara` 2.18, `shoulda-matchers` pinned to `~> 3.1`.
- [x] Production database: **SQLite** (decided). `config/database.yml` production now uses SQLite; deploying it needs a persistent disk for `db/` and `public/uploads`. Rails 8 (stage 9) adds the tooling for SQLite in production.
- [x] Replace `rmagick` with `mini_magick`. Only the ImageMagick CLI is needed now (6 or 7), with no native gem build.

## Stages 1–10: Rails and Ruby versions

| # | Rails | Ruby | Main work |
|---|---|---|---|
| 1 ✅ | 4.2 → 5.0 | 2.4 | `ApplicationRecord` base class; `before_filter` → `before_action` and `update_attributes` → `update` (advertisements, comments, users and registrations controllers); `belongs_to` required by default; `params` is no longer a Hash; Devise 4.x; `rake` 12.3.3+, which fixes the rake advisory, so drop the `rake < 11` pin; `bin/rails` replaces `rake` for app commands |
| 2 | 5.0 → 5.1 | 2.5 | Drop the `nokogiri` / `rails-html-sanitizer` / `loofah` / `tilt` pins; Bundler 2; `shoulda-matchers` 4 (removes the `#tables` deprecation) |
| 3 | 5.1 → 5.2 | 2.6 | Encrypted credentials (`config/credentials.yml.enc`) replace `secret_token.rb`; `bootsnap` |
| 4 | 5.2 → 6.0 | 2.7 | **Zeitwerk autoloader**: file and constant names must match (check `app/controllers/users/`, `concerns`); fix the Ruby 2.7 keyword-argument warnings now |
| 5 | 6.0 → 6.1 | **3.0** | **Ruby 3 keyword arguments** (the warnings from stage 4 become errors); gem updates that require Ruby 3 |
| 6 | 6.1 → 7.0 | 3.1 | Sprockets becomes optional: keep `sprockets-rails` explicitly; Turbolinks → Turbo is optional; CoffeeScript and the Sass replacement must be done by now (see below) |
| 7 | 7.0 → 7.1 | 3.2 | Config defaults; `config.load_defaults 7.1` |
| 8 | 7.1 → 7.2 | 3.3 | Rails 7.2 requires Ruby 3.1+ |
| 9 | 7.2 → 8.0 | 3.4 | Rails 8 requires Ruby 3.2+; Solid Queue / Solid Cache / Propshaft are optional |
| 10 | 8.0 → 8.1 | **4.0** | Final target. Check Ruby 4.0 support across all gems; stay on 3.4 if anything blocks |

### Stage 1 follow-ups

- [ ] Flip each setting in `config/initializers/new_framework_defaults.rb` to the Rails 5.0 value, one per PR or commit (`belongs_to_required_by_default` needs every `belongs_to` checked), then delete the file.
- [ ] Remove the precompiled assets committed in 2014 (`public/assets/`, Sprockets 2 format) and add `/public/assets` to `.gitignore`; production should precompile on deploy.
- [ ] Set `config.action_mailer.default_url_options` in `production.rb` once the domain is known (password reset emails need it).

## Gem replacements

Each one can be its own PR. "Deadline" is the last stage it can wait for.

| Current | Replace with | Deadline | Notes |
|---|---|---|---|
| ~~`rmagick` 2.16~~ | `mini_magick` | Stage 0 | **Done** |
| ~~`rspec-rails` 2.99, `factory_girl_rails`~~ | `rspec-rails` 3.9, `factory_bot_rails` 5.2 | Stage 0 | **Done.** Move on to `rspec-rails` 4+ / FactoryBot 6 once on Rails 5+ / Ruby 2.5+ |
| `devise` 3.5 | 4.x, then the latest | Stage 1 | |
| `carrierwave` 0.10 | CarrierWave 3.x, or Active Storage | Stage 4 | Active Storage needs a data migration for existing uploads |
| `sass` / `sass-rails` (Ruby Sass is discontinued) | `dartsass-rails` or `sassc-rails` | Stage 6 | |
| `coffee-rails` (5 `.js.coffee` files) | Plain JavaScript | Stage 6 | `decaffeinate` can convert them |
| `uglifier` | `terser`, or no minifier (Propshaft) | Stage 6 | |
| `jbuilder` 1.x, `jquery-rails` 3.x, `turbolinks` | Current versions, or remove if unused | Stage 6 | |
| `gmaps4rails`, `underscore-rails`, `RedCloth` | Check usage; remove or replace | Stage 6 | gmaps4rails is unmaintained |
| `haml` 5, `cancancan` 1.x, `rolify`, `geocoder`, `will_paginate`, `faker` | Latest compatible versions | Update at each stage | |
| `rails_12factor` | Remove | Stage 1 | Built into Rails 5+ |
| `bootstrap-sass` 2.3 | Bootstrap 5 | **Separate project** | Rewrites the markup of every view; do it after stage 10 or on its own track |

## Risks

- **Test coverage** decides how safe each stage is. Don't skip the Stage 0 tests.
- **Stages 4 and 5** (Zeitwerk, Ruby 3 keyword arguments) are the most likely to break code at runtime.
- **Uploaded files:** changing CarrierWave or moving to Active Storage affects existing files in production storage. Plan the migration before deploying.
