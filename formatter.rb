require_relative 'converter'
require_relative 'salary_history/excel_table'
require_relative 'cached_request'
require 'date'
require 'erb'

class Formatter
  def initialize
    @history_table = SalaryHistory::ExcelTable.new
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

    data = [chart_data, layout].to_json[1..-2]
    ERB.new(File.read('chart_template.html.erb')).result_with_hash(data: data)
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
      next if salary_in_dollars.zero?

      [date, salary_in_dollars]
    end.compact
  end

  private

  def start_date
    [@history_table.start_date, Converter.start_date].max
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
