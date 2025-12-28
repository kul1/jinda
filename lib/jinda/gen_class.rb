# frozen_string_literal: true

# Add method to ruby class String
# ###############################
class String
  def comment?
    self[0] == "#"
    # self[0]==35 # check if first char is #
  end

  def to_code
    s = dup
    s.downcase.strip.tr(" ", "_").gsub(%r{[^#_/a-zA-Z0-9]}, "")
  end
end
