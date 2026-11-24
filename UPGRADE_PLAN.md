# Upgrade plan: Rails 4.2 / Ruby 2.4 → Rails 8.1 / Ruby 4.0

**Status:** All stages done: Rails 8.1.4, Ruby 4.0.9, `config.load_defaults 8.1`, no deprecation warnings. Bootstrap 5.3 in place. Next: the front-end modernization below. Production reads `SECRET_KEY_BASE` from `ENV`; encrypted credentials are deferred with the other production work.

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

- ✅ **Remove hardcoded secrets.** `secret_key_base` now comes from `SECRET_KEY_BASE` (`.env` locally), and a new value was generated. The Facebook app was deactivated by Facebook, so Facebook login was removed instead of resetting its secret.
- ✅ **Add tests for the main flows** before changing anything else: sign up and log in, creating, editing and deleting ads with an image upload, comments, pagination, and the permissions of each role (admin / moderator / user / guest, per `app/models/ability.rb`).
- ✅ Update the test tools: `rspec-rails` 3.9 (specs converted with `transpec`), `factory_bot_rails` 5.2, `capybara` 2.18, `shoulda-matchers` pinned to `~> 3.1`.
- ✅ Production database: **SQLite** (decided). `config/database.yml` production now uses SQLite; deploying it needs a persistent disk for `db/` and `public/uploads`. Rails 8 (stage 9) adds the tooling for SQLite in production.
- ✅ Replace `rmagick` with `mini_magick`. Only the ImageMagick CLI is needed now (6 or 7), with no native gem build.

## Stages 1–10: Rails and Ruby versions

| # | Rails | Ruby | Main work |
|---|---|---|---|
| 1 ✅ | 4.2 → 5.0 | 2.4 | `ApplicationRecord` base class; `before_filter` → `before_action` and `update_attributes` → `update` (advertisements, comments, users and registrations controllers); `belongs_to` required by default; `params` is no longer a Hash; Devise 4.x; `rake` 12.3.3+, which fixes the rake advisory, so drop the `rake < 11` pin; `bin/rails` replaces `rake` for app commands |
| 2 ✅ | 5.0 → 5.1 | 2.5 | Drop the `nokogiri` / `rails-html-sanitizer` / `loofah` / `tilt` pins; Bundler 2; `shoulda-matchers` 4 (removes the `#tables` deprecation); replace the Rails 5.0 defaults block in `config/application.rb` with `config.load_defaults 5.1` |
| 3 ✅ | 5.1 → 5.2 | 2.6 | Encrypted credentials (`config/credentials.yml.enc`) replace `secret_token.rb`; `bootsnap` |
| 4 ✅ | 5.2 → 6.0 | 2.7 | **Zeitwerk autoloader**: file and constant names must match (check `app/controllers/users/`, `concerns`); fix the Ruby 2.7 keyword-argument warnings now |
| 5 ✅ | 6.0 → 6.1 | **3.0** | **Ruby 3 keyword arguments** (the warnings from stage 4 become errors); gem updates that require Ruby 3 |
| 6 ✅ | 6.1 → 7.0 | 3.1 | Sprockets becomes optional: keep `sprockets-rails` explicitly; Turbolinks → Turbo is optional; CoffeeScript and the Sass replacement must be done by now (see below) |
| 7 ✅ | 7.0 → 7.1 | 3.2 | Config defaults; `config.load_defaults 7.1` |
| 8 ✅ | 7.1 → 7.2 | 3.3 | Rails 7.2 requires Ruby 3.1+ |
| 9 ✅ | 7.2 → 8.0 | 3.4 | Rails 8 requires Ruby 3.2+; Solid Queue / Solid Cache / Propshaft are optional |
| 10 ✅ | 8.0 → 8.1 | **4.0** | Final target. Check Ruby 4.0 support across all gems; stay on 3.4 if anything blocks |

### Stage 1 follow-ups

- ✅ Rails 5.0 framework defaults switched on, each verified with a full spec run. They live in `config/application.rb`: values set in an initializer were applied too late (gems load ActiveRecord/ActionController first) and never took effect. `belongs_to` is now required; `Advertisement#category` and `Role#resource` are `optional: true`.
- ✅ Removed the precompiled assets committed in 2014 (`public/assets/`); the folder is git-ignored.

Deferred until production is in scope: `config.action_mailer.default_url_options` in `production.rb` (password reset emails need it).

## Gem replacements

Each one can be its own PR. "Deadline" is the last stage it can wait for.

