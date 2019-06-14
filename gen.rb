#!/usr/bin/ruby

require "ostruct"
require "~/dev/gems/lib/cygpath.rb"

# these are blacklisted environment variables.
# it's wiser to just use a blacklisting system, because otherwise
# it would be a guessing game to figure out which vars
# visual studio needs.
BADNAMES = %w(
  prompt
  ps1
  cygwin
  homedrive homepath
  temp tmp
  comspec
  conemuansi
  conemuansilog
  conemuargs
  conemuargs2
  conemubackhwnd
  conemubasedir
  conemubasedirshort
  conemubuild
  conemucfgdir
  conemuconfig
  conemudir
  conemudrawhwnd
  conemudrive
  conemuhooks
  conemuhwnd
  conemuisadmin
  conemupalette
  conemupid
  conemuserverpid
  conemutask
  conemuworkdir
  conemuworkdrive
  os
  pathext
  platform
  processor_architecture
  processor_identifier
  processor_level
  processor_revision
  programw6432
  systemdrive
  systemroot
  userdomain
  userdomain_roamingprofile
  username
  userprofile
  ansicon ansicon_def
  commandprompttype
  commonprogramfiles
  commonprogramw6432
  logonserver
  public
  windir
  __compat_layer
  appdata
)

# regular expressions for paths that should be explicitly removed
# from $PATH - usually paths that would collide with cygwin commands
# in this case, python
BADPATHS = [
  /^c:[\\\/](\w+[\\\/])?python(.*)?[\\\/]/i,
]

# variables that denote paths
# [variablename] -> [separator]
CHECKME = {
  "INCLUDE" => ";",
  "LIB" => ";",
  "LIBPATH" => ";",
  "PATH" => ":",
}

# variables whose separator must be modified
# [variable] => [[originalseparator], [newseparator]]
MUSTCONVERT = {
  "PATH" => [";", ":"],
}

# token-separated variables that already exist, and
# also appear in visual studio, and thus need to be appended
# [variable] => [separator]
MUSTAPPEND = {
  "PATH" => ":",
}

# variables that should be joined
# syntax:
# [destinationvar] => {sep: [separator], names: [environmentvars]}
#
# only changes destinationvar if the names in .names actually exist
MAYJOIN = {
  "INCLUDE" => {sep: ";", names: ["CPATH", "C_INCLUDE_PATH", "CPLUS_INCLUDE_PATH"]},
}

def isbad(name)
  if BADNAMES.include?(name.downcase) then
    return true
  end
  return (name.match(/^\w+$/) == nil)
end


def win2cyg(path)
  newpath = Cygpath.win2cyg(path)
  $stderr.printf("winnt->cygwin: %p => %p\n", path, newpath)
  return newpath
end

def cyg2win(path)
  newpath = Cygpath.cyg2win(path)
  $stderr.printf("cygwin->winnt: %p => %p\n", path, newpath)
  return newpath
end

def mkval(name, rawstr)
  value = rawstr.join("=")
  value.gsub!("\\", "/")
  if MUSTCONVERT.key?(name) then
    oldsep, newsep = MUSTCONVERT[name]
    if name == "PATH" then
      vals = []
      value.split(oldsep).each{|v|  
        BADPATHS.each do |bp|
          if not v.match?(bp) then
            cygged = win2cyg(v)
            vals.push(cygged)
          end
        end
      }
      value = vals.join(newsep)
    else
      value = value.split(oldsep).map{|v| win2cyg(v) }.join(newsep)
    end
  end
  if MAYJOIN.key?(name) then
    data = MAYJOIN[name]
    sep = data[:sep]
    data[:names].each do |envname|
      envval = ENV[envname]
      if envval != nil then
        value += sep + envval.split(":").map{|v| cyg2win(v) }.join(sep)
      end
    end
  end
  return value
end

begin
  infile = File.absolute_path("set.bat")
  outfile = File.absolute_path("vscyg.sh")
  #var.sname, var.sep, var.data
  mustcheck = []
  scrpath = "C:/cloud/local/dev/vscyg/sanitycheck.rb"
  File.open(outfile, "wb") do |outfh|
    outfh.puts([
      "#",
      "# this file was AUTOMATICALLY GENERATED! do not edit directly!",
      "# instead, run 'gen.rb' again.",
      "#",
      "# input Visual Studio environment dump: #{infile.dump}",
      "# generated at #{Time.now}",
      "#",
    ].join("\n"))
    File.open(infile, "rb") do |infh|
      infh.each_line do |line|
        line.strip!
        raw = line.split("=")
        name = raw.shift.upcase
        next if isbad(name)
        value = mkval(name, raw)
        outval = value
        if MUSTAPPEND.key?(name) then
          outval = sprintf('$%s%s%s', name, MUSTAPPEND[name], value)
        end
        outfh.printf("export %s=%p\n", name, outval)
        if CHECKME.keys.include?(name) then
          mustcheck.push(OpenStruct.new(sname: name, sep: CHECKME[name], data: value, typ: "dir"))
        end
      end
      # also emit simple sanity checks - notifying the user
      # if paths have changed (i.e., because they've been deleted, or moved, etc)
      # syntax for that is:
      #  %p[scriptfile] %s[varname-without-sigil] %s[vartype-dir-or-file] %s[separator] %s[sigilvarname]
      outfh.printf("\n\n# sanity checks below\n\n\n")
      mustcheck.each do |var|
        outfh.printf("ruby %p %s %s %p \"$%s\"\n", scrpath, var.sname, var.typ, var.sep, var.sname)
      end
      outfh.print("\n# end of file\n")
    end
  end
end


