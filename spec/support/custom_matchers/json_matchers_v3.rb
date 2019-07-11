def diff_json_schema(body, model)
  schema_directory = "#{Dir.pwd}/spec/support/schemas"
  schema_path = "#{schema_directory}/#{model}.json"
  schema = Pathname.new(schema_path)

  schemer = JSONSchemer.schema(schema, format: true)
  schemer.validate(body).to_a
end

def subject_json
  JSON.parse(subject)
end

def response_data
  response.parsed_body['data']
end
