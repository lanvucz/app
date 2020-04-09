require './http_helper'
require 'json'
class DogApi

  REQUEST_HEADER = { "Accept" => 'application/json; charset=utf-8' }.freeze

  def get_breed_list
     cmd_uri = 'https://dog.ceo/api/breeds/list/all'
     data = HttpHelper.get(cmd_uri, REQUEST_HEADER.dup)
     return parse_json(data)
  end

  def get_breed_random_image(breed_name)
     cmd_uri = "https://dog.ceo/api/breed/#{breed_name}/images/random"
     data = HttpHelper.get(cmd_uri, REQUEST_HEADER.dup)
     return parse_json(data)
  end

  def get_sub_breed_random_image(breed_name, sub_breed_name)
     cmd_uri = "https://dog.ceo/api/breed/#{breed_name}/#{sub_breed_name}/images/random"
     data = HttpHelper.get(cmd_uri, REQUEST_HEADER.dup)
     return parse_json(data)
  end

  def get_breed_sub_list(breed_name)
    cmd_uri = "https://dog.ceo/api/breed/#{breed_name}/list"
    data = HttpHelper.get(cmd_uri, REQUEST_HEADER.dup)
    return parse_json(data)
  end

  def parse_json(data)
    JSON.parse(data, symbolize_names: true)
  end

end





# def get_account_statement(gopay_url, token, body)
#   cmd_uri = "#{gopay_url}#{ACCOUNT_GOPAY_REQUEST[:account_statement]}"
#   header = HTTP_REQUEST[:account_statement][:headers].dup
#   header[:Authorization] = "#{token[:token_type]} #{token[:access_token]}"
#   HttpHelper.post(cmd_uri, header, body)
#   # # pro HttpHelper.post ulozime soubor takto
#   # # File.open(temp_file.path, 'wb:ASCII-8BIT') {|file|
#   # #  file << binary_stream
#   # #}
#   # # pak # rescue => e # find class of error a errorHttpCode: e.class
# end



