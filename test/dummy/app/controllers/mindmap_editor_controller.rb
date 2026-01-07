# frozen_string_literal: true

class MindmapEditorController < ApplicationController
  before_action :require_admin

  def edit
    mindmap_path = Rails.root.join('app/jinda/index.mm')
    
    if File.exist?(mindmap_path)
      xml_content = File.read(mindmap_path)
      @mind_data = MindmapConverter.xml_to_jsmind(xml_content)
    else
      @mind_data = MindmapConverter.send(:default_mindmap)
      flash.now[:warning] = 'Mindmap file not found. Showing default template.'
    end
  end

  def save
    json_data = params[:mind_data]
    
    if json_data.blank?
      render json: { success: false, error: 'No data received' }, status: :bad_request
      return
    end

    begin
      # Convert JSON to XML
      xml_content = MindmapConverter.jsmind_to_xml(json_data)
      
      # Backup current file
      mindmap_path = Rails.root.join('app/jinda/index.mm')
      if File.exist?(mindmap_path)
        backup_path = Rails.root.join("app/jinda/index.mm.backup.#{Time.now.to_i}")
        FileUtils.cp(mindmap_path, backup_path)
      end
      
      # Save new file
      File.write(mindmap_path, xml_content)
      
      # Run rake jinda:update
      output = `cd #{Rails.root} && rake jinda:update 2>&1`
      
      render json: { 
        success: true, 
        message: 'Mindmap saved and updated successfully',
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
