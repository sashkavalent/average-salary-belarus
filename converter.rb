require 'json'
require 'net/http'
require 'fileutils'

class Converter
  def self.start_date
    Date.parse('01.04.1995')
  end

  def initialize(date)
    json = CachedRequest.run(url(date), "rates/#{format_date(date)}")
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
