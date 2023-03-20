#!/bin/bash

# target and environment args for pd2dsy
dahlia_root=$PWD
board=pod;
ram=speed;
rom=size;               # 'size' is required if program exceeds 128kB internal flash
pd_filename="main_daisy"
output_directory="../../src";
search_paths="../heavylib/ -p ../heavylib/hv.filters -p ../heavylib/hv.osc";
libdaisy_dir="../../lib/pd2dsy/libdaisy"
no_build="--no-build";  # use "--no-build" to prevent automatic building and flashing after hvcc generation

printf "\nCleaning up previous builds...\n"
rm -r src/$pd_filename

printf "Building Dahlia via pd2dsy...\n" 
cd lib/pd2dsy
source ./pd_env/Scripts/activate
python pd2dsy.py ../../pd/$pd_filename.pd -b $board --ram $ram --rom $rom -d $output_directory -p $search_paths $no_build
deactivate

printf "Building Heavy source with make and attempting upload via DFU...\n" 
cd $output_directory/$pd_filename
sed -i.bak -e "s|.*LIBDAISY_DIR = .*|LIBDAISY_DIR = $libdaisy_dir|" Makefile
rm Makefile.bak
#make && make program-dfu

cd $dahlia_root
printf "\nBuild Completed! If there are no errors above, the generated source files are located in /src/$pd_filename\n"
