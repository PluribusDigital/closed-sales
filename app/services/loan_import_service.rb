class LoanImportService 
  require 'net/http'
  # Service to import loan data from a file available via http
  # SOURCE: https://sales.fdic.gov/closedsales/LoanSales.asp

  def self.source_url
    "http://localhost:3000/data/loans.json"
  end

  def self.import_data_from_file
    Loan.delete_all
    object = JSON.parse(get_file)
    Loan.transaction do 
      object.each do |r|
        # massage the non-string fields
        r["date_sold"] = parse_date(r["date_sold"])
        r["number_of_loans"] = parse_int(r["number_of_loans"])
        r["book_value"] = parse_int(r["book_value"])
        r["sales_price"] = parse_int(r["sales_price"])
        # create the record
        Loan.create r
      end
    end
    puts "#{object.length} records written from file #{source_url}"
  end

  def self.get_file
    url = URI.parse(source_url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    return res.body
  end

  def self.parse_date(string)
    mm,dd,yyyy = string.split('/')
    return "#{yyyy}-#{mm}-#{dd}".to_date
  end

  def self.parse_int(string)
    string = string.gsub('$','').gsub(',','')
    return string.to_i
  end

end