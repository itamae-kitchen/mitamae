class TestItamae < MTest::Unit::TestCase
  def test_main_is_callable
    assert_nil __main__(['bin/itamae', 'version'])
  end
end

MTest::Unit.new.run
