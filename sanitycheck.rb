#!/usr/bin/ruby

def check(itemtype, item)
  if (itemtype == "dir") then
    return File.directory?(item)
  end
  return File.file?(item)
end

def sanitycheck(name, itemtype, separator, data)
  values = data.split(separator)
  values.each do |val|
    if not check(itemtype, val) then
      $stderr.printf("vscyg-sanity: %s: not a %s: %p\n", name, itemtype, val)
    end
  end
end

begin
  #./"$script" include dir ";" "$INCLUDE"
  name = ARGV.shift.downcase
  itemtype = ARGV.shift.downcase
  separator = ARGV.shift
  data = ARGV.shift
  sanitycheck(name, itemtype, separator, data)
end
