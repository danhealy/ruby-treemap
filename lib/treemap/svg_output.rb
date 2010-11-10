#
# svg_output.rb - RubyTreemap
#
# Copyright (c) 2006 by Andrew Bruno <aeb@qnot.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
#

require 'cgi'
require 'RMagick'

require File.dirname(__FILE__) + "/output_base"

class Treemap::SvgOutput < Treemap::OutputBase

    def initialize
        super

        yield self if block_given?
    end

    def node_label(node)
        CGI.escapeHTML(node.label)
    end
    
    def node_meta(node)
      node.meta
    end
    
    def node_link(node)
      CGI.escapeHTML(node.link)
    end
    
    def draw_node_body(node)
        draw_label(node)
    end

    def draw_label(node)
        # center label in box
        label = ""
        label += "<text style=\"text-anchor: middle\" font-size=\"15\""
        label += " x=\"" + (node.bounds.x1 + node.bounds.width / 2).to_s + "\""
        label += " y=\"" + (node.bounds.y1 + node.bounds.height / 2).to_s + "\">"
        label += node_label(node)
        label += "</text>\n"
        
        label
    end
	
    def node_color(node)
        color = "#CCCCCC"

        if(!node.color.nil?)
            if(not Numeric === node.color)
                color = node.color
            else
                color = "#" + @color.get_hex_color(node.color)
            end
        end

        color
    end

    def to_png(node, filename="treemap.png")
        svg = to_svg(node)
        img = Magick::Image.from_blob(svg) { self.format = "SVG" }
        img[0].write(filename)
    end

    def to_svg(node)
        bounds = self.bounds

        @layout.process(node, bounds)

        draw_map(node)
    end

    def draw_map(node)
        svg = "<svg"
        svg += " xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\""
        svg += " xmlns:ev=\"http://www.w3.org/2001/xml-events\"" 
        svg += " width=\"" + (node.bounds.width).to_s + "\" height=\"" + (node.bounds.height).to_s + "\">"

        svg += draw_node(node)
        svg += "</svg>"
        svg
    end

    def draw_node(node)
        return "" if node.bounds.nil?

        svg = ""
        svg += "<rect"
        svg += " id=\"rect-" + node.id.to_s + "\""
        svg += " x=\"" + node.bounds.x1.to_s + "\""
        svg += " y=\"" + node.bounds.y1.to_s + "\""
        svg += " width=\"" + node.bounds.width.to_s + "\""
        svg += " height=\"" + node.bounds.height.to_s + "\""
        #svg += " style=\""
        #svg += " fill: " + node_color(node) + ";"
        #svg += " stroke: #000000;"
        #svg += " stroke-width: 1px;"
        svg += " fill=\"" + node_color(node) + "\""
        svg += " stroke=\"#000000\""
        svg += " stroke-width=\"1px\""
        svg += " />\n"

        svg += draw_node_body(node)
		
        if(!node.children.nil? and node.children.size > 0)
            node.children.each do |c|
                svg += draw_node(c)
            end
        end

        svg
    end
    
    def to_css(node)
        bounds = self.bounds
    
        @layout.process(node, bounds)
    
        draw_map_css(node)
    end
    
    def draw_map_css(node)
        css = "<html><head><link href=\"/stylesheets/app.css\" media=\"all\" rel=\"stylesheet\" type=\"text/css\" /><script language='javascript' src='/javascripts/mootools-1.2-core-yc.js'></script><script language='javascript' src='/javascripts/mootools-1.2-more.js'></script><script language='javascript' src='/javascripts/my_tooltips.js'></script></head>\n<body>"
        css += "<div id=\"map\" style=\"position:absolute; top:0px; left:0px; width:" + (node.bounds.width).to_s + "; height:" + (node.bounds.height).to_s + ";\">\n"
        css += draw_node_css(node)
        css += "</div>"
        css
    end
    
    def draw_node_css(node)
        return "" if node.bounds.nil?
    
        css = ""
        css += "<div"
        css += " class=\"RegTips\""
        css += " id=\"rect-" + node.id.to_s + "\""
        css += " style=\"position:absolute;"
        css += " left:" + node.bounds.x1.to_s + "px;"
        css += " top:" + node.bounds.y1.to_s + "px;"
        css += " width:" + node.bounds.width.to_s + "px;"
        css += " height:" + node.bounds.height.to_s + "px;"
        
        css += " background-color:" + node_color(node) + ";"
        css += " border:1px solid black;"
        css += " color:white;"
        css += "\""
        css += " >\n"
    
        css += draw_node_body_css(node)
        css += "</div>\n"
    
        if(!node.children.nil? and node.children.size > 0)
            node.children.each do |c|
                css += draw_node_css(c)
            end
        end
    
        css
    end
    
    
    def draw_node_body_css(node)
        draw_label_css(node)
    end
    
    def draw_label_css(node)
        # center label in box
        narea = 1.0 + (node.bounds.width * node.bounds.height)
        totarea = 800.0 * 600.0
        
        fsize = 12 + (72*(narea/totarea)).to_i
        label = ""
        label += "<p style=\"text-align: center; font-size:#{fsize}px; margin:#{(node.bounds.height-fsize)/2}px 0px\">"
        #label += " x=\"" + (node.bounds.x1 + node.bounds.width / 2).to_s + "\""
        #label += " y=\"" + (node.bounds.y1 + node.bounds.height / 2).to_s + "\">"
        unless node_link(node).nil?
          label += "<a href=\"/history_graph/" + node_link(node) + "\" target=\"_parent\">"
          label += node_label(node)
          label += "</a>"
        end
        label += "</p>\n"
        
        label += "<span id=\"meta\" style=\"display:none;\">"
        unless node_meta(node).nil?
          label += node_meta(node)
        end
        label += "</span>\n"
        
        label
    end
    
end
