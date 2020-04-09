require './dog_management.rb'

class App

  TIME_FORMAT = '%Y_%m_%d_%H_%M_%S'
  DEFAULT_RESULT_FILE_NAME = ['update_at','json']
  POOL_DEFAULT_SIZE = 5

  def run(dto_in)
    futures = []
    output_file_name = DEFAULT_RESULT_FILE_NAME[0] + '_' + Time.new.strftime(TIME_FORMAT) + '.' + DEFAULT_RESULT_FILE_NAME[1]
    dog_mng_pool = DogManagement.pool(size: POOL_DEFAULT_SIZE)
    dto_in.each do |breed_name|
        futures << dog_mng_pool.future(:export_breed, breed_name, output_file_name)
    end
    futures.map {|f| f.value }
    {status: 200, output_file: "./output/#{output_file_name}"}
  end

end

