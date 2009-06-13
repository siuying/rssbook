require "test/unit"
require "../lib/rssbook.rb"

class RssTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
  end

  # Fake test

  def test_render
    # need a font file at root dir
    renderer = RSSBook::Renderer.new "feeds/feed1.xml", "feeds/feed1.pdf", "../wt011.ttf"
    renderer.render
  end


  def test_render_html
    # need a font file at root dir
    renderer = RSSBook::Renderer.new "feeds/feed2.xml", "feeds/feed2.pdf", "../wt011.ttf"
    renderer.render
  end
end