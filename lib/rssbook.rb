$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "prawn"
require 'iconv'
require 'logger'
require 'feed-normalizer'
require 'open-uri'
require 'hpricot'
require "prawn/measurement_extensions"
require 'prawn/format'

module RSSBook
  VERSION = '0.2.1'

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

        render_toc(doc)
        
        count = 1
        @items.each do |item|
          title = item.title
          desc  = item.content
          link_id = "link_#{count}"
          render_item(doc, title, desc, link_id)
          doc.start_new_page unless item == @items.last
          count += 1
        end
      end
      puts "end document"
    end

    private
    def render_toc(doc)

      # TITLE      
      doc.text_options.update(:wrap => :character, :size => 32, :spacing => 4)
      doc.tags :p => {:font_size => "1em", :color => "black"}
      doc.styles :toc => {:font_size => "1.5em", :color => "black", :text_decoration => :underline},
              :title => {:font_size => "3em"}, :details => {:kerning => true}

      doc.pad_bottom(10) do
        doc.text "<a name='title' class='toc title'></a>"
        doc.text @feed.title
      end

      # TOC
      doc.text_options.update(:wrap => :character, :size => 26, :spacing => 4)
      count = 1
      @items.each do |item|
        title = item.title
        doc.pad_bottom(5) do
          doc.text "<p>#{count}</p><a href='#link_#{count}' class='toc'>#{title}</a>"
        end

        count += 1
      end

      doc.start_new_page
    end
    
    def render_item(doc, title, description, link_id)
      puts "render: #{title}"

      doc.pad_bottom(30) do
        doc.text_options.update(:wrap => :character, :size => 26, :spacing => 4)
        doc.text "<a name='#{link_id}'/>"
        doc.text title
      end

      doc.text_options.update(:wrap => :character, :size => 20, :spacing => 4)
      description = Hpricot(description).inner_text
      description.split(/[\n\r][\n\r]?/).each do |d|
        doc.pad_bottom(15) do
          doc.text d
        end
      end

      doc.text "<a href='#title' class='toc'>&lt;&lt;</a>"
    end
  end
end
