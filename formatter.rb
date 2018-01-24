require_relative 'converter'
require_relative 'history_table'
require 'date'

class Formatter
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
      title: 'Average salary in Belarus',
      xaxis: { title: 'Date' },
      yaxis: { title: 'Amount, $' }
    }

    html = File.read('chart_template.html')
    html.gsub!('<%= data %>', [chart_data, layout].to_json[1..-2])
  end

  def to_array
    all_months.map do |date|
      salary_in_rubles = @history_table.value(date)
      salary_in_dollars =
        begin
          Converter.new(date).to_dollars(salary_in_rubles)
        rescue StandardError
          0
        end
      [date, salary_in_dollars]
    end
  end

  private

  def start_date
    Date.parse('01.05.1995')
  end

  def end_date
    Date.new(Date.today.year, Date.today.month, 1)
  end

  def all_months
    result = []
    date = start_date
    loop do
      result << date
      date = date >> 1
      break if date > end_date
    end
    result
  end
end
