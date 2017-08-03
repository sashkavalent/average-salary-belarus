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
    to_array.map { |row| row.join(' ') }.join("\n")
  end

  def to_chart
    rows = to_array
    chart_data = [{ x: rows.map(&:first), y: rows.map(&:last), name: 'Salary' }]
    layout = {
      title: 'Average salary',
      xaxis: { title: 'Date' },
      yaxis: { title: 'Amount, $' }
    }

    html = File.read('chart_template.html')
    html.gsub!('<%= data %>', [chart_data, layout].to_json[1..-2])
  end

  def to_array
    all_months.map do |date|
      salary_in_rubles = @history_table.value(date)
      salary_in_dollars = Converter.new(date).to_dollars(salary_in_rubles)
      [date, salary_in_dollars]
    end
  end

  private

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
