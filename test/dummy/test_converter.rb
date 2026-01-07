#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/jinda/mindmap_converter'
require 'json'
require 'fileutils'

# Test XML to JSON conversion
puts "=== Testing MindmapConverter ==="
puts

# Read the actual index.mm file
xml_file = File.join(__dir__, 'app/jinda/index.mm')

if File.exist?(xml_file)
  puts "Reading: #{xml_file}"
  xml_content = File.read(xml_file)
  puts "XML size: #{xml_content.size} bytes"
  puts

  # Convert to jsMind JSON
  puts "Converting XML to jsMind JSON..."
  begin
    json_data = MindmapConverter.xml_to_jsmind(xml_content)
    puts "✓ Conversion successful!"
    puts
    
    # Show structure
    puts "Root node: #{json_data[:data][:topic]}"
    puts "Root children: #{json_data[:data][:children]&.length || 0}"
    
    if json_data[:data][:children]
      json_data[:data][:children].each do |child|
        puts "  - #{child[:topic]} (#{child[:children]&.length || 0} children)"
      end
    end
    puts
    
    # Save to file for inspection
    output_file = File.join(__dir__, 'tmp/mindmap_test.json')
    FileUtils.mkdir_p(File.dirname(output_file))
    File.write(output_file, JSON.pretty_generate(json_data))
    puts "JSON saved to: #{output_file}"
    puts
    
    # Test round-trip: JSON back to XML
    puts "Testing round-trip conversion..."
    xml_output = MindmapConverter.jsmind_to_xml(json_data)
    
    output_xml_file = File.join(__dir__, 'tmp/mindmap_test.mm')
    File.write(output_xml_file, xml_output)
    puts "✓ XML regenerated"
    puts "XML saved to: #{output_xml_file}"
    puts
    
    puts "=== Test Complete ==="
    
  rescue StandardError => e
    puts "✗ Error: #{e.message}"
    puts e.backtrace.first(5)
  end
else
  puts "✗ File not found: #{xml_file}"
end
