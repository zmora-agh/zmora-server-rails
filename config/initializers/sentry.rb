Raven.configure do |config|
  config.dsn = ENV["SENTRY_DSN"] if ENV["SENTRY_DSN"]
  config.processors -= [Raven::Processor::PostData]
end