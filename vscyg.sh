
#####################
### configuration ###
#####################
##
## most variables that are "export"ed can be extracted from the visual
## studio command prompt (start > programs > visual studio > command prompt)
## by running
##
##    set > envvars.bat
##
## and then filling out the exported vars in THIS section of this file.
## make sure to read the comments! some elements can be tricky to figure out.
##

# where you have installed visual studio (or visual studio build tools)
# you can probably use the value from "envvars.bat".
export VSINSTALLDIR='C:/vsbuildtools/'

# these... are a mystery.
# you can probably use the value from "envvars.bat".
export VCToolsVersion="14.12.25827"
export VisualStudioVersion="15.0"

# where you have installed the Windows SDK.
# you can probably use the value from "envvars.bat".
export WindowsSdkDir='C:/Program Files (x86)/Windows Kits/10/'

# the version of the installed Windows SDK.
# you can probably use the value from "envvars.bat".
export WindowsSDKLibVersion="10.0.16299.0"

# the installation path of the dotnet framework.
# you can probably use the value from "envvars.bat".
export FrameworkDir='C:/Windows/Microsoft.NET/Framework/'

# the version of the main version of the installed dotnet framework.
# you can probably use the value from "envvars.bat".
export FrameworkVersion='v4.0.30319'

# the 32bit path of the framework directory - which appears to be the same
# as $FrameworkDir for some reason.
# you can probably use the value from "envvars.bat".
export FrameworkDir32="$FrameworkDir"
export FrameworkVersion32="$FrameworkVersion"

# if you want to build 64bit programs, set it to x64. otherwise, set to x86.
# they specify directories, so you cannot leave it blank!
# either x86, or x64
__vcbitmode="x64"

# the version of your dotnet FX.
# afaik, netfx is only needed for c++/clr. so if you don't use/write c++/clr, this
# probably won't matter too much either.
__vcNetFXVersion="4.7.1"

###############################################################
###############################################################
## The following should be largely installation-independent. ##
## you should follow the existing pattern of NOT hard-coding ##
## versions! instead, use the variables defined above.       ##
###############################################################
###############################################################

c_VSINSTALLDIR="$(cygpath -ua "$VSINSTALLDIR")"
c_WindowsSdkDir="$(cygpath -ua "$WindowsSdkDir")"
c_FrameworkDir="$(cygpath -ua "$FrameworkDir")"

export VCINSTALLDIR="${VSINSTALLDIR}/VC/"
export DevEnvDir="${VSINSTALLDIR}/Common7/IDE/"

##
export INCLUDE="${VCINSTALLDIR}/Tools/MSVC/${VCToolsVersion}/ATLMFC/include"
export INCLUDE="${VCINSTALLDIR}/Tools/MSVC/${VCToolsVersion}/include;$INCLUDE"
export INCLUDE="${WindowsSdkDir}/include/${WindowsSDKLibVersion}/ucrt;$INCLUDE"
export INCLUDE="${WindowsSdkDir}/include/${WindowsSDKLibVersion}/shared;$INCLUDE"
export INCLUDE="${WindowsSdkDir}/include/${WindowsSDKLibVersion}/um;$INCLUDE"
export INCLUDE="${WindowsSdkDir}/include/${WindowsSDKLibVersion}/winrt;$INCLUDE"

##
export LIB="${VCINSTALLDIR}/Tools/MSVC/${VCToolsVersion}/ATLMFC/lib/${__vcbitmode};"
export LIB="${VCINSTALLDIR}/Tools/MSVC/${VCToolsVersion}/lib/${__vcbitmode};$LIB"
export LIB="${WindowsSdkDir}/lib/${WindowsSDKLibVersion}/ucrt/${__vcbitmode};$LIB"
export LIB="${WindowsSdkDir}/lib/${WindowsSDKLibVersion}/um/${__vcbitmode};$LIB"
#export LIB="C:/Progra~2/Windows Kits/NETFXSDK/${__vcNetFXVersion}/Lib/um/${__vcbitmode};$LIB"
export LIB="c:/Progra~2/Microsoft.NET/SDK/v1.1/Lib/;$LIB"

##
export LIBPATH="${VCINSTALLDIR}/Tools/MSVC/${VCToolsVersion}/ATLMFC/lib/${__vcbitmode}/;$LIB"
export LIBPATH="${VCINSTALLDIR}/Tools/MSVC/${VCToolsVersion}/lib/${__vcbitmode}/;$LIBPATH"
export LIBPATH="${VCINSTALLDIR}/Tools/MSVC/${VCToolsVersion}/lib/${__vcbitmode}/store/references/;$LIBPATH"
export LIBPATH="${WindowsSdkDir}/UnionMetadata/${WindowsSDKLibVersion}/;$LIBPATH"
export LIBPATH="${WindowsSdkDir}/References/${WindowsSDKLibVersion}/;$LIBPATH"
export LIBPATH="C:/Windows/Microsoft.NET/Framework/${FrameworkVersion}/;$LIBPATH"

##
export PATH="$PATH:${c_VSINSTALLDIR}/MSBuild/${VisualStudioVersion}/bin/Roslyn"
export PATH="$PATH:${c_VSINSTALLDIR}/MSBuild/${VisualStudioVersion}/bin"
export PATH="$PATH:${c_VSINSTALLDIR}/VC/Tools/MSVC/${VCToolsVersion}/bin/Host${__vcbitmode}/${__vcbitmode}"
export PATH="$PATH:${c_VSINSTALLDIR}/Common7/IDE/VC/VCPackages"
export PATH="$PATH:${c_VSINSTALLDIR}/Common7/IDE/CommonExtensions/Microsoft/TestWindow"
export PATH="$PATH:${c_VSINSTALLDIR}/Common7/IDE/CommonExtensions/Microsoft/TeamFoundation/Team Explorer"
export PATH="$PATH:${c_VSINSTALLDIR}/Common7/IDE/"
export PATH="$PATH:${c_VSINSTALLDIR}/Common7/Tools/"
export PATH="$PATH:${c_WindowsSdkDir}/bin/${__vcbitmode}"
export PATH="$PATH:${c_WindowsSdkDir}/bin/${WindowsSDKLibVersion}/${__vcbitmode}"
export PATH="$PATH:${c_FrameworkDir}/${FrameworkVersion}/"
