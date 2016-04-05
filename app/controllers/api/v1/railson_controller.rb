class Api::V1::RailsonController < ApplicationController

  require 'csv'

  def index 
    @model = parse_path(request.env['PATH_INFO'])
    results = @model.all
    meta   = OpenStruct.new
    links  = {}
    errors = {}
    # Fields param
    if params["fields"] && params["fields"][path_base] 
      fields = params["fields"][path_base].split(",").map{|f|f.to_sym} + ['id']
    end 
    results = results.select(fields) if fields
    # Sort 
    if params["sort"]
      # ternary to handle descending sort preceded by minus "sort=-field_name"
      sort = params["sort"].split(",").map{|i| i[0]=="-" ? {i[1..-1].to_sym => :desc} : {i.to_sym => :asc} }
      results = results.order(sort)
    end
    # String Filter
    if params["filter"] && params["filter"]["string"]
      fields = params["filter"]["string"].keys.first.split(',')
      string = params["filter"]["string"].values.first.downcase
      results = apply_string_filter(results,fields,string)
    end
    # Exact Filter
    if params["filter"] && params["filter"]["exact"]
      field = params["filter"]["exact"].keys.first
      string = params["filter"]["exact"].values.first
      results = apply_exact_filter(results,field,string)
    end
    # Range Filter
    if params["filter"] && params["filter"]["range"]
      field = params["filter"]["range"].keys.first
      range = params["filter"]["range"].values.first.split(",")
      results = apply_range_filter(results,field,range)
    end
    # Pagination
    if params[:page]
      meta.page_number = params[:page][:number].to_i
      meta.page_size = params[:page][:size].to_i
      meta.page_size = 10 if meta.page_size == 0
      results = results.page(meta.page_number).per(meta.page_size)
      meta.total_count = results.total_count
      meta.total_pages = (meta.total_count / meta.page_size.to_f).ceil
      links.merge! pagination_links(meta.page_number,meta.page_size,meta.total_pages)
    end
    links.merge!({csv: path_to_csv(params.dup)})
    data = results.map{|r| {
      id: r.id, 
      attributes: r.attributes.delete_if{|k,v|["id","created_at","updated_at"].include? k},
      links: { self: send("api_v1_#{path_base.pluralize}_path",r) } 
    }}
    # handle CSV or JSON response formats
    respond_to do |format|
      format.csv { render text: results_to_csv(results) }
      format.json { render json: {meta: meta.to_h, links: links, data: data} }
    end
  end

private

  def apply_string_filter(results,fields,string) 
    subclauses, clause_params = [], []
    fields.each do |field|
      # SQL Injection safeguard
      raise "invalid column supplied for filter" unless @model.column_names.include? field
      subclauses << "LOWER( #{field} ) LIKE ?"
      clause_params << "%#{string.downcase}%"
    end
    clause = [subclauses.join(" OR ")] + clause_params
    return results.where(clause)
  end

  def apply_exact_filter(results,filter_field,filter_string)
    # SQL Injection safeguard
    raise "invalid column supplied for filter" unless @model.column_names.include? filter_field
    return results.where(filter_field => filter_string)
  end

  def apply_range_filter(results,field,range)
    type = @model.columns_hash[field].type
    range = range.map{|r|r.to_i} if type == :integer
    results = results.where(field => range[0]..range[1])
  end

  def parse_path(path)
    return eval path.split("/").last.split(".").first.titleize.singularize
  end

  def path_base
    @model.to_s.downcase
  end

  def pagination_link(number,size)
    URI.unescape send( "api_v1_#{path_base.pluralize}_path", 'page[number]'=>number, 'page[size]'=>size )
  end

  def pagination_links(number,size,total)
    links={}
    links[:self]  = pagination_link(number,size)
    links[:first] = pagination_link(1,size)
    links[:prev]  = pagination_link(number-1,size) if number > 1
    links[:next]  = pagination_link(number+1,size) if number < total
    links[:last]  = pagination_link(total,size)
    return links
  end

  def results_to_csv(results)
    cols = @model.column_names.delete_if{|i| %w(id created_at updated_at).include? i}
    CSV.generate() do |csv|
      csv << cols
      results.each do |result|
        csv << result.attributes.values_at(*cols)
      end
    end
  end

  def path_to_csv(params)
    params.delete_if{|k,v|%w(action controller format page).include? k}
    return URI.unescape api_v1_loans_path(params.merge({format:'csv'}))
  end

end