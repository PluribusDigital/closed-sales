class Api::V1::SchemasController < ApplicationController

  def index
    meta = {so: 'meta'}
    data = [
      {id: 1, attributes:{endpoint:"loans"}, links:{self:api_v1_schemas_path+"/loans"} }
    ]
    render json: {meta: meta, data: data}
  end

  def show
    # we'll hard code this in now, since there is only 1
    # if the system grows, this should be dynamic
    if params["id"] == "loans" 
      fields = Loan.column_names.map{|n| {name:n,type:Loan.columns_hash[n].type.to_s} }
      fields.delete_if{|f|f[:name]=="id"}
      # get unique values for categorical fields
      %w(quality loan_type).each do |field|
        values = Loan.pluck(field).uniq
        fields[ fields.index{|f|f[:name]==field} ][:valid_values] = values
      end
      # get ranges for numeric fields or dates
      fields.each do |field|
        if %w(integer float date datetime).include? field[:type] 
          field[:min] = Loan.minimum(field[:name])
          field[:max] = Loan.maximum(field[:name])
        end
      end
      meta = {last_updated_date: "2016-04-02"}
      data = {
        type: "schema",
        id: 1,
        attributes: {
          endpoint: "loans",
          fields: fields
        }
      }
      render json: {meta: meta, data: data}
    end
  end

end