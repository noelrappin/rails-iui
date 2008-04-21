require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/iui_helper"

class IuiHelperTest < Test::Unit::TestCase
  include IuiHelper
  
  def test_case_name
    true
  end
end
