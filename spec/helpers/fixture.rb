# frozen_string_literal: true

module Helpers
  def fixture(file)
    File.join(__dir__, '..', 'fixture', file)
  end
end
