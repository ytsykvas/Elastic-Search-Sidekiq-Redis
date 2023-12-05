#!/usr/bin/env ruby
# frozen_string_literal: true

# gendoc.rb -- Converts the top-comments inside module.c to modules API
#              reference documentation in markdown format.

# Convert the C comment to markdown
def markdown(s)
  s = s.gsub(%r{\*/$}, '')
  s = s.gsub(/^ ?\* ?/, '')
  s = s.gsub(%r{^/\*\*? ?}, '')
  s.chop! while s[-1] == "\n" || s[-1] == ' '
  lines = s.split("\n")
  newlines = []
  # Fix some markdown
  lines.each do |l|
    # Rewrite RM_Xyz() to RedisModule_Xyz().
    l = l.gsub(/(?<![A-Z_])RM_(?=[A-Z])/, 'RedisModule_')
    # Fix more markdown, except in code blocks indented by 4 spaces, which we
    # don't want to mess with.
    unless l.start_with?('    ')
      # Add backquotes around RedisModule functions and type where missing.
      l = l.gsub(/(?<!`)RedisModule[A-z]+(?:\*?\(\))?/) { |x| "`#{x}`" }
      # Add backquotes around c functions like malloc() where missing.
      l = l.gsub(/(?<![`A-z.])[a-z_]+\(\)/, '`\0`')
      # Add backquotes around macro and var names containing underscores.
      l = l.gsub(/(?<![`A-z*])[A-Za-z]+_[A-Za-z0-9_]+/) { |x| "`#{x}`" }
      # Link URLs preceded by space or newline (not already linked)
      l = l.gsub(%r{(^| )(https?://[A-Za-z0-9_/.-]+[A-Za-z0-9/])},
                 '\1[\2](\2)')
      # Replace double-dash with unicode ndash
      l = l.gsub(/ -- /, ' – ')
    end
    # Link function names to their definition within the page
    l = l.gsub(/`(RedisModule_[A-z0-9]+)[()]*`/) do |x|
      $index[Regexp.last_match(1)] ? "[#{x}](\##{Regexp.last_match(1)})" : x
    end
    newlines << l
  end
  newlines.join("\n")
end

# Linebreak a prototype longer than 80 characters on the commas, but only
# between balanced parentheses so that we don't linebreak args which are
# function pointers, and then aligning each arg under each other.
def linebreak_proto(proto, indent)
  return proto if proto.bytesize <= 80

  parts = proto.split(/,\s*/)
  return proto if parts.length == 1

  align_pos = proto.index('(') + 1
  align = ' ' * align_pos
  result = parts.shift
  bracket_balance = 0
  parts.each  do |part|
    result += if bracket_balance.zero?
                ",\n#{indent}#{align}"
              else
                ', '
              end
    result += part
    bracket_balance += part.count('(') - part.count(')')
  end
  result
end

# Given the source code array and the index at which an exported symbol was
# detected, extracts and outputs the documentation.
def docufy(src, i)
  m = /RM_[A-z0-9]+/.match(src[i])
  name = m[0]
  name = name.sub('RM_', 'RedisModule_')
  proto = "#{src[i].sub('{', '').strip};\n"
  proto = proto.sub('RM_', 'RedisModule_')
  proto = linebreak_proto(proto, '    ')
  # Add a link target with the function name. (We don't trust the exact id of
  # the generated one, which depends on the Markdown implementation.)
  puts "<span id=\"#{name}\"></span>\n\n"
  puts "### `#{name}`\n\n"
  puts "    #{proto}\n"
  puts "**Available since:** #{$since[name] or 'unreleased'}\n\n"
  comment = ''
  loop do
    i -= 1
    comment = src[i] + comment
    break if src[i] =~ %r{/\*}
  end
  comment = markdown(comment)
  puts "#{comment}\n\n"
end

# Print a comment from line until */ is found, as markdown.
def section_doc(src, i)
  name = get_section_heading(src, i)
  comment = "<span id=\"#{section_name_to_id(name)}\"></span>\n\n"
  loop do
    # append line, except if it's a horizontal divider
    comment += src[i] if src[i] !~ %r{^[/ ]?\*{1,2} ?-{50,}}
    break if src[i] =~ %r{\*/}

    i += 1
  end
  comment = markdown(comment)
  puts "#{comment}\n\n"
end

# generates an id suitable for links within the page
def section_name_to_id(name)
  "section-#{name.strip.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-+|-+$/, '')}"
end

# Returns the name of the first section heading in the comment block for which
# is_section_doc(src, i) is true
def get_section_heading(src, i)
  if src[i] =~ %r{^/\*\*? \#+ *(.*)}
    heading = Regexp.last_match(1)
  elsif src[i + 1] =~ /^ ?\* \#+ *(.*)/
    heading = Regexp.last_match(1)
  end
  heading.gsub(' -- ', ' – ')
end

# Returns true if the line is the start of a generic documentation section. Such
# section must start with the # symbol, i.e. a markdown heading, on the first or
# the second line.
def is_section_doc(src, i)
  src[i] =~ %r{^/\*\*? \#} ||
    (src[i] =~ %r{^/\*} && src[i + 1] =~ /^ ?\* \#/)
end

def is_func_line(src, i)
  line = src[i]
  line =~ /RM_/ &&
    line[0] != ' ' && line[0] != '#' && line[0] != '/' &&
    src[i - 1] =~ %r{\*/}
end

puts "---\n"
puts "title: \"Modules API reference\"\n"
puts "linkTitle: \"API reference\"\n"
puts "weight: 1\n"
puts "description: >\n"
puts "    Reference for the Redis Modules API\n"
puts "aliases:\n"
puts "    - /topics/modules-api-ref\n"
puts "---\n"
puts "\n"
puts "<!-- This file is generated from module.c using\n"
puts "     utils/generate-module-api-doc.rb -->\n\n"
src = File.open(File.dirname(__FILE__) + + '/../src/module.c').to_a

# Build function index
$index = {}
src.each_with_index do |line, i|
  next unless is_func_line(src, i)

  line =~ /RM_([A-z0-9]+)/
  name = "RedisModule_#{Regexp.last_match(1)}"
  $index[name] = true
end

# Populate the 'since' map (name => version) if we're in a git repo.
$since = {}
git_dir = File.dirname(__FILE__) + + '/../.git'
if File.directory?(git_dir) && `which git` != ''
  `git --git-dir="#{git_dir}" tag --sort=v:refname`.each_line do |version|
    next if version !~ /^(\d+)\.\d+\.\d+?$/ || Regexp.last_match(1).to_i < 4

    version.chomp!
    `git --git-dir="#{git_dir}" cat-file blob "#{version}:src/module.c"`.each_line do |line|
      next unless line =~ /^\w.*[ *]RM_([A-z0-9]+)/

      name = "RedisModule_#{Regexp.last_match(1)}"
      $since[name] = version unless $since[name]
    end
  end
end

# Print TOC
puts "## Sections\n\n"
src.each_with_index do |_line, i|
  if is_section_doc(src, i)
    name = get_section_heading(src, i)
    puts "* [#{name}](\##{section_name_to_id(name)})\n"
  end
end
puts "* [Function index](#section-function-index)\n\n"

# Docufy: Print function prototype and markdown docs
src.each_with_index do |_line, i|
  if is_func_line(src, i)
    docufy(src, i)
  elsif is_section_doc(src, i)
    section_doc(src, i)
  end
end

# Print function index
puts "<span id=\"section-function-index\"></span>\n\n"
puts "## Function index\n\n"
$index.keys.sort.each { |x| puts "* [`#{x}`](\##{x})\n" }
puts "\n"
