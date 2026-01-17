# frozen_string_literal: true

require 'jinda/mindmap_converter'

class MindmapEditorController < ApplicationController
  before_action :require_admin
  skip_before_action :require_admin, only: [:load, :save, :upload]

  def edit
    mindmap_path = Rails.root.join('app/jinda/index.mm')
    
    begin
      if File.exist?(mindmap_path)
        xml_content = File.read(mindmap_path)
        @mind_data = MindmapConverter.xml_to_jsmind(xml_content)
      else
        @mind_data = MindmapConverter.default_mindmap
        flash.now[:warning] = 'Mindmap file not found. Showing default template.'
      end
    rescue StandardError => e
      Rails.logger.error "Mindmap load error: #{e.message}"
      @mind_data = MindmapConverter.default_mindmap
      flash.now[:error] = "Error loading mindmap: #{e.message}"
    end
  end

  def save
    json_data = params[:mind_data]
    save_path = params[:path] || 'app/jinda/index.mm'
    
    if json_data.blank?
      render json: { success: false, error: 'No data received' }, status: :bad_request
      return
    end

    begin
      # Convert JSON to XML
      xml_content = MindmapConverter.jsmind_to_xml(json_data)
      
      # Full path
      full_path = Rails.root.join(save_path)
      
      # Ensure directory exists
      FileUtils.mkdir_p(File.dirname(full_path))
      
      # Backup if exists
      if File.exist?(full_path)
        backup_path = Rails.root.join("#{save_path}.backup.#{Time.now.to_i}")
        FileUtils.cp(full_path, backup_path)
      end
      
      # Save new file
      File.write(full_path, xml_content)
      
      # Run rake jinda:update only if saving to index.mm
      output = ''
      if save_path == 'app/jinda/index.mm'
        output = `cd #{Rails.root} && rake jinda:update 2>&1`
      end
      
      render json: { 
        success: true, 
        message: "Mindmap saved to #{save_path}",
        output: output
      }
    rescue StandardError => e
      render json: { 
        success: false, 
        error: e.message,
        backtrace: e.backtrace&.first(5)
      }, status: :internal_server_error
    end
  end

  def load
    load_path = params[:path] || 'app/jinda/index.mm'
    full_path = Rails.root.join(load_path)
    
    if File.exist?(full_path)
      xml_content = File.read(full_path)
      json_data = MindmapConverter.xml_to_jsmind(xml_content)
      render json: json_data
    else
      render json: { error: 'File not found' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def upload
    uploaded_io = params[:file]
    if uploaded_io
      xml_content = uploaded_io.read
      if xml_content.present?
        begin
          json_data = MindmapConverter.xml_to_jsmind(xml_content)
          render json: { success: true, data: json_data }
        rescue => e
          render json: { success: false, error: e.message }, status: :unprocessable_entity
        end
      else
        render json: { success: false, error: 'File is empty' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: 'No file uploaded' }, status: :unprocessable_entity
    end
  end

  def export
    mindmap_path = Rails.root.join('app', 'jinda', 'index.mm')
    if File.exist?(mindmap_path)
      send_file mindmap_path, type: 'application/xml', disposition: 'attachment', filename: 'index.mm'
    else
      render plain: 'Mindmap file not found', status: :not_found
    end
  end

  private

  def require_admin
    # In development, allow access if user is logged in
    # In production, require admin role (A)
    if Rails.env.development?
      unless current_ma_user
        flash[:error] = 'Please login first.'
        redirect_to root_path
      end
    else
      unless current_ma_user && current_ma_user.role&.upcase&.split(',')&.include?('A')
        flash[:error] = 'Access denied. Admin role required.'
        redirect_to root_path
      end
    end
  end
end