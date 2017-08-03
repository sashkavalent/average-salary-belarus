require 'json'
require 'net/http'
require 'fileutils'

class Converter
  def initialize(date)
    FileUtils.mkdir_p('rates')
    file_name = "rates/#{format_date(date)}"
    json = if File.exist?(file_name)
             File.read(file_name)
           else
             puts "request to #{url(date)}"
             Net::HTTP.get(URI(url(date))).tap { |rates| File.write(file_name, rates) }
           end
    @rates = JSON.parse(json)
  end

  def to_dollars(amount_in_rubles)
    dollar_rate = @rates.find { |rate| rate['Cur_Abbreviation'] == 'USD' }['Cur_OfficialRate']
    result = amount_in_rubles / dollar_rate
    (result.to_i < 1 ? result * 10000 : result).to_i
  end

  private

  def url(date)
    "http://www.nbrb.by/API/ExRates/Rates?onDate=#{format_date(date)}&Periodicity=0"
  end

  def format_date(date)
    date.strftime('%Y-%m')
  end
end
