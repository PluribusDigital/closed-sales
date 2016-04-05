class Api::V1::LoansController < Api::V1::JSONAPIController

private

  def model
    Loan
  end

end