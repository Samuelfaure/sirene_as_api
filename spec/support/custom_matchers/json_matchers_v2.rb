# Deprecated in V3
RSpec::Matchers.define :look_like_json do
  match do |string|
    begin
      JSON.parse(string)
    rescue JSON::ParserError
      false
    end
  end

  failure_message do |string|
    "\"#{string}\" is not parsable by JSON.parse"
  end

  description do
    'Expect to be JSON parsable string'
  end
end

def body_as_json
  json_str_to_hash(response.body)
end

def json_str_to_hash(str)
  JSON.parse(str).with_indifferent_access
end

