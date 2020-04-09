# encoding:utf-8
require 'net/http'
require 'openssl'
require 'uri'
require 'open-uri'

module HttpHelper

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#   def self.post(cmd_uri, header, parameters)
#     uri = URI.parse(cmd_uri)
#     Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
#       request = Net::HTTP::Post.new(uri.request_uri, header)
#       request.body = parameters.to_json
#       response = http.request(request)
#       case response
#         when Net::HTTPSuccess
#           return response.body
#         else
#           raise response.body
#       end
#     end
#   end

  def self.get(cmd_uri, header)
    uri = URI.parse(cmd_uri)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri.request_uri, header)
      response = http.request(request)
      case response
        when Net::HTTPSuccess
          return response.body
        else
          raise response.body
        end
      end
   end

  def self.download_file(url, &block)
    file_path = FileHelper.get_output_dir(url.split('/').last)
    begin
      file = File.new(file_path, 'w')
      uri = URI.parse(url)
      downloaded = open(uri)
      IO.copy_stream(downloaded, file.path)
      file_attribute = FileHelper.get_file_attribute(file.path)
    ensure
      downloaded.close if downloaded && !downloaded.closed?
      file.close if file && !file.close
    end
    file_attribute
  end

end


