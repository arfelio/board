require "dartsass/runner"

# The layout links app/assets/builds/application.css, which dartsass-rails compiles
# from app/assets/stylesheets (the build is git-ignored). `bin/rails test` builds it
# through test:prepare; RSpec doesn't, so build it once before the suite.
RSpec.configure do |config|
  config.before(:suite) do
    system(*Dartsass::Runner.dartsass_compile_command, exception: true)
  end
end
