require 'graphite-api'

module GraphiteInstrumentation
  module_function

  def before_query(query)
    path = (query.mutation? ? 'mutation.' : 'query.') + query.operation_name
    Graphite.instance.client.increment path
  end

  def after_query(query) end
end
