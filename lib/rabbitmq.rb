require 'bunny'

class RabbitMQ
  def initialize(quename, uri = 'amqp://localhost', error_quename = nil)
    @con = Bunny.new(uri)
    @con.start
    @ch = @con.create_channel
    @que = @ch.queue(quename, durable: true)
    @err_que = @ch.queue(error_quename, durable: true) if error_quename
  end

  def send(message)
    @ch.default_exchange.publish(message, routing_key: @que.name)
  end

  def send_error(message)
    @ch.default_exchange.publish(message, routing_key: @err_que.name)
  end

  def ack(delivery_tag)
    @ch.ack(delivery_tag, false)
  end

  def start_receiving
    @que.subscribe(manual_ack: true) do |delivery_info, _metadata, payload|
      yield payload, delivery_info
    end
  end

  def close
    @con.close
  end
end
