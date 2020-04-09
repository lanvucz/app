require './dog_api'
require './export_csv'
require './file_helper'
require './http_helper'
require 'celluloid/current'

class DogManagement
  include Celluloid

  def initialize
    @dog_api = DogApi.new
  end

  def export_breed(breed_name, output_file_name)
    sub_breed_list = @dog_api.get_breed_sub_list(breed_name)[:message]
    breed_attributes = {breed_name: breed_name, image_attributes: {}}
    image_attributes = {}
    if sub_breed_list.empty?
      res = @dog_api.get_breed_random_image(breed_name)
      image_attributes[breed_name] = res[:message]
    else
     sub_breed_list.each do |sub_breed_name|
       res = @dog_api.get_sub_breed_random_image(breed_name, sub_breed_name)
       image_attributes[sub_breed_name] = res[:message]
     end
    end
    image_attributes.each do |sub_breed_name, urls|
      url_list = urls && Array(urls)
      unless url_list.empty?
        file_attribute_list = []
        url_list.each do |image_url|
          file_attribute = FileHelper.load_cached_file(image_url) {
            HttpHelper.download_file(image_url)
          }
          file_attribute_list << file_attribute
        end
        breed_attributes[:image_attributes][sub_breed_name] =  file_attribute_list
      end
    end

    breed_attributes[:csv_attributes] = ExportCSV.new.generate_breed_csv(breed_attributes)
    output_file_path = FileHelper.append_to_file(output_file_name, breed_attributes)

    {status: "success", time: Time.now.to_s, breed_name: breed_name, thread_id: Thread.current.object_id}
  end

end
