# frozen_string_literal: true

class Note
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :title, type: String
  field :body, type: String
  belongs_to :user
  before_validation :ensure_title_has_a_value
  validates :title, length: { maximum: (MAX_TITLE_LENGTH = 30), message: 'Must be less   than 30 characters' },
                    presence: true
  validates :body, length: { maximum: (MAX_BODY_LENGTH     = 1000), message: 'Must be less   than 1000 characters' }

  private

  def ensure_title_has_a_value
    return if title.present?

    self.title = body[0..(MAX_TITLE_LENGTH - 1)] if body.present?
  end

  # jinda end
end
