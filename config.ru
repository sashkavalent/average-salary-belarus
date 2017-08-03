require_relative 'formatter'

run lambda { |env| [200, {'Content-Type'=>'text/plain'}, [Formatter.new.to_string]] }
