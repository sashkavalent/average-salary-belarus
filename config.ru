require_relative 'formatter'

run lambda { |env| [200, {'Content-Type'=>'text/html'}, [Formatter.new.to_chart]] }
