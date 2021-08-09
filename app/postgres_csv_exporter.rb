class PostgresCSVExporter
  include Enumerable

  def initialize(query)
    @query = query
  end

  def each(&block)
    if block_given?
      connection_pool = ActiveRecord::Base.connection_pool
      connection = connection_pool.checkout

      raw_connection  = connection.raw_connection
      raw_connection.copy_data("COPY #{@query} TO STDOUT WITH (FORMAT csv, HEADER)") do
        while row = raw_connection.get_copy_data
          block.call(row)
        end
      end
      connection_pool.checkin(connection)
    else
      to_enum(:each)
    end
  end
end
