class LoanImportService 
  # Service to import loan data via scraping
  # SOURCE: https://sales.fdic.gov/closedsales/LoanSales.asp

  def self.base_url
    "https://sales.fdic.gov"
  end

  def self.page_url
    base_url + "/closedsales/LoanSales.asp"
  end

  def self.scrape_data 
    results = []
    i=1
    agent = Mechanize.new
    target_page = agent.get page_url
    # Submit the search form w/ no filters, yielding all records
    search_form = target_page.form("form1")
    find_button = search_form.buttons.find("Find").first
    page = search_form.submit find_button
    # Grab the data for the page
    results = results + parse_page(page)
    next_button = page.form("form1").buttons.select{|b|b.value=="Next"}.first
    while next_button do 
      puts i
      page = page.form("form1").submit next_button
      results = results + parse_page(page)
      next_button = page.form("form1").buttons.select{|b|b.value=="Next"}.first
      # byebug
      i+=1
      sleep 5
    end
    return results
  end

  def self.parse_page(page)
    results = []
    data_table = page.search("table[width='900'] tr")
    data_table.each do |row|
      cells = row.search("td").map{|c|c.text.strip}
      if cells.count == 11
        object = {
          sale_id: cells[1],
          site_name: cells[2],
          date_sold: cells[3],
          loan_type: cells[4],
          quality: cells[5],
          number_of_loans: cells[6],
          book_value: cells[7],
          sales_price: cells[8],
          winning_bidder: cells[9],
          address: cells[10]
        }
        results << object
      end
    end
    return results
  end

  def self.import_data
    scrape_data.each do |item|
      Loan.create item
    end
  end

  def self.write_data_file
    File.open('data/loans.json', 'w') do |f|
      f.puts Loan.all.to_json
    end
  end

  def self.import_data_from_file
    Loan.delete_all
    Loan.transaction do 
      JSON.parse(File.read('data/loans.json')).each do |r|
        r.delete("id")
        Loan.create r
      end
    end
  end

end