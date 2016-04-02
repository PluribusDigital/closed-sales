class Api::V1::LoansController < ApplicationController

  def index
    loans = Loan.all
    meta = OpenStruct.new
    links = OpenStruct.new
    # Fields param
    if params["fields"] && params["fields"]["loan"] 
      fields = params["fields"]["loan"].split(",").map{|f|f.to_sym} + ['id']
    end 
    loans = loans.select(fields) if fields
    # Sort 
    if params["sort"]
      # ternary to handle descending sort preceded by minus "sort=-field_name"
      sort = params["sort"].split(",").map{|i| i[0]=="-" ? {i[1..-1].to_sym => :desc} : {i.to_sym => :asc} }
      loans = loans.order(sort)
    end
    # Pagination
    if params[:page]
      meta.page_number = params[:page][:number].to_i
      meta.page_size = params[:page][:size].to_i
      meta.page_size = 10 if meta.page_size == 0
      loans = loans.page(meta.page_number).per(meta.page_size)
      meta.total_count = loans.total_count
      meta.total_pages = (meta.total_count / meta.page_size.to_f).ceil
      links.self = URI.unescape api_v1_loans_path('page[number]'=>meta.page_number, 'page[size]'=>meta.page_size)
      links.first = URI.unescape api_v1_loans_path('page[number]'=>1, 'page[size]'=>meta.page_size)
      if meta.page_number > 1
        links.prev = URI.unescape api_v1_loans_path('page[number]'=>meta.page_number-1, 'page[size]'=>meta.page_size)
      end
      if meta.page_number < meta.total_pages
        links.next = URI.unescape api_v1_loans_path('page[number]'=>meta.page_number+1, 'page[size]'=>meta.page_size)
      end
      links.last = URI.unescape api_v1_loans_path('page[number]'=>meta.total_pages, 'page[size]'=>meta.page_size)
    end
    data = loans.map{|l| {
      id: l.id, 
      attributes: l.attributes.delete_if{|k,v|["id","created_at","updated_at"].include? k},
      links: { self:api_v1_loan_path(l)} 
    }}
    render json: {meta: meta.to_h, links: links.to_h, data: data}
  end

end