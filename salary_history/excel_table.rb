require_relative 'base_table'
require 'creek'

class SalaryHistory::ExcelTable < SalaryHistory::BaseTable
  # Link is from https://www.belstat.gov.by/ofitsialnaya-statistika/realny-sector-ekonomiki/stoimost-rabochey-sily/operativnye-dannye/nominalnaya-nachislennaya-srednemesyachnaya-zarabotnaya-plata-rabotnikov-respubliki-belarus-po-kvart/vidam-ekonomicheskoy-deyatelnosti-po-kvartalam-2018-g/
  # "Номинальная начисленная средняя заработная плата работников Республики Беларусь с 1991 по 2019 гг. (.xls)"
  URL = 'https://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/2019/nach_sr_zarplata-91-19_1911.xlsx'.freeze

  def start_date
    Date.parse('01.01.1991')
  end

  protected

  def fetch_salaries_grouped_by_year
    puts "request to #{URL}}"
    path = 'salaries/2019.xlsx'
    CachedRequest.run(URL, path)
    creek = Creek::Book.new "cache/#{path}"
    sheet = creek.sheets[0]
    rows = sheet.rows.to_a[4..32].map { |row| row.values[1..] }

    rows.each_with_object({}) do |row, obj|
      obj[row[0][0..3].to_i] = row[1..].map(&:to_i)
    end
  end
end

