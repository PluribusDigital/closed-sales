class LoanScraperService 
  # Service to scrape loan data into a file
  # SOURCE: https://sales.fdic.gov/closedsales/LoanSales.asp
  # Saves file to public URL 

  def self.base_url
    "https://sales.fdic.gov"
  end

  def self.page_url
    base_url + "/closedsales/LoanSales.asp"
  end

  def self.output_path
    'public/data/loans.json'
  end

  def self.scrape_data_to_file
    data = scrape_data
    File.open(output_path, 'w') do |f|
      f.puts data.to_json
    end
    puts "#{data.length} records written to #{output_path}"
  end

  def self.scrape_data 
    results = []
    i=1
    agent = Mechanize.new
    target_page = agent.get page_url
    # Submit the search form w/ no filters, yielding all records
    # Set the page size to 1000 to cut # of page requests by 1/10
    # (setting of 9999 to try to go in 1 request yielded server error)
    search_form = target_page.form("form1")
    search_form.field_with(name:"LoanUserPageSize").value = "1000"
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

end