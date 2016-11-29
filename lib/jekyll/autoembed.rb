require 'jekyll/autoembed/version'
require 'nokogiri'

module Jekyll
  module Autoembed
    def self.execute(doc)
      parsed_doc = Nokogiri::HTML::DocumentFragment.parse(doc.output)
      parsed_doc.search('.//text()').each do |node|
        content = node.to_html
        html = autoembed(content)
        next if html == content
        node.replace(html)
      end
      doc.output = parsed_doc.to_html
      doc
    end

    def self.autoembed(content)
      # TODO: replace this with more flexible stacked
      # autoembed processors (this first one being a Gist processor)
      # once another autoembed requirement comes up
      return content unless content.include?('gist.github.com')
      content.gsub(
        %r{(https?://gist\.github\.com/[a-zA-Z0-9/]+)},
        '<script src="\1.js"></script>'
      )
    end
  end
end

if Object.const_defined?('Jekyll::Hooks')
  Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
    Jekyll::Autoembed.execute(doc)
  end
end
