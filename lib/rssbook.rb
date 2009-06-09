$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "prawn"
require 'iconv'
require 'logger'
require 'hpricot'
require 'open-uri'
require "prawn/measurement_extensions"

module RSSBook
  VERSION = '0.1.3'

  class Renderer
    def initialize(input, output, font = "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf",
            options = {:page_size => "A4", :margin => 0.6.in, :compress => true})
      @input = input
      @output = output
      @font = font
      @options = options
      @log = Logger.new($STDOUT)
      
      puts "input: #{input}, output: #{output}"
      @feed = Hpricot.XML(open(input))
    end

    def render
      puts "start document"
      @items = (@feed/"//item")
      Prawn::Document.generate @output, @options do |doc|
        doc.font @font        
        puts "num of items: #{@items.size}"
        @items.each do |item|
          title = (item/"/title").inner_text
          desc  = (item/"/description").inner_text
          render_feed(doc, title, desc)
        end
      end
      puts "end document"
    end

    private
    def render_feed(doc, title, description)
      puts "render: #{title}"
      doc.bounding_box([doc.bounds.left, doc.bounds.top], :width => doc.bounds.width) do
        doc.pad_bottom(20) do
          doc.text_options.update(:wrap => :character, :size => 26, :spacing => 4)
          doc.text title
        end

        doc.text_options.update(:wrap => :character, :size => 20, :spacing => 4)
        description = Hpricot(description).inner_text
        description.split(/[\n\r][\n\r]?/).each do |d|
          doc.text d
        end

        doc.start_new_page
      end
    end
  end
end
