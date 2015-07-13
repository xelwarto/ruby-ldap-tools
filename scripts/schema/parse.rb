#!/usr/bin/env ruby

$:.push File.expand_path("../../lib", File.dirname(__FILE__))
require 'ldap/schema/tools'

if ARGV.size < 1
  puts 'Error: file name expected as parameter'
else
  file_str = String.new
  Dir.glob(ARGV) do |file|
    file_str.concat(File.read(file))
  end
  schema = Ldap::Schema::Tools.new(file_str)
  #schema.sort

  schema.attributeTypes.each do |attr|
    if attr[:name] =~ /unfpa/i
      puts "attributeTypes: #{attr[:raw_schema]}"
    end
  end

  schema.objectClasses.each do |obj|
    if obj[:name] =~ /unfpa/i
      s = "objectClasses: #{obj[:schema]}"
      s.gsub!(/STRUCTURAL\s?/i, '')

      s_array = []
      while s.length > 78 do
        s_array.push(s.slice!(0..77))
        s.prepend(' ')
      end
      s_array.push(s)

      puts s_array.join("\n")
    end
  end


end
