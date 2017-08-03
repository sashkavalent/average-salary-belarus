require_relative 'converter'
require_relative 'history_table'
require 'date'

class Formatter
  START_DATE = Date.parse('01.05.1995')
  END_DATE = Date.parse('01.06.2017')

  def initialize
    @history_table = HistoryTable.new
  end

  def to_string
    all_months.map do |date|
      salary_in_rubles = @history_table.value(date)
      salary_in_dollars = Converter.new(date).to_dollars(salary_in_rubles)
      "#{date} #{salary_in_dollars}"
    end.join("\n")
  end

  def all_months
    result = []
    date = START_DATE
    loop do
      result << date
      date = date >> 1
      break if date > END_DATE
    end
    result
  end
end
