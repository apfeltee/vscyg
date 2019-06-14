#!/usr/bin/ruby

=begin
4.8K    c:/cloud/gdrive/portable/devtools/masm32/bin/rc.exe
73.6K   c:/Program Files (x86)/Windows Kits/8.1/bin/x64/rc.exe
74.1K   c:/Program Files (x86)/Windows Kits/8.1/bin/x86/rc.exe
102.0K  c:/Users/sebastian/Desktop/shareware/various-collections/nightowl7/024a/rc111/rc.exe
60.9K   c:/Users/sebastian/Desktop/shareware/various-collections/nightowl7/024a/ss103/rc.exe
68.7K   c:/Windows Kits/10/bin/10.0.17763.0/arm64/rc.exe
77.5K   c:/Windows Kits/10/bin/10.0.17763.0/x64/rc.exe
73.8K   c:/Windows Kits/10/bin/10.0.17763.0/x86/rc.exe
=end


# WINDOWSSDKVERBINPATH=C:/Windows Kits/10/bin/10.0.17763.0
# VSCMD_ARG_HOST_ARCH=x64

def xgetenv(name)
  if ENV.key?(name) then
    return ENV[name]
  end
  $stderr.printf("environment variable %p not defined - maybe you need to run 'loadvs'\n")
  exit(1)
end

def mktgt(path)
  winsdkpath = xgetenv("WINDOWSSDKVERBINPATH")
  arch = xgetenv("VSCMD_ARG_HOST_ARCH")
  base = File.basename(path)
  tmp = base.gsub(/^win/, "").gsub(/\.rb$/i, "")
  if not tmp.end_with?(".exe") then
    tmp = (tmp + ".exe")
  end
  physpath = File.join(winsdkpath, arch, tmp)
  if not File.file?(physpath) then
    $stderr.printf("loader: error: path %p does not exist! your VS installation may be broken\n")
    exit(1)
  end
  return physpath.gsub(/ /, "\\ ")
end

begin

  
  scriptself = File.absolute_path($0)
  realself = File.realpath(File.join(__dir__, "loader.rb"))
  #if File.stat(scriptself) == File.stat(realself) then
  if File.basename(scriptself).downcase == File.basename(realself).downcase then
    $stderr.printf("'loader.rb' should be symlinked to the target executable's name (i.e., loader.rb -> winrc.rb)")
    exit(1)
  else
    tgtexe = mktgt(scriptself)
    cmd = [tgtexe, *ARGV]
    printf("cmd = %p\n", cmd)
    system(*cmd)
  end
end
