# -*- coding: utf-8 -*-
#
# Various methods for cleaning HTML
#

require 'sanitize'

module Cleaner
  class << self

    # Remove whitespace
    def strip(s)
      s.gsub(/[\n\r\t\u00A0+]|\s\s+/, ' ').strip #u00A0 = non-breaking space
    end

    # Remove HTML from a string, along with URLs and extra space
    def clean_html(s)
      strip(strip_url(Sanitize.clean(s)))
    end

    # Remove URLs from text
    #
    # Regexp from http://daringfireball.net/2010/07/improved_regex_for_matching_urls
    def strip_url(s)
      pat = %r{(?i)\b((?:https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}
      s.gsub(pat, '')
    end
  end
end

if $0 == __FILE__
  require 'minitest/autorun'

  class TestCleaner < MiniTest::Unit::TestCase
    def test_clean_html
      html = '<a href="http://example.com">foo</a>   bar <b>baz</b>'
      assert_equal "foo bar baz", Cleaner.clean_html(html)
    end

    def test_strip_url
      assert_equal '', Cleaner.strip_url('http://example.com')
    end
  end
end
