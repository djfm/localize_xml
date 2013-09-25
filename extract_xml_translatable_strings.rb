#!/usr/bin/ruby
require 'rexml/document'
require 'csv'
require 'writeexcel'

def usage
	puts "Usage: extract_xml_translatable_strings.rb template folder"
end

unless File.file?(template=ARGV[0].to_s)
	puts "Please provide a CSV file describing the translatable contents!"
	usage
	exit
end

unless File.directory?(xmls_path=ARGV[1].to_s)
	puts "Please provide a directory containing the XML files to extract content from"
	usage
	exit
end

fileXPaths = Hash.new { |hash, key| hash[key] = [] }

CSV.foreach template, :headers => true do |row|
	fileXPaths[row['file']] << row['xpath']
end

strings = []

fileXPaths.each_pair do |file, xPaths|
	if File.file? filePath="#{xmls_path}/#{file}"
		xmlDoc  = REXML::Document.new(File.new(filePath))
		xPaths.each do |xPath|
			REXML::XPath.each xmlDoc, xPath do |n|
				unless (string=(n.is_a?(REXML::Attribute) ? n.value : n.text).to_s.strip).empty?
					strings << {:file => file, :xpath => n.xpath, :string => string}
				end
			end
		end
	else
		puts "File not found: #{filePath}"
	end
end

strings.sort! do |a,b|
	a[:file]+a[:xpath] <=> b[:file]+b[:xpath]
end

workbook  = WriteExcel.new(ARGV[2] || "translatable_strings.xlsx")
worksheet = workbook.add_worksheet "Translations"

worksheet.write 0, 0, %w(file xpath string translation)
strings.each_with_index do |row, i|
	worksheet.write 1+i, 0, [row[:file], row[:xpath], row[:string], ""]
end

workbook.close

