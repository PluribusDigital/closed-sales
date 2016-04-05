class Api::V1::LoansController < Api::V1::JSONAPIController

before_filter :add_cors_headers

private

  def model
    Loan
  end

  def add_cors_headers
    origin = request.headers["Origin"]
    unless (not origin.nil?) and (origin == "http://localhost" or origin.starts_with? "http://localhost:")
      origin = "https://your.production-site.org"
    end
    headers['Access-Control-Allow-Origin'] = origin
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT, DELETE'
    allow_headers = request.headers["Access-Control-Request-Headers"]
    if allow_headers.nil?
      #shouldn't happen, but better be safe
      allow_headers = 'Origin, Authorization, Accept, Content-Type'
    end
    headers['Access-Control-Allow-Headers'] = allow_headers
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Max-Age'] = '1728000'
  end
end