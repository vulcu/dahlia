#!/bin/bash

# target and environment args for pd2dsy
dahlia_root=$PWD
board=pod;
ram=speed;
rom=size;
output_directory="../../src/";
search_paths="../heavylib/ -p ../heavylib/hv.filters -p ../heavylib/hv.osc";
libdaisy_dir="../../lib/pd2dsy/libdaisy"
no_build="--no-build";  # use "--no-build" to prevent automatic building and flashing after hvcc generation

printf "\nCleaning up previous builds...\n"
rm -r src/main

printf "Building Dahlia via hvcc...\n" 
cd lib/pd2dsy
source ./pd_env/Scripts/activate
python pd2dsy.py ../../pd/main.pd -b $board --ram $ram --rom $rom -d $output_directory -p $search_paths $no_build
deactivate

cd $output_directory/main
sed -i.bak -e "s|.*LIBDAISY_DIR = .*|LIBDAISY_DIR = $libdaisy_dir|" Makefile
rm Makefile.bak
make && make program-dfu

cd $dahlia_root
printf "\nBuild Completed! If there are no errors above, the generated source files are located in /src/main\n"
