require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
	should belong_to(:user)
end
