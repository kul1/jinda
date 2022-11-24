# encoding: utf-8
  #
  # Mongoid 6 follows the new pattern of AR5 requiring a belongs_to relation to always require its parent
  # belongs_to` will now trigger a validation error by default if the association is not present.
  # You can turn this off on a per-association basis with `optional: true`.
  # (Note this new default only applies to new Rails apps that will be generated with
  # `config.active_record.belongs_to_required_by_default = true` in initializer.)
  #
  Mongoid::Config.belongs_to_required_by_default = false
          
