require 'singleton'
require 'graphite-api'

class Graphite
  include Singleton
  attr_reader :client

  def initialize
    @client = GraphiteAPI.new(graphite: Rails.configuration.graphite_uri, prefix: Rails.configuration.graphite_prefix)
    Rails.logger.info "Connecting to graphite #{Rails.configuration.graphite_uri}"
  end

  def subscribe_ruby_metrics
    ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      send_runtime_metrics event
      send_request_params event
    end
  end

  private

  def send_runtime_metrics(event)
    @client.metrics('db_runtime' => event.payload[:db_runtime],
                    'view_runtime' => event.payload[:view_runtime],
                    'runtime' => event.duration)
  end

  def send_request_params(event)
    @client.increment('statuses.' + event.payload[:status].to_s)
    return if event.payload[:controller] == 'GraphqlController'
    @client.increment(event.payload[:controller] + '.' + event.payload[:action])
  end
end
