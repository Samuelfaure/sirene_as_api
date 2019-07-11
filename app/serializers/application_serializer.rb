class ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attr_accessor :model

  def self.all_fields
    @model.header_mapping.values
  end
end
