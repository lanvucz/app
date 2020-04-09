# encoding: utf-8
require 'csv'

class ExportCSV

  EXPORT_CSV = {
    :csv_opt => {:col_sep => ";", :row_sep => "\n", :quote_char => '"', :force_quotes => true}
  }
  HEADER = ['breed_name', 'link_to_image']

  def generate_breed_csv(breed_attributes)
    file_name = breed_attributes[:breed_name]
    file_path = FileHelper.get_output_dir( file_name + '.csv')
    temp_file = File.new(file_path, 'w:utf-8')
    csv_attributes = {path: temp_file.path, creation_time: FileHelper.get_creation_time(temp_file).to_s}
    temp_file.close
    begin
      csv_file = CSV.open(temp_file, 'w', EXPORT_CSV[:csv_opt])
      header = HEADER.dup
      csv_file.add_row(header)
      breed_attributes[:image_attributes].each do |breed_name, file_attribute_list|
        path_list = file_attribute_list.map{|h| h[:path]}
        csv_file.add_row([breed_name, path_list])
      end
    rescue CSV::MalformedCSVError => e
        raise e
    ensure
      csv_file.close if csv_file && !csv_file.closed?
    end
    csv_attributes
  end

end