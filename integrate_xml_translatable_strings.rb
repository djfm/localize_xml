#!/usr/bin/ruby
require 'rexml/document'
require 'spreadsheet'

def usage
	puts "Usage: integrate_xml_translatable_strings.rb xls folder"
end

unless File.file?(xls=ARGV[0].to_s)
	puts "Please provide a excel file with the translated contents!"
	usage
	exit
end

unless File.directory?(xmls_path=ARGV[1].to_s)
	puts "Please provide a directory containing the XML files to integrate content to"
	usage
	exit
end

files = Hash.new { |hash, key| hash[key] = {} }

Spreadsheet.open(xls) do |book|
	sheet 	= book.worksheet('Translations')
	headers = sheet.row(0)
	sheet.each 1 do |row|
		h = Hash[headers.zip row]
		files[h['file']][h['xpath']] = h['translation'] || h['string']
	end
end

files.each_pair do |file, xPaths|
	if File.file? filePath="#{xmls_path}/#{file}"
		xmlDoc  = REXML::Document.new(File.new(filePath))
		xPaths.each_pair do |xPath, string|
			node = REXML::XPath.first xmlDoc, xPath
			if node.is_a? REXML::Attribute
				node.element.add_attribute node.name, string
			else
				node.text = string
			end
		end
		xmlDoc.write(File.new(filePath, 'w'))
	else
		puts "File not found: #{filePath}"
	end
end
