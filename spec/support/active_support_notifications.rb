RSpec::Matchers.define(:instrument_notification) do |name|
  match do |actual|
    allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original
    actual.call

    expect(ActiveSupport::Notifications).to have_received(:instrument).with(name, any_args).
      at_least(:once)
  end

  description { "instrument #{name}" }
  failure_message { |actual| "expected that #{actual} instrument the notification #{name}" }
  supports_block_expectations
end

RSpec::Matchers.define(:publish_notification) do |name|
  match do |actual|
    allow(ActiveSupport::Notifications).to receive(:publish).and_call_original
    actual.call

    expect(ActiveSupport::Notifications).to have_received(:publish).with(name, any_args).
      at_least(:once)
  end

  description { "publish #{name}" }
  failure_message { |actual| "expected that #{actual} publish the notification #{name}" }
  supports_block_expectations
end
