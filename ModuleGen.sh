#!/bin/bash
echo "module file generator"
echo "====================="

cwd=$(dirname $(pwd))
#echo $cwd
bwd=$(dirname ${cwd})
#echo $bwd
if [[ "$bwd" == "/shared/software/GIF/programs" ]]; then
echo "Path is correct, proceeding ...."

#while true; do
#    read -p "are you in the pogramdir/version_num location: " yn
#    case $yn in
#        [Yy]* ) version=$(basename $(pwd)); ppath=$(dirname $(pwd)); break;;
#        [Nn]* ) echo "please change to program_dir/version_num first"; exit;;
#        * ) echo "Please answer yes or no.";;
#    esac
#done
version=$(basename $(pwd));
ppath=$(dirname $(pwd));
pname=$(basename $ppath);

IFS= read -r -p "short description: " des;
IFS= read -r -p "homepage url: " hurl;
IFS= read -r -p "download url: " durl;
IFS= read -r -p "info url: " iurl;
IFS= read -r -p "dir name for adding to path (list them with a space in between eg: utils scripts): " dpname;
IFS=' ' read -r -a array <<< "$dpname"
PHOME="$(echo "$pname" | tr '[:lower:]' '[:upper:]')"_HOME


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
for f in $(echo $LOADEDMODULES | sed 's/:/\n/g'); do echo "module load $f"; done >> /shared/software/GIF/modules/$pname/$version
for element in "${array[@]}"; do
echo -e "prepend-path\tPATH\t\t\t\$progdir/$element";
done >> /shared/software/GIF/modules/$pname/$version
if [ -d bin ]; then
echo -e "prepend-path\tPATH\t\t\t\$progdir/bin" >> /shared/software/GIF/modules/$pname/$version
else
echo -e "prepend-path\tPATH\t\t\t\$progdir" >> /shared/software/GIF/modules/$pname/$version
fi
if [ -d lib ]; then
echo -e "prepend-path\tLD_LIBRARY_PATH\t\t\$progdir/lib" >> /shared/software/GIF/modules/$pname/$version
echo -e "prepend-path\tLIBRARY_PATH\t\t\$progdir/lib" >> /shared/software/GIF/modules/$pname/$version
echo -e "prepend-path\tPKG_CONFIG_PATH\t\t\$progdir/lib/pkgconfig" >> /shared/software/GIF/modules/$pname/$version
echo -e "prepend-path\tCMAKE_LIBRARY_PATH\t\t\$progdir/lib" >> /shared/software/GIF/modules/$pname/$version
echo -e "prepend-path\tLD_LIBRARY_PATH\t\t\$progdir/lib" >> /shared/software/GIF/modules/$pname/$version
fi
if [ -d include ]; then
echo -e "prepend-path\tC_INCLUDE_PATH\t\t\$progdir/include" >> /shared/software/GIF/modules/$pname/$version
echo -e "prepend-path\tCPLUS_INCLUDE_PATH\t\t\$progdir/include" >> /shared/software/GIF/modules/$pname/$version
echo -e "prepend-path\tCMAKE_INCLUDE_PATH\t\t\$progdir/include" >> /shared/software/GIF/modules/$pname/$version
fi
if [ -d share ]; then
echo -e "prepend-path\tMANPATH\t\t\t\$progdir/share/man" >> /shared/software/GIF/modules/$pname/$version
fi
echo -e "setenv\t$PHOME\t\t\t\$progdir" >> /shared/software/GIF/modules/$pname/$version
cat <<MODFILE2 >> /shared/software/GIF/modules/$pname/$version
proc ModulesDisplay { } {
global version name progdir
puts stderr "
Notes:
Module name: \$name
Version: \$version
$des
Homepage: $hurl
Download: $durl
Info: $iurl
"
}
proc ModulesHelp {} { ModulesDisplay }
MODFILE2

#cat /shared/software/GIF/modules/$pname/$version
echo "module file written sucessfully"
echo "Module file location: /shared/software/GIF/modules/$pname/$version"
else
echo "please change to /path/to/programs/program_dir/version_num first";
fi
