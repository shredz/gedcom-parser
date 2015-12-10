class FileParser

  def initialize(file = nil)
    @data = read_data(file)
    @id_stack = Stack.new
    @tag_stack = Stack.new('GEDCOM')
    @xml = "<?xml version='1.0' encoding='utf-8' ?><GEDCOM>"
    @line = nil
  end

  def read_data(file)
    file_data = File.read(file)
    encoded_data = file_data.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    encoded_data.split("\r")
  end

  def to_xml
    @data.each_with_index do |line, i|
      next if /^\s*$/ === line
      @parsed_line = parse_line(line)
      if @id_stack.empty?
        push_to_stacks
        @xml += get_opening_tag(i)
      else
        if @id_stack.last_elem < depth
          @xml += get_opening_tag(i)
          push_to_stacks
        else
          if @id_stack.last_elem >= depth
            close_tags_for("@id_stack.last_elem && !(@id_stack.last_elem < depth)")
            @xml += get_opening_tag(i)
            push_to_stacks
          end
        end
      end
    end
    close_tags_for("@tag_stack.length > 0")
    @xml
  end

  def close_tags_for(condition)
    while eval(condition)
      closing_tag = @tag_stack.pop
      @id_stack.pop
      @xml += "</#{closing_tag}>"
    end
  end

  def get_opening_tag(i)
    is_inline_value?(i) ? "<#{tag}#{id_attr} value='#{value}'>" : "<#{tag}#{id_attr}>#{value}"
  end

  def push_to_stacks
    @id_stack.push(depth)
    @tag_stack.push(tag)
  end

  def parse_line(line)
    line.match(/(?<depth>\d)\s((?<id>@.*@)\s*)?(?<tag>[A-z0-9]{3,4})\s*(?<value>.*)/)
  end

  def depth
    @parsed_line[:depth].to_i
  end

  def tag
    @parsed_line[:tag]
  end

  def value
    val = @parsed_line[:value]
    clean_value(val)
  end

  def clean_value(val)
    {"&" => "&amp;", "\"" => "&quot;", "'" => "&apos;", "<" => "&lt;", ">" =>  "&gt;"}.each do |attri, replacement|
      val.gsub!(attri, replacement)
    end
    val
  end

  def id
    @parsed_line[:id]
  end

  def id_attr
    id ? " id='#{id}'" : ''
  end

  def is_inline_value?(i)
    next_line = @data[i + 1]
    next_depth, inner_value = nil, false
    if next_line
      parsed_line = parse_line(next_line)
      next_depth = parsed_line[:depth].to_i
      inner_value = true if !value.nil? && value != '' && next_depth > depth
    end
    inner_value
  end

end
