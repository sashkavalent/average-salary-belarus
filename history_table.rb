require 'net/http'
require 'nokogiri'

class HistoryTable
  URL = 'http://www.belstat.gov.by/ofitsialnaya-statistika/solialnaya-sfera/trud/operativnaya-informatsiya_8/zarabotnaya-plata/'

  def initialize
    puts "request to #{URL}}"
    body = Nokogiri::HTML(Net::HTTP.get(URI(URL)))
    rows = body.css('table tr')[1..-1].map { |row| row.css('th,td').map { |td| td.text.gsub(/\d+/).first.to_i } }
    @salaries_grouped_by_year = rows.each_with_object({}) { |row, obj| obj[row[0].to_s[0..3].to_i] = row[1..-1] }
  end

  def value(date)
    year_salaries = @salaries_grouped_by_year[date.year]
    (year_salaries && year_salaries[date.month - 1]).to_i
  end
end
