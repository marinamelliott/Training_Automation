#This script cleans out watir profiles that might be lingering in your temp folder after you've been running automated tests for a while.
require 'FileUtils'

path = "."

def directory_size(dir)
  #2**0  - bytes
  #2**10 - kilobytes
  #2**20 - megabytes
  #2**30 - gigabytes
  directories = Dir.glob(dir+"/*",File::FNM_DOTMATCH).select{ |f| File.directory?(f) && f.split("/").last.size > 2}
  files = Dir.glob(dir+"/*",File::FNM_DOTMATCH).select{ |f| !File.directory?(f) && f.split("/").last.size > 2}
  
  #directories
  size = directories.inject(0){ |sum, d| sum += directory_size(d)  }
  #files
  size += files.select{ |f| !File.directory? f}.inject(0){ |sum, f| 
  #p File.size(f).to_s + " " + f
  sum += File.size(f) }
  return size
end

#Clear the webdriver profiles from the temporary directory
p "The following has been detected as the temp directory:"
p ENV["TEMP"].gsub("\\","/")
size = 0
directories = 0
skip_delete = ARGV.include? "skip-delete"
if skip_delete
  p "Scanning temporary webdriver profiles"
else
  p "Deleting temporary webdriver profiles to free up precious disk space..."
end
["webdriver", "scoped_dir"].each{|subtype|
Dir.glob(ENV["TEMP"].gsub("\\","/")+"/*#{subtype}*").each do |webdriver_profile|
  size += directory_size(webdriver_profile)
  directories += 1
  p (skip_delete ? "Found in" : "Removing from") + " TEMP folder:" + webdriver_profile
  next if skip_delete
  FileUtils.rm_rf(webdriver_profile)
end
}
scale = "bytes"
scaled = size
if size > 2**30
  scale = "gigabytes"
  scaled = size.to_f / 2**30
elsif size > 2**20
  scale = "megabytes"
  scaled = size.to_f / 2**20
elsif size > 2**10
  scale = "kilobytes"
  scaled = size.to_f / 2**10
end


p (skip_delete ? "Webdriver-profiles take up " : "Cleaned up ") + ("%4.2f" % scaled) + " " + scale + " of disk space"
p "Across " + directories.to_s + " webdriver-profile directories"