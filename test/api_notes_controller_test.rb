# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'

# Test suite for API Notes Controller
#
# This test verifies that the API endpoints:
# - Filter notes based on authenticated user
# - Properly handle user_id in queries
# - Have appropriate authentication checks
#
# Usage:
#   ruby test/api_notes_controller_test.rb
#
class ApiNotesControllerTest < Minitest::Test
  JINDA_ROOT = File.expand_path('..', __dir__)
  API_CONTROLLER_PATH = File.join(
    JINDA_ROOT,
    'lib/generators/jinda/templates/app/controllers/api/v1/notes_controller.rb'
  )
  JINDA_CONTROLLER_PATH = File.join(
    JINDA_ROOT,
    'lib/generators/jinda/templates/app/controllers/jinda_org/notes_controller.rb'
  )

  def test_01_api_controller_exists
    assert File.exist?(API_CONTROLLER_PATH),
           'API notes controller template should exist'
  end

  def test_02_api_controller_in_correct_namespace
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'module Api',
                    'Controller should be in Api module'
    assert_includes content, 'module V1',
                    'Controller should be in V1 module'
    assert_includes content, 'class NotesController < ApplicationController',
                    'Should define NotesController'
  end

  def test_03_api_has_index_action
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'def index',
                    'API controller should have index action'
  end

  def test_04_api_index_returns_all_notes
    content = File.read(API_CONTROLLER_PATH)

    # Extract index method
    index_method = content[/def index.*?^  end/m]

    assert_includes index_method, '@notes = Note',
                    'Index should query Note model'
    assert_includes index_method, 'render json: @notes',
                    'Index should render JSON'
  end

  def test_05_api_has_my_action
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'def my',
                    'API controller should have my action'
  end

  def test_06_api_my_filters_by_current_user
    content = File.read(API_CONTROLLER_PATH)

    # Extract my method
    my_method = content[/def my.*?^  end/m]

    assert_includes my_method, 'Note.where(user_id: current_ma_user)',
                    'My action should filter notes by current user'
    assert_includes my_method, 'render json: @notes',
                    'My action should render JSON'
  end

  def test_07_api_my_uses_correct_user_identifier
    content = File.read(API_CONTROLLER_PATH)

    my_method = content[/def my.*?^  end/m]

    assert_includes my_method, 'current_ma_user',
                    'Should use current_ma_user to identify user'
  end

  def test_08_api_has_show_action
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'def show',
                    'API controller should have show action'
  end

  def test_09_api_has_create_action
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'def create',
                    'API controller should have create action'
  end

  def test_10_api_create_includes_user_id
    content = File.read(API_CONTROLLER_PATH)

    create_method = content[/def create.*?^  end/m]

    assert_includes create_method, 'user_id:',
                    'Create action should set user_id'
    assert_includes create_method, 'params[:user]',
                    'Create should accept user parameter'
  end

  def test_11_api_create_renders_json_response
    content = File.read(API_CONTROLLER_PATH)

    create_method = content[/def create.*?^  end/m]

    assert_includes create_method, 'render json:',
                    'Create should render JSON response'
    assert_includes create_method, 'status: :created',
                    'Create should return 201 status'
  end

  def test_12_api_has_destroy_action
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'def destroy',
                    'API controller should have destroy action'
  end

  def test_13_api_destroy_checks_permissions
    content = File.read(API_CONTROLLER_PATH)

    destroy_method = content[/def destroy.*?^  end/m]

    assert_includes destroy_method, 'current_ma_user',
                    'Destroy should check current user'
    # Should check if user is admin or note owner
    assert_match(/role.*A|current_ma_user == @note\.user/m, destroy_method,
                 'Destroy should verify user is admin or owner')
  end

  def test_14_api_has_before_action_filters
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'before_action :load_note',
                    'Should have before_action to load note'
  end

  def test_15_api_load_note_uses_params_id
    content = File.read(API_CONTROLLER_PATH)

    load_note_method = content[/def load_note.*?^  end/m]

    assert_includes load_note_method, 'Note.find(params[:id])',
                    'load_note should find note by params[:id]'
  end

  def test_16_jinda_controller_my_action_filters_by_user
    content = File.read(JINDA_CONTROLLER_PATH)

    my_method = content[/def my.*?^  end/m]

    assert_includes my_method, 'Note.where(user_id: current_ma_user)',
                    'Jinda controller my action should also filter by user'
  end

  def test_17_api_supports_pagination
    content = File.read(API_CONTROLLER_PATH)

    # Check if pagination is used
    assert_includes content, '.page(params[:page])',
                    'Should support pagination with page parameter'
    assert_includes content, '.per(10)',
                    'Should limit results per page'
  end

  def test_18_api_my_action_sorts_by_created_at
    content = File.read(API_CONTROLLER_PATH)

    my_method = content[/def my.*?^  end/m]

    assert_includes my_method, 'desc(:created_at)',
                    'My action should sort by created_at descending'
  end

  def test_19_api_index_sorts_notes
    content = File.read(API_CONTROLLER_PATH)

    index_method = content[/def index.*?^  end/m]

    assert_includes index_method, 'desc(:created_at)',
                    'Index should sort notes by created_at'
  end

  def test_20_api_controller_inherits_from_application_controller
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'class NotesController < ApplicationController',
                    'Should inherit from ApplicationController for authentication'
  end

  def test_21_api_create_saves_note
    content = File.read(API_CONTROLLER_PATH)

    create_method = content[/def create.*?^  end/m]

    assert_includes create_method, '@note.save!',
                    'Create should save the note'
  end

  def test_22_api_has_private_methods_section
    content = File.read(API_CONTROLLER_PATH)

    assert_includes content, 'private',
                    'Controller should have private methods section'
  end

  def test_23_controller_uses_consistent_user_filtering
    api_content = File.read(API_CONTROLLER_PATH)
    jinda_content = File.read(JINDA_CONTROLLER_PATH)

    # Both controllers should use same user filtering approach
    assert_includes api_content, 'user_id: current_ma_user',
                    'API controller should filter by current_ma_user'
    assert_includes jinda_content, 'user_id: current_ma_user',
                    'Jinda controller should filter by current_ma_user'
  end
end
