# frozen_string_literal: true

# the abstract class for active record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
