module SalaryHistory end

class SalaryHistory::BaseTable
  require 'net/http'

  def value(date)
    year_salaries = salaries_grouped_by_year[date.year]
    (year_salaries && year_salaries[date.month - 1]).to_i
  end

  def start_date
    raise NotImplementedError
  end

  protected

  def salaries_grouped_by_year
    @salaries_grouped_by_year ||= fetch_salaries_grouped_by_year
  end

  def fetch_salaries_grouped_by_year
    raise NotImplementedError
  end
end
