# cancancan 1.17's "cancan/matchers" uses alias_method inside RSpec::Matchers.define,
# which only works on RSpec 3. Until rspec-rails is upgraded, use this minimal
# equivalent; afterwards, replace it with `require "cancan/matchers"`.
RSpec::Matchers.define :be_able_to do |*args|
  match { |ability| ability.can?(*args) }

  failure_message_for_should     { |ability| "expected to be able to #{args.map(&:inspect).join(' ')}" }
  failure_message_for_should_not { |ability| "expected not to be able to #{args.map(&:inspect).join(' ')}" }
end
