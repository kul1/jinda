# frozen_string_literal: true

module MindmapConverter
  class << self
    # Convert FreeMind XML to jsMind JSON format
    def xml_to_jsmind(xml_string)
      require 'rexml/document'
      
      doc = REXML::Document.new(xml_string)
      root_node = doc.elements['//node[@TEXT="Jinda"]'] || doc.elements['//node'].first
      
      unless root_node
        return default_mindmap
      end

      {
        meta: {
          name: 'Jinda Mindmap',
          author: 'Jinda Generator',
          version: '1.0'
        },
        format: 'node_tree',
        data: parse_node(root_node)
      }
    end

    # Convert jsMind JSON to FreeMind XML format
    def jsmind_to_xml(json_hash)
      require 'rexml/document'
      
      doc = REXML::Document.new
      doc << REXML::XMLDecl.new('1.0', 'UTF-8')
      
      map = doc.add_element('map', { 'version' => '1.0.1' })
      
      # Build the tree from JSON data
      data = json_hash.is_a?(String) ? JSON.parse(json_hash) : json_hash
      build_node(map, data['data'] || data[:data])
      
      # Format output
      formatter = REXML::Formatters::Pretty.new(2)
      formatter.compact = true
      output = String.new
      formatter.write(doc, output)
      output
    end

    private

    # Parse XML node recursively to jsMind format
    def parse_node(xml_node)
      text = xml_node.attributes['TEXT'].to_s
      node_id = xml_node.attributes['ID'] || generate_id
      position = xml_node.attributes['POSITION']
      
      # Extract icon if present
      icon_elem = xml_node.elements['icon']
      icon = icon_elem&.attributes&.[]('BUILTIN')
      
      # Build node data
      node_data = {
        id: node_id,
        topic: text
      }
      
      # Add position for main branches
      node_data[:direction] = position if position
      
      # Extract custom data (icon, role, rule, etc.)
      custom_data = {}
      custom_data[:icon] = icon if icon
      
      # Collect option nodes (role, rule, confirm, display)
      option_nodes = []
      
      # Parse children
      children = []
      xml_node.each_element('node') do |child_node|
        child_text = child_node.attributes['TEXT']
        
        # Check if it's an option node
        if child_text =~ /^(role|rule|confirm|display):\s*(.+)/i
          option_type = $1.downcase
          option_value = $2.strip
          custom_data[option_type.to_sym] = option_value
          option_nodes << child_node
        else
          # Regular child node
          children << parse_node(child_node)
        end
      end
      
      # Add custom data if present
      node_data[:data] = custom_data unless custom_data.empty?
      
      # Add children if present
      node_data[:children] = children unless children.empty?
      
      node_data
    end

    # Build XML node recursively from jsMind data
    def build_node(parent_xml, node_data)
      return unless node_data
      
      # Create node attributes
      attrs = {
        'TEXT' => node_data['topic'] || node_data[:topic],
        'ID' => node_data['id'] || node_data[:id] || generate_id
      }
      
      # Add position if present
      if node_data['direction'] || node_data[:direction]
        attrs['POSITION'] = node_data['direction'] || node_data[:direction]
      end
      
      # Add CREATED and MODIFIED timestamps
      timestamp = (Time.now.to_f * 1000).to_i
      attrs['CREATED'] = timestamp.to_s
      attrs['MODIFIED'] = timestamp.to_s
      
      # Create the node element
      node_elem = parent_xml.add_element('node', attrs)
      
      # Add icon if present in custom data
      custom_data = node_data['data'] || node_data[:data]
      if custom_data
        if custom_data['icon'] || custom_data[:icon]
          icon_elem = node_elem.add_element('icon')
          icon_elem.attributes['BUILTIN'] = custom_data['icon'] || custom_data[:icon]
        end
        
        # Add option nodes (role, rule, etc.) as child nodes
        %w[role rule confirm display].each do |opt|
          value = custom_data[opt] || custom_data[opt.to_sym]
          if value
            option_attrs = {
              'TEXT' => "#{opt}: #{value}",
              'ID' => generate_id,
              'CREATED' => timestamp.to_s,
              'MODIFIED' => timestamp.to_s
            }
            node_elem.add_element('node', option_attrs)
          end
        end
      end
      
      # Add children recursively
      children = node_data['children'] || node_data[:children]
      if children && children.is_a?(Array)
        children.each do |child|
          build_node(node_elem, child)
        end
      end
    end

    def generate_id
      "ID_#{rand(100000000..999999999)}"
    end

    def default_mindmap
      {
        meta: {
          name: 'Jinda Mindmap',
          author: 'Jinda Generator',
          version: '1.0'
        },
        format: 'node_tree',
        data: {
          id: 'root',
          topic: 'Jinda',
          children: [
            {
              id: 'models',
              topic: 'models',
              direction: 'left',
              children: []
            },
            {
              id: 'services',
              topic: 'services',
              direction: 'right',
              children: []
            },
            {
              id: 'roles',
              topic: 'roles',
              direction: 'right',
              children: []
            }
          ]
        }
      }
    end
  end
end
