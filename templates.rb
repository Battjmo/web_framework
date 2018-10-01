require 'pp'

class Templates 
    class Template
        def initialize(source)
            @source = source
        end  


        def render(params)
           lines = @source.split("\n")
           nodes = lines.map { |line| build_node(line) } 
           tree = build_tree(nodes)
           tree.render(params)
        end

        def build_node(line)
            indentation, line = /^( *)(.*)$/.match(line).captures
            indent = indentation.length / 2
            case line[0, 2]
            when "| "
                TextNode.new(indent, line[2..-1])
            when "= "
                CodeNode.new(indent, line[2..-1])
            else 
                TagNode.new(indent, line, [])
        end 
    end 

    def build_tree(nodes)
        root = nodes.shift
        depth_map = { 0 => root}

        nodes.each do |node|
            parent = depth_map.fetch(node.indent - 2)
            parent.children << node 
            depth_map[node.indent] = node
        end 
        root

    end
end 

    class TextNode < Struct.new(:indent, :text)
        def render(params)
            " " * (indent * 2) + text
        end
    end 

    class CodeNode < Struct.new(:indent, :code)
        def render(params)
            " " * (indent * 2) + eval(code).to_s
        end 
    end 
    
    class TagNode < Struct.new(:indent, :tag_name, :children)
        def render(params)
            [
               " " * (indent * 2) + "<#{tag_name}>",
                children.map { |child| child.render(params) },
               " " * (indent * 2) + "</#{tag_name}>",
            ].flatten.join("\n")
        end 
    end
end 