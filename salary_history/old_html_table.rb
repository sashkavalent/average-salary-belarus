require_relative 'base_table'
require 'nokogiri'

class SalaryHistory::OldHTMLTable < SalaryHistory::BaseTable
  URL = 'http://www.belstat.gov.by/ofitsialnaya-statistika/solialnaya-sfera/trud/operativnaya-informatsiya_8/zarabotnaya-plata/'

  def start_date
    Date.parse('01.05.1995')
  end

  protected

  def fetch_salaries_grouped_by_year
    puts "request to #{URL}}"
    body = Nokogiri::HTML(Net::HTTP.get(URI(URL)))
    rows = body.css('table tr')[1..-1].map { |row| row.css('th,td').map { |td| td.text.gsub(/\d+/).first.to_i } }
    rows.each_with_object({}) { |row, obj| obj[row[0].to_s[0..3].to_i] = row[1..-1] }
  end
end
