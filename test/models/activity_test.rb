require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:targetable)
end
