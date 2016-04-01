require 'spec_helper'

RSpec.describe "Loans API" do

  before :each do 
    Loan.create(sale_id: "93F11",site_name: "Dallas Field Branch",date_sold: nil,loan_type: "RE Commercial",quality: "Performing",number_of_loans: 42,book_value: 0,sales_price: 0,winning_bidder: "Army National Bank  ",address: "300 KansasFt. Leavenworth, KS 66027")
    Loan.create(sale_id: "93D23", site_name: "Dallas Field Branch", date_sold: nil, loan_type: "RE Commercial", quality: "Non-Performing", number_of_loans: 2, book_value: 0, sales_price: 0, winning_bidder: "KCL Pacific Corporation  ", address: "136 East South TempleSalt Lake City, UT 84111")
    Loan.create(sale_id: "93D24",site_name: "Dallas Field Branch",date_sold: nil,loan_type: "Other",quality: "Performing",number_of_loans: 11,book_value: 0,sales_price: 0,winning_bidder: "Bank Midwest, NA  ",address: "1111 Main St, Suite 1600Kansas City, MO 64105")
  end

  describe "index" do 

    it "should provide results with id, attributes" do 
      get "/api/v1/loans.json"
      expect(json["data"].first["id"]).to be_present
      expect(json["data"].first["attributes"]["sale_id"]).to be_present
    end

    it "should include links" do 
      get "/api/v1/loans.json"
      expect(json["data"].first["links"]["self"]).to be_present
    end

    describe "pagination" do 

      it "should limit results based on page parameters" do 
        get "/api/v1/loans.json?page[number]=1&page[size]=2"
        expect(json["data"].length).to eq 2
      end

      it "should get a next page" do 
        get "/api/v1/loans.json?page[number]=2&page[size]=2"
        expect(json["data"].first["attributes"]["sale_id"]).to eq '93D24'
      end

      it "should provide pagination links" do 
        get "/api/v1/loans.json?page[number]=2&page[size]=2"
        expect(json["links"]['first']).to be_present
      end

    end

    describe "fields" do 

      it "should return only those fields specified, and not others" do 
        get "/api/v1/loans.json?fields[loan]=sale_id,site_name"
        expect(json["data"].first["attributes"]["sale_id"]).to be_present
        expect(json["data"].first["attributes"]["site_name"]).to be_present
        expect(json["data"].first["attributes"]["quality"]).to_not be_present
      end
      
    end

  end

end