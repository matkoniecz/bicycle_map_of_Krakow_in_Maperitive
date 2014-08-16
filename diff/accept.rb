require 'find'
require 'FileUtils'

if File.exists?("raw/after.png")
	Find.find('.') do |path|
		if path =~ /.*\.png$/
			if path =~ /.*after\.png$/
				FileUtils.copy(path, path.gsub("after.png", "before.png"))
				File.delete(path)
			elsif !(path =~ /.*before\.png$/)
				File.delete(path)
			end
		end
	end
end
