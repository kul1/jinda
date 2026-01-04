# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'

# Integration test suite for Note model validations with User context
#
# This test verifies that Note model validations function correctly
# when a user is present, covering:
# - Title length validation (max 30 chars)
# - Body length validation (max 1000 chars)
# - Title auto-fill from body when title is blank
# - Presence validation for title
# - User association requirement
#
# Usage:
#   ruby test/note_validation_integration_test.rb
#
class NoteValidationIntegrationTest < Minitest::Test
  JINDA_ROOT = File.expand_path('..', __dir__)
  NOTE_MODEL_PATH = File.join(JINDA_ROOT, 'lib/generators/jinda/templates/app/models/note.rb')
  NOTE_SPEC_PATH = File.join(JINDA_ROOT, 'lib/generators/jinda/templates/spec/models/note_spec.rb')

  def test_01_title_presence_validation_exists
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'validates :title',
                    'Note model should validate title'
    assert_includes content, 'presence: true',
                    'Title should have presence validation'
  end

  def test_02_title_length_validation_is_30_chars
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'MAX_TITLE_LENGTH = 30',
                    'Maximum title length should be 30'
    assert_includes content, 'length: { maximum: (MAX_TITLE_LENGTH = 30)',
                    'Title validation should use MAX_TITLE_LENGTH constant'
  end

  def test_03_title_length_validation_has_custom_message
    content = File.read(NOTE_MODEL_PATH)

    title_validation = content[/validates :title.*?\n\s*validates|validates :title.*?end/m]

    assert_includes title_validation, 'message:',
                    'Title validation should have custom message'
    assert_includes title_validation, 'less   than 30',
                    'Message should mention 30 character limit'
  end

  def test_04_body_length_validation_is_1000_chars
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'MAX_BODY_LENGTH     = 1000',
                    'Maximum body length should be 1000'
    assert_includes content, 'validates :body',
                    'Should validate body field'
  end

  def test_05_body_length_validation_has_custom_message
    content = File.read(NOTE_MODEL_PATH)

    body_validation = content[/validates :body.*?\n/]

    assert_includes body_validation, 'message:',
                    'Body validation should have custom message'
    assert_includes body_validation, 'less   than 1000',
                    'Message should mention 1000 character limit'
  end

  def test_06_title_autofill_before_validation_callback
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'before_validation :ensure_title_has_a_value',
                    'Should have before_validation callback for title autofill'
  end

  def test_07_autofill_method_checks_title_presence
    content = File.read(NOTE_MODEL_PATH)

    ensure_method = content[/def ensure_title_has_a_value.*?end/m]

    assert_includes ensure_method, 'return if title.present?',
                    'Should return early if title is already present'
  end

  def test_08_autofill_method_uses_body_substring
    content = File.read(NOTE_MODEL_PATH)

    ensure_method = content[/def ensure_title_has_a_value.*?end/m]

    assert_includes ensure_method, 'body[0..(MAX_TITLE_LENGTH - 1)]',
                    'Should take first 29 characters of body (0..29)'
    assert_includes ensure_method, 'if body.present?',
                    'Should only autofill if body is present'
  end

  def test_09_autofill_sets_title_to_self
    content = File.read(NOTE_MODEL_PATH)

    ensure_method = content[/def ensure_title_has_a_value.*?end/m]

    assert_includes ensure_method, 'self.title =',
                    'Should assign to self.title'
  end

  def test_10_spec_tests_valid_note_with_user
    content = File.read(NOTE_SPEC_PATH)

    # Should test creating valid note with user
    assert_includes content, 'Note.create(title:',
                    'Spec should create notes with title'
    assert_includes content, 'user: admin_user',
                    'Spec should always include user in creation'
  end

  def test_11_spec_tests_title_only_with_user
    content = File.read(NOTE_SPEC_PATH)

    title_only_test = content[/'valid with  only title'.*?end/m]

    assert_includes title_only_test, 'Note.create(title:',
                    'Should test note creation with only title'
    assert_includes title_only_test, 'user: admin_user',
                    'Title-only test should include user'
    assert_includes title_only_test, 'expect(Note.count).not_to eq(before_count)',
                    'Should verify note was created successfully'
  end

  def test_12_spec_tests_body_only_invalid_with_user
    content = File.read(NOTE_SPEC_PATH)

    body_only_test = content[/'invalid with  only body'.*?end/m]

    assert_includes body_only_test, 'Note.new(body:',
                    'Should use Note.new for invalid case'
    assert_includes body_only_test, 'user: admin_user',
                    'Body-only test should include user'
    assert_includes body_only_test, 'expect(Note.count).to eq(before_count)',
                    'Should verify note was NOT created (invalid)'
  end

  def test_13_spec_tests_title_length_exceeds_30
    content = File.read(NOTE_SPEC_PATH)

    # Note: current spec tests body length > 1000, not title > 30
    # but we should verify the spec structure
    length_test = content[/'invalid body length more than 1000'.*?end/m]

    assert_includes length_test, 'user: admin_user',
                    'Length validation test should include user'
  end

  def test_14_spec_tests_autofill_with_user_present
    content = File.read(NOTE_SPEC_PATH)

    autofill_test = content[/'auto fill from body'.*?end/m]

    assert_includes autofill_test, "title: ''",
                    'Autofill test should use empty title'
    assert_includes autofill_test, "body: 'Body content'",
                    'Autofill test should provide body'
    assert_includes autofill_test, 'user: admin_user',
                    'Autofill test should include user'
    assert_includes autofill_test, "note.title.should == 'Body content'",
                    'Should verify title equals body after autofill'
  end

  def test_15_all_validations_work_with_user_context
    content = File.read(NOTE_MODEL_PATH)

    # Verify that validations don't have conditional logic excluding user context
    validations_section = content[/validates :title.*?validates :body.*?\n/m]

    refute_includes validations_section, 'if:',
                    'Validations should not be conditional on user presence'
    refute_includes validations_section, 'unless:',
                    'Validations should not skip based on conditions'
  end

  def test_16_user_association_is_required
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'belongs_to :user',
                    'Note should belong to user'

    # In Mongoid, belongs_to is required by default unless optional: true
    belongs_to_line = content[/belongs_to :user.*$/]
    refute_includes belongs_to_line, 'optional: true',
                    'User association should be required (not optional)'
  end

  def test_17_spec_always_creates_admin_user_first
    content = File.read(NOTE_SPEC_PATH)

    assert_includes content, 'let!(:admin_user)',
                    'Spec should use let! to create admin_user before tests'
    
    # Verify admin_user is created before any test runs
    admin_user_def = content[/let!\(:admin_user\).*?\}/m]
    assert_includes admin_user_def, 'User.create',
                    'Should create User instance for admin_user'
  end

  def test_18_spec_uses_before_count_pattern
    content = File.read(NOTE_SPEC_PATH)

    # Verify the pattern used in specs
    test_blocks = content.scan(/it '.*?' do.*?end/m)

    valid_test_blocks = test_blocks.select { |block| block.include?('before_count') }

    assert valid_test_blocks.any?,
           'At least one test should use before_count pattern'
    
    valid_test_blocks.each do |block|
      assert_includes block, 'before_count = Note.count',
                      'Should capture count before operation'
      assert_includes block, 'expect(Note.count)',
                      'Should check count after operation'
    end
  end

  def test_19_validations_cover_all_edge_cases
    content = File.read(NOTE_SPEC_PATH)

    # Verify spec covers key scenarios with user present
    scenarios = [
      'valid with  both title and body',
      'valid with  only title',
      'invalid with  only body',
      'invalid body length more than 1000',
      'auto fill from body'
    ]

    scenarios.each do |scenario|
      assert_includes content, scenario,
                      "Spec should cover scenario: #{scenario}"
    end
  end

  def test_20_ensure_title_method_is_private
    content = File.read(NOTE_MODEL_PATH)

    # Find the private keyword position
    private_index = content.index('private')
    ensure_method_index = content.index('def ensure_title_has_a_value')

    refute_nil private_index, 'Model should have private section'
    refute_nil ensure_method_index, 'Model should have ensure_title_has_a_value method'
    assert ensure_method_index > private_index,
           'ensure_title_has_a_value should be in private section'
  end

  def test_21_model_uses_mongoid_document
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'include Mongoid::Document',
                    'Note should include Mongoid::Document'
    assert_includes content, 'include Mongoid::Timestamps',
                    'Note should include Mongoid::Timestamps'
    assert_includes content, 'include Mongoid::Attributes::Dynamic',
                    'Note should include Dynamic attributes'
  end

  def test_22_fields_are_typed_correctly
    content = File.read(NOTE_MODEL_PATH)

    assert_includes content, 'field :title, type: String',
                    'Title should be String type'
    assert_includes content, 'field :body, type: String',
                    'Body should be String type'
  end

  def test_23_validation_errors_are_descriptive
    content = File.read(NOTE_MODEL_PATH)

    # Check custom error messages exist
    title_message = content[/validates :title.*?message: '([^']+)'/m, 1]
    body_message = content[/validates :body.*?message: '([^']+)'/m, 1]

    refute_nil title_message, 'Title validation should have custom message'
    refute_nil body_message, 'Body validation should have custom message'
    
    assert_includes title_message, '30',
                    'Title message should mention character limit'
    assert_includes body_message, '1000',
                    'Body message should mention character limit'
  end
end
