$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "prawn"
require 'iconv'
require 'logger'
require 'feed-normalizer'
require 'open-uri'
require "prawn/measurement_extensions"

module RSSBook
  VERSION = '0.1.5'

  class Renderer
    def initialize(input, output, font = "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf",
            options = {:page_size => "A4", :margin => 0.6.in, :compress => true})
      @input = input
      @output = output
      @font = font
      @options = options
      @log = Logger.new($STDOUT)
      
      puts "input: #{input}, output: #{output}"

      @feed = FeedNormalizer::FeedNormalizer.parse open(input)
    end

    def render
      puts "start document"
      @items = @feed.entries
      Prawn::Document.generate @output, @options do |doc|
        doc.font @font        
        puts "num of items: #{@items.size}"
        @items.each do |item|
          title = item.title
          desc  = item.content
          render_feed(doc, title, desc)
        end
      end
      puts "end document"
    end

    private
    def render_feed(doc, title, description)
      puts "render: #{title}"
      doc.bounding_box([doc.bounds.left, doc.bounds.top], :width => doc.bounds.width) do
        doc.pad_bottom(30) do
          doc.text_options.update(:wrap => :character, :size => 26, :spacing => 4)
          doc.text title
        end
      
        doc.text_options.update(:wrap => :character, :size => 20, :spacing => 4)
        description = Hpricot(description).inner_text
        description.split(/[\n\r][\n\r]?/).each do |d|
          doc.pad_bottom(15) do
            doc.text d
          end
        end

        doc.start_new_page
      end
    end
  end
end
