require 'spec_helper'

RSpec.describe "Loans API" do

  before :each do 
    Loan.create(sale_id: "93F11",site_name: "Dallas Field Branch",date_sold: nil,loan_type: "RE Commercial",quality: "Performing",number_of_loans: 42,book_value: 100,sales_price: 0,winning_bidder: "Army National Bank  ",address: "300 KansasFt. Leavenworth, KS 66027")
    Loan.create(sale_id: "93D23", site_name: "Dallas Field Branch", date_sold: nil, loan_type: "RE Commercial", quality: "Non-Performing", number_of_loans: 2, book_value: 200, sales_price: 0, winning_bidder: "KCL Pacific Corporation  ", address: "136 East South TempleSalt Lake City, UT 84111")
    Loan.create(sale_id: "93D24",site_name: "Dallas Field Branch",date_sold: nil,loan_type: "Other",quality: "Performing",number_of_loans: 11,book_value: 0,sales_price: 300,winning_bidder: "Bank Midwest, 84111 NA ",address: "1111 Main St, Suite 1600Kansas City, MO 64105")
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

    describe "sort" do 

      it "should sort by a single text column" do 
        get "/api/v1/loans.json?sort=loan_type"
        ids = json["data"].map{|i|i["attributes"]["sale_id"]}
        expect(ids).to eq ['93D24','93F11','93D23']
      end

      it "should sort by a single numeric column" do 
        get "/api/v1/loans.json?sort=number_of_loans"
        ids = json["data"].map{|i|i["attributes"]["sale_id"]}
        expect(ids).to eq ['93D23','93D24','93F11']
      end

      it "should sort by multiple columns" do 
        get "/api/v1/loans.json?sort=loan_type,number_of_loans"
        ids = json["data"].map{|i|i["attributes"]["sale_id"]}
        expect(ids).to eq ['93D24','93D23','93F11']
      end

      it "should sort descending when field is preceded by minus (-)" do 
        get "/api/v1/loans.json?sort=-number_of_loans"
        ids = json["data"].map{|i|i["attributes"]["sale_id"]}
        expect(ids).to eq ['93F11','93D24','93D23']
      end

      it "should sort multiple columns, one descending" do 
        get "/api/v1/loans.json?sort=loan_type,-number_of_loans"
        ids = json["data"].map{|i|i["attributes"]["sale_id"]}
        expect(ids).to eq ['93D24','93F11','93D23']
      end

    end

    describe "filter" do

      it "should match a substring on a single field (case insensitive)" do 
        get "/api/v1/loans.json?filter[string][winning_bidder]=BANK"
        expect(json["data"].length).to eq 2
      end

      it "should match a substring across multiple fields (OR)" do 
        get "/api/v1/loans.json?filter[string][winning_bidder,address]=84111"
        expect(json["data"].length).to eq 2
      end

      it "should match a string exactly on a single field" do 
        get "/api/v1/loans.json?filter[exact][quality]=Performing"
        expect(json["data"].length).to eq 2
      end

      it "should combine 2 exact matches as an AND" do 
        get "/api/v1/loans.json?filter[exact][quality]=Performing&filter[exact][loan_type]=Other"
        expect(json["data"].length).to eq 1
      end

      it "should match a range" do 
        get "/api/v1/loans.json?filter[range][number_of_loans]=0,20"
        expect(json["data"].length).to eq 2
      end

      it "should combine 2 ranges as an AND" do 
        get "/api/v1/loans.json?filter[range][number_of_loans]=0,20&filter[range][sales_price]=250,350"
        expect(json["data"].length).to eq 1
      end

      it "should match an alternate range" do 
        get "/api/v1/loans.json?filter[range][number_of_loans]=8,20"
        expect(json["data"].length).to eq 1
      end

      it "should perform AND search for multiple filters" do 
        get "/api/v1/loans.json?filter[range][number_of_loans]=0,20&filter[exact][quality]=Performing"
        expect(json["data"].length).to eq 1
      end

    end

    describe "schema metadata" do 

      it "should list schemas" do 
        get "/api/v1/schemas" 
        expect(json["data"][0]["attributes"]["endpoint"]).to eq "loans"
      end

      it "should provide schema for endpoint" do 
        get "/api/v1/schemas/loans" do 
          expect(json["data"]["type"]).to eq "schema"
          expect(json["data"]["attributes"]["fields"]).to be_present
        end
      end

    end

  end

end