# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'

# Test suite for Note model RSpec tests
#
# This test verifies that the Note model spec template:
# - Tests Note creation with user association
# - Tests validation rules
# - Tests auto-fill behavior
#
# Usage:
#   ruby test/note_model_test.rb
#
class NoteModelTest < Minitest::Test
  JINDA_ROOT = File.expand_path('..', __dir__)
  NOTE_MODEL_PATH = File.join(JINDA_ROOT, 'lib/generators/jinda/templates/app/models/note.rb')
  NOTE_SPEC_PATH = File.join(JINDA_ROOT, 'lib/generators/jinda/templates/spec/models/note_spec.rb')

  def test_01_note_model_exists
    assert File.exist?(NOTE_MODEL_PATH),
           'Note model template should exist'
  end

  def test_02_note_spec_exists
    assert File.exist?(NOTE_SPEC_PATH),
           'Note spec template should exist'
  end

  def test_03_note_model_includes_mongoid
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'include Mongoid::Document',
                    'Note should include Mongoid::Document'
    assert_includes content, 'include Mongoid::Timestamps',
                    'Note should include timestamps'
  end

  def test_04_note_model_has_required_fields
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'field :title, type: String',
                    'Note should have title field'
    assert_includes content, 'field :body, type: String',
                    'Note should have body field'
  end

  def test_05_note_model_belongs_to_user
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'belongs_to :user',
                    'Note should belong to user'
  end

  def test_06_note_model_has_validations
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'validates :title',
                    'Note should validate title'
    assert_includes content, 'length: { maximum:',
                    'Title should have length validation'
    assert_includes content, 'presence: true',
                    'Title should be required'
  end

  def test_07_note_model_has_title_length_constant
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'MAX_TITLE_LENGTH = 30',
                    'Should define MAX_TITLE_LENGTH constant'
  end

  def test_08_note_model_has_body_length_constant
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'MAX_BODY_LENGTH',
                    'Should define MAX_BODY_LENGTH constant'
    assert_includes content, '1000',
                    'MAX_BODY_LENGTH should be 1000'
  end

  def test_09_note_model_has_before_validation_callback
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'before_validation :ensure_title_has_a_value',
                    'Note should have before_validation callback'
  end

  def test_10_note_model_has_ensure_title_method
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'def ensure_title_has_a_value',
                    'Note should have ensure_title_has_a_value method'
    assert_includes content, 'self.title = body[0..(MAX_TITLE_LENGTH - 1)]',
                    'Method should auto-fill title from body'
  end

  def test_11_spec_creates_admin_user
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'let!(:admin_user)',
                    'Spec should create admin_user'
    assert_includes content, "User.create",
                    'Should create User instance'
  end

  def test_12_spec_tests_note_with_title_and_body
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'valid with  both title and body',
                    'Spec should test valid note with title and body'
    assert_includes content, 'Note.create(title:',
                    'Should create note with title'
    assert_includes content, 'user: admin_user',
                    'Should associate note with user'
  end

  def test_13_spec_tests_note_with_only_title
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'valid with  only title',
                    'Spec should test note with only title'
  end

  def test_14_spec_tests_note_with_only_body
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'invalid with  only body',
                    'Spec should test invalid note with only body'
    assert_includes content, 'Note.new(body:',
                    'Should use Note.new for invalid case'
  end

  def test_15_spec_tests_body_length_validation
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'invalid body length more than 1000',
                    'Spec should test body length validation'
    assert_includes content, "'y' * 1001",
                    'Should test with 1001 characters'
  end

  def test_16_spec_tests_title_autofill_from_body
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'title data  blank',
                    'Spec should have section for blank title'
    assert_includes content, 'auto fill from body',
                    'Spec should test auto-fill behavior'
    assert_includes content, "title: ''",
                    'Should test with empty title'
    assert_includes content, "body: 'Body content'",
                    'Should provide body content'
  end

  def test_17_spec_verifies_title_equals_body
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, "note.title.should == 'Body content'",
                    'Spec should verify title equals body when auto-filled'
  end

  def test_18_spec_checks_note_count_changes
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'before_count = Note.count',
                    'Spec should track note count before creation'
    assert_includes content, 'expect(Note.count)',
                    'Spec should verify note count changes'
  end

  def test_19_note_model_validates_presence_when_user_present
    content = File.read(NOTE_MODEL_PATH)

    # Ensure validations are defined
    assert_match(/validates :title.*presence: true/m, content,
                 'Title should be validated for presence')
  end

  def test_20_spec_always_includes_user_in_tests
    content = File.read(NOTE_SPEC_PATH)

    # Count how many times Note.create or Note.new is called
    create_calls = content.scan(/Note\.create/).length
    new_calls = content.scan(/Note\.new/).length
    total_note_calls = create_calls + new_calls
    
    # Count how many times user parameter is passed
    user_params = content.scan(/user: admin_user/).length

    # All Note operations should include user (user: admin_user appears once per operation)
    assert_equal total_note_calls, user_params,
                 'All Note.create and Note.new calls should include user parameter'
  end

  def test_21_note_model_in_jinda_markers
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, '# jinda begin',
                    'Note model should have jinda begin marker'
    assert_includes content, '# jinda end',
                    'Note model should have jinda end marker'

    # Extract content between markers
    jinda_content = content[/# jinda begin(.*)# jinda end/m, 1]

    assert_includes jinda_content, 'belongs_to :user',
                    'User association should be in jinda markers'
    assert_includes jinda_content, 'validates :title',
                    'Validations should be in jinda markers'
  end

  def test_22_spec_uses_rspec_syntax
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, "require 'rails_helper'",
                    'Spec should require rails_helper'
    assert_includes content, 'RSpec.describe Note',
                    'Spec should use RSpec.describe'
    assert_includes content, 'type: :model',
                    'Spec should specify model type'
  end
end
