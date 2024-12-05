# frozen_string_literal: true

require 'concurrent'

# Model dealing with one grid
class Gridsquare < ApplicationRecord
  belongs_to :world
  validates :row, presence: true
  validates :col, presence: true
  has_one_attached :image

  def generate_image(row, col)
    Concurrent::Future.execute { OpenaiWrapperHelper.create_square(row, col, self) }
    # add it to the queue
    # have active job pull off 5 gridsquares from the table every min and generate
  end
end
