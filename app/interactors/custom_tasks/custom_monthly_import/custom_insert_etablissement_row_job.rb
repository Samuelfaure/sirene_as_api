class CustomInsertEtablissementRowsJob < InsertEtablissementRowsJob
  attr_accessor :lines

  def initialize(lines, model)
    @lines = lines
    @model_snake_case = model.to_s.underscore.pluralize
  end

  def perform
    etablissements = []

    lines.each do |line|
      etablissements << EtablissementAttrsFromLine.instance.call(line)
    end

    ar_keys = %w[created_at updated_at]
    ar_keys << etablissements.first.keys.map(&:to_s)
    ar_keys.flatten

    ar_values_string = etablissements.map { |h| value_string_from_enterprise_hash(h) }.join(', ')

    ar_query_string = " INSERT INTO #{@model_snake_case} (#{ar_keys.join(',')})
                        VALUES
                        #{ar_values_string}; "

    ActiveRecord::Base.connection.execute(ar_query_string)
    true
  end
end
