if Rails.env.test? or Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end