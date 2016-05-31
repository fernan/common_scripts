#!/bin/bash
echo "module file generator"
echo "====================="

while true; do
    read -p "are you in the pogramdir/version_num location: " yn
    case $yn in
        [Yy]* ) version=$(basename $(pwd)); ppath=$(dirname $(pwd)); break;;
        [Nn]* ) echo "please change to program_dir/version_num first"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
pname=$(basename $ppath);

IFS= read -r -p "short description: " des;
IFS= read -r -p "homepage url: " hurl;
IFS= read -r -p "download url: " durl;
IFS= read -r -p "info url: " iurl;
IFS= read -r -p "dependent modules list: " modules;

echo program path: $ppath;
echo program version: $version;
echo program name: $pname;
echo description: $des;
echo Homepage: $hurl;
echo Download: $durl;
echo Info: $iurl;


mkdir -p /shared/software/GIF/modules/$pname;
cat <<MODFILE1 > /shared/software/GIF/modules/$pname/$version
#%Module1.0#####################################################################
##
module-whatis   "$des"
set     version         $version
set     name            $pname
set     progdir         /shared/software/GIF/programs/\$name/\$version

module load compilers/gcc-4.8.2
MODFILE1
for f in $modules; do echo
module load $f >> /shared/software/GIF/modules/$pname/$version
done;
cat <<MODFILE2 >> /shared/software/GIF/modules/$pname/$version
prepend-path    PATH                    \$progdir/bin
prepend-path    MANPATH                 \$progdir/share/man
prepend-path    LD_LIBRARY_PATH         \$progdir/lib
prepend-path    LIBRARY_PATH            \$progdir/lib
prepend-path    C_INCLUDE_PATH          \$progdir/include
prepend-path    CPLUS_INCLUDE_PATH      \$progdir/include
prepend-path    PKG_CONFIG_PATH         \$progdir/lib/pkgconfig
prepend-path    CMAKE_INCLUDE_PATH      \$progdir/include
prepend-path    CMAKE_LIBRARY_PATH      \$progdir/lib

proc ModulesDisplay { } {
global version name progdir
puts stderr "
Notes:
Module name: $name
Version: $version
$des
Homepage: $hurl
Download: $durl
Info: $iurl
"
}
proc ModulesHelp {} { ModulesDisplay }
MODFILE2
