class Api::V1::LoansController < Api::V1::BaseController

  def index
    loans = Loan.all.limit(10)
    if params["fields"] && params["fields"]["loan"] 
      fields = params["fields"]["loan"].split(",").map{|f|f.to_sym}
    end 
    loans = loans.select(fields) if fields    
    render json: serialize_models(loans, fields:fields)
  end

  def show
    loan = Loan.find(params[:id])
    render json: serialize_model(loan)
  end

end