$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "prawn"
require "palm"
require 'iconv'
require 'UniversalDetector' # chardet gem
require 'logger'
require 'hpricot'

require "prawn/measurement_extensions"

module RSSBook
  class Renderer
    def initialize(input, output, font = "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf", options = {:page_size => "A4", :margin => 0.6.in, :compress => true})
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
          title = item/"/title"
          desc  = item/"/description"
          render_feed(doc, title.text, desc.text)
        end
      end
      puts "end document"
    end

    protected
    # find current document charset
    def charset
      text_check = @pdb.data.first.data.gsub("\e", "")
      enc = UniversalDetector::chardet(text_check)["encoding"]
    end

    private
    def render_feed(doc, title, description)
      puts "render: #{title}"
      doc.bounding_box([doc.bounds.left, doc.bounds.top], :width => doc.bounds.width) do
        doc.text_options.update(:wrap => :character, :size => 26, :spacing => 4)
        doc.text title
        
        doc.text_options.update(:wrap => :character, :size => 20, :spacing => 4)
        doc.text description
        doc.start_new_page
      end
    end
  end
end

renderer = RSSBook::Renderer.new ARGV[0], "#{ARGV[0]}.pdf"
renderer.render