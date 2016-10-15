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

end