# encoding:utf-8
require 'json'

module FileHelper

  DEFAULT_LOAD_ATTRS = {
    ttl: 72000,
    demanded_reload: false
  }.freeze

  def self.get_output_dir(file_base_name)
    output_dir =  File.join(Dir.pwd, 'output')
    Dir.mkdir(output_dir) unless File.exists?(output_dir)
    path = File.join(output_dir, file_base_name)
    path
  end

  def self.get_creation_time(buffer_file)
    win_platform = Gem.win_platform?
    if win_platform
      buffer_file.mtime
    elsif !win_platform
      buffer_file.ctime
    end
  end

  def self.get_file_creation_time_by_path(cache_file_path)
    win_platform = Gem.win_platform?
    if win_platform
      File.mtime(cache_file_path)
    elsif !win_platform
      File.mtime(cache_file_path)
    end
  end

  def self.reload_file?(cache_file_path, params)
    now = Time.now
    win_platform = Gem.win_platform?
    if params[:demanded_reload] or !File.exists?(cache_file_path)
      true
    elsif win_platform and now - File.mtime(cache_file_path) >= params[:ttl]
      true
    elsif !win_platform and now - File.ctime(cache_file_path) >= params[:ttl]
      true
    else
      false
    end
  end

  def self.get_file_attribute(file_path)
    {path: file_path, creation_time: get_file_creation_time_by_path(file_path).to_s}
  end

  def self.load_cached_file(url, parameters = {})
    cache_file_path = get_output_dir(url.split('/').last)
    params = DEFAULT_LOAD_ATTRS.dup.merge(parameters)
    if reload_file?(cache_file_path, params)
      file_attribute = yield
    else
      file_attribute = get_file_attribute(cache_file_path)
    end
    file_attribute
  end

  def self.append_to_file(file_base_name, breed_data)
    file_path = get_output_dir(file_base_name)
    File.open(file_path, 'a+:UTF-8'){|f|
      f.flock(File::LOCK_EX)
      data = []
      str = f.read
      if !str.to_s.empty?
        data = JSON.parse(str)
      end
       data << breed_data
       f.truncate(0)
       f.write data.to_json
       f.flush
    }
  end

end


