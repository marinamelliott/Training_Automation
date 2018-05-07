require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

ENV['TIMESTAMP'] ||= Time.now.strftime "%Y-%m-%d_%H-%M-%S"

module RakeProfileHelper

  def self.setup_profile(task, name, or_tags_array = [])
    run_folder = (ENV["run_folder"] ? ENV["run_folder"] : "")

    task.profile = name

    output_folder = (ENV["output_folder"] ? ENV["output_folder"] + "/" + ENV['TIMESTAMP'][0,10] : "features/output" + "/" + ENV['TIMESTAMP'][0,10]) + "/"
    Dir.mkdir(output_folder) unless File.exists?(output_folder)

    html_name = "#{name}-#{ENV['TIMESTAMP']}"

    or_tags = ' --tags ' + or_tags_array.join(',') unless or_tags_array == []
    or_tags ||= ''

    and_tags = ENV["and_tags"].to_s.split(",").inject(""){|str, tag| str += tag.strip.index("~") == 0 ? (" --tags ~@" + tag.strip.delete("~") + " ") : (" --tags @" + tag.strip + " ")}
    ignore_extensions = %w{
      html htm yml jpg JPG tif bmp png doc docx xls xml pdf txt dot bat PNG mdb zip
    }.inject(" "){|s, ext| s += "--exclude \\.#{ext} "}

    task.cucumber_opts = "#{run_folder} --guess --color --verbose #{ignore_extensions} --format html --out #{output_folder + html_name}.html #{and_tags} #{or_tags}"
   end

  def self.get_or_tags_array()
    or_tags_array = []
    unless ENV['or_tags'].nil?
      or_tags_array = ENV['or_tags'].to_s.split(',').inject([]) { |arr,tag| arr << '@' + tag.strip; arr }
    end

    or_tags_array
  end

  def self.merge_or_tags(or_tags_array, access_or_tags_array)
    ( or_tags_array + access_or_tags_array )
  end

  def self.execute_multiple_browsers(browsers)
    begin
      ENV['browser_type'] = browsers[0]
      browsers.delete(ENV['browser_type'])
      Rake::Task["features:default"].execute
    ensure
      execute_multiple_browsers(browsers) if browsers.size > 0
    end
  end

end

namespace :features do
  or_tags_array = RakeProfileHelper.get_or_tags_array()

  Cucumber::Rake::Task.new(:default, "Run features with Default task") do |t|
    RakeProfileHelper.setup_profile(t, "default", or_tags_array)
  end

  Cucumber::Rake::Task.new(:run, "Run features with run task") do |t|
    RakeProfileHelper.setup_profile(t, "run", or_tags_array)
  end

  Cucumber::Rake::Task.new(:regression, "Run features with regression task") do |t|
    RakeProfileHelper.setup_profile(t, "regression", or_tags_array)
  end

  task :multiple_browser do |task|
    browsers = ENV['browser_type'].to_s.gsub(" ","").split(',')
    RakeProfileHelper.execute_multiple_browsers(browsers)
  end

end


