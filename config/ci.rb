# Run using bin/ci. Mirrors the GitHub Actions workflow (.github/workflows/ci.yml).

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Zeitwerk: autoload check", "bin/rails zeitwerk:check"
  step "Tests: RSpec (eager loading, like CI)", "env CI=true bundle exec rspec"
end
