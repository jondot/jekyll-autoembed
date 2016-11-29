$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jekyll/autoembed'

require 'minitest/spec'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
if system("colordiff", __FILE__, __FILE__)
  MiniTest::Assertions.diff = 'colordiff -u'
end
require 'minitest/autorun'