| Current | Replace with | Deadline | Notes |
|---|---|---|---|
| ~~`rmagick` 2.16~~ | `mini_magick` | Stage 0 | **Done** |
| ~~`rspec-rails` 2.99, `factory_girl_rails`~~ | `rspec-rails` 3.9, `factory_bot_rails` 5.2 | Stage 0 | **Done.** Move on to `rspec-rails` 4+ / FactoryBot 6 once on Rails 5+ / Ruby 2.5+ |
| ~~`devise` 3.5~~ | Devise 5.0 | Stage 10 | **Done**: 4.x in stage 1, 5.0 in stage 10 (4.9 used deprecated routing calls on Rails 8.1) |
| ~~`carrierwave` 0.10~~ | CarrierWave 3.1 (2.2 in stage 4, 3.1 in stage 10) | Stage 10 | **Done**; existing uploads keep working. Active Storage would need a data migration |
| ~~`sass` / `sass-rails`~~ | `sassc-rails` (done with Bootstrap 5) | Stage 6 | **Done.** libsass/sassc is deprecated too; move to Dart Sass (`dartsass-sprockets` or `dartsass-rails`) later |
| ~~`coffee-rails`~~ | Plain JavaScript | Stage 6 | **Done**: the 4 `.js.coffee` files were empty and are deleted. `coffee-script` stays only for gmaps4rails |
| ~~`uglifier`~~ | `terser` | Stage 6 | **Done** |
| ~~`jbuilder` 1.x, `jquery-rails` 3.x, `turbolinks`~~ | Current versions | Stage 6 | **Done**: `jbuilder` 2.15 (categories JSON views), `jquery-rails` 4.6, `turbolinks` 5.2.1. `jquery-rails` and `turbolinks` go away with the front-end modernization |
| ~~`RedCloth`~~ | Keep, update | | **Done**: 4.3.4 (fixes a ReDoS advisory); renders ad text |
| `gmaps4rails`, `underscore-rails` | Remove (or replace the map) | Open | The user-page map loads Google Maps JS v3.13 without an API key and a marker library from googlecode.com (shut down), so it cannot render. Removing gmaps4rails also removes `underscore-rails` and `coffee-script`. Decision pending |
| ~~`haml` 5, `geocoder`, `faker`~~ | Latest versions | | **Done**: `haml` 7.5 (rendered HTML identical to Haml 5), `geocoder` 1.8, `faker` 3.8 |
| ~~`rails_12factor`~~ | Remove | Stage 1 | **Done** (built into Rails 5+) |
| ~~`bootstrap-sass` 2.3~~, `bootstrap-will_paginate` | `bootstrap` 5.3 gem | Before stage 6 | **Done**: all views ported to Bootstrap 5 markup; custom will_paginate renderer |

## After stage 10: front-end modernization

Sprockets keeps working on Rails 8, so the framework upgrade finishes on it. Changing the front end at the same time would make failures harder to trace. Once stage 10 is merged, move to the Rails 8 default front end in a few separate PRs.

**Target:** Propshaft (serves and fingerprints files) + importmap-rails (JavaScript as ES modules, no Node) + dartsass-rails (Sass compiled by the Dart Sass binary) + Turbo.

What it replaces today, with Sprockets bundling through `//= require`:

| Today | After |
|---|---|
| Sprockets, `sprockets-rails` | Propshaft |
| `sassc-rails` (libsass, deprecated) | `dartsass-rails`; Bootstrap 5 Sass from the `bootstrap` gem's stylesheets path or the npm package |
| `jquery-rails` (`jquery`, `jquery_ujs`) | Turbo: `data-turbo-method` / `data-turbo-confirm` instead of `method:` / `data: { confirm: }` (9 places). The Ajax comment form and delete links (`remote: true` + `comments/*.js.erb`) become Turbo Stream responses. Drop jQuery if nothing else needs it |
| `turbolinks` | Turbo (`turbo-rails`), its successor |
| `bootstrap` gem's JS + `popper` | Bootstrap and Popper pinned from npm in `config/importmap.rb` |
| `gmaps4rails`, `underscore-rails`, `coffee-script` | Removed, assuming the map is dropped (see the gem table: the map cannot render today) |

Suggested PRs:
1. **Turbo instead of `jquery_ujs` and Turbolinks**, still on Sprockets. This is the behaviour change, so review it on its own. The CSRF and comment specs cover the affected flows.
2. **Remove the map** (gmaps4rails, Underscore, CoffeeScript), once that decision is made.
3. **Switch the asset pipeline:** Sprockets → Propshaft + importmap + dartsass-rails. Compare before/after screenshots as for the Bootstrap 5 port.

Not chosen: jsbundling/cssbundling (needs Node in development, CI and production) and Vite. Both are more tooling than this app needs.

### Solid Queue, Solid Cache, Solid Cable

Rails 8's database-backed versions of the queue, cache and Action Cable services. They fit the SQLite production decision because they need no Redis.

- **Solid Queue:** add it when production comes into scope. The app has no background jobs, but several slow operations run inside web requests: Devise emails are sent immediately, geocoding calls an external API on every user validation, and image resizing runs during upload. Moving them to jobs needs a worker process (or Puma's `solid_queue` plugin), `config/queue.yml` and a separate queue database.
- **Solid Cache:** not needed. The app has no caching (`Rails.cache` or `cache` blocks); add it only together with caching.
- **Solid Cable:** not needed. There is no Action Cable or live updates. It becomes relevant only if, for example, new comments are broadcast with Turbo Streams.

## Risks

- **Test coverage** decides how safe each stage is. Don't skip the Stage 0 tests.
- **Stages 4 and 5** (Zeitwerk, Ruby 3 keyword arguments) are the most likely to break code at runtime.
- **Uploaded files:** changing CarrierWave or moving to Active Storage affects existing files in production storage. Plan the migration before deploying.
