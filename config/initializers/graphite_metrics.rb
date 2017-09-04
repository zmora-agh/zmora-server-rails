require 'graphite'

if Rails.configuration.graphite_uri
  Graphite.instance.subscribe_ruby_metrics
end