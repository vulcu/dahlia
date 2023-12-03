#!/bin/bash

# HVCC build arguments (see HVCC documentation for more information)
hvcc_search_paths="lib/heavylib lib/heavylib/hv.filters lib/heavylib/hv.osc"
hvcc_out_dir="./gen/"
name="dahlia"
copyright="Copyright Winry Litwa-Vulcu 2021-2023 and Licensed under GPL-3.0"

# PD2DSY build arguments (see pd2dsy documentation for more information)
board=pod;
ram=speed;
rom=speed;              # 'size' is required if program exceeds 128kB internal flash
pd2dsy_out_dir="../../gen";
pd2dsy_search_paths="../heavylib/ -p ../heavylib/hv.filters -p ../heavylib/hv.osc";
libdaisy_dir="../../lib/pd2dsy/libdaisy"
no_build="--no-build";  # use "--no-build" to prevent automatic building and flashing after hvcc generation

# commonly used messages
errmsg_usage="\e[30mUsage is ./dahlia-hvcc.sh [ daisy | pd2dsy | dpf | js | clean ]\e[0m\n\n"
msg_clean_start="\nCleaning up previous generator output for this target...\n"

# echo executed command to the shell
exe() {
    printf "\e[36m++ $(echo "$@")\e[0m\n"
    "$@"
}

# clean all output located in the 'gen/' dircectory
cleanall() {
    printf "\nCleaning up previous builds for ALL targets..."
    # completely clean all previous generator output
    if [ -d ./gen ] && [ "$(ls -A ./gen)" ] ; then         
        rm -r gen/*
    fi
    printf "done!\n"
}

# clean common hvcc directories generated for every target
cleanhvcc() {
    if [ -d ./gen/hv ]; then  
        rm -r gen/ir && rm -r gen/hv && rm -r gen/c
    fi
}

# Python virtualenv activation directory name varies with OS type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    activation_script_directory=bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    activation_script_directory=bin
elif [[ "$OSTYPE" == "msys" ]]; then
    # Win (GitBash/MinGW/MSYS2)
    activation_script_directory=Scripts
fi

if [[ $# -gt 1 ]]; then
    # print usage and return with error
    printf "\n\e[31mError: Too many generator targets!\e[0m\n"
    printf "$errmsg_usage"
    return 1 2> /dev/null || exit 1
elif [[ $# -eq 0 ]]; then
    # build using only HVCC and return successful
    printf "\n\e[32mGenerator not specified, building Heavy Lang only...\e[0m"
    cleanall
    pd_filename="main_hvcc"
    printf "Building Dahlia via hvcc...\n"
    source  ./.venv/$activation_script_directory/activate
    exe hvcc ./src/pd/$pd_filename.pd -o $hvcc_out_dir -p $hvcc_search_paths -n $name -v --copyright "$copyright"
    deactivate
    printf "\e[32mBuild Completed! If there are no errors above, the generated source files are located in $hvcc_out_dir\e[0m\n\n"
    return 0 2> /dev/null || exit 0
elif [[ $1 == "clean" ]]; then
    # clean up all existing generator output and return successful
    cleanall
    printf "\n"
    return 0 2> /dev/null || exit 0
else
    # set variables and clean up generator outputs related to a specific target
    if [[ $1 == "daisy" ]]; then
        pd_filename=main_$1
        meta="-m src/meta/dahlia-daisy.json"
        gen="daisy"
        printf "$msg_clean_start"
        if [ -d ./gen/daisy ]; then
            rm -r gen/daisy
        fi
        cleanhvcc
    elif [[ $1 == "pd2dsy" ]]; then
        dahlia_root=$PWD
        pd_filename=main_daisy
        printf "$msg_clean_start"
        if [ -d ./gen/$pd_filename ]; then
            rm -r gen/$pd_filename
        fi
        cleanhvcc
    elif [[ $1 == "dpf" ]]; then
        pd_filename=main_hvcc
        meta="-m src/meta/dahlia-dpf.json"
        gen="dpf"
        printf "$msg_clean_start"
        if [ -d ./gen/plugin ]; then
            rm -r gen/plugin
        fi
        if [ -f ./gen/Makefile ]; then
            rm gen/Makefile
        fi
        if [ -f ./gen/README.md ]; then
            rm gen/README.md
        fi
        cleanhvcc
    elif [[ $1 == "js" ]]; then
        pd_filename=main_hvcc
        meta=""
        gen="js"
        printf "$msg_clean_start"
        case :$PATH: in
            *:$PWD/lib/emsdk:*) 
                # EMSDK environment variables are already set so do nothing
                ;;
            *)
                printf "\e[33mWarning:\e[0m EMSDK environment is not set! Running environment setup...\n"
                exe source ./lib/emsdk/emsdk_env.sh
                printf "\n"
                ;;
        esac
        cleanhvcc
    else
        printf "\n\e[31mError: Unrecognized generator target!\e[0m\n"
        printf "$errmsg_usage"
        return 1 2> /dev/null || exit 1
    fi
fi

if [[ $1 == "pd2dsy" ]]; then
    printf "Building Dahlia via pd2dsy...\n" 
    cd lib/pd2dsy
    source ./pd_env/$activation_script_directory/activate
    exe python pd2dsy.py ../../src/pd/$pd_filename.pd -b $board --ram $ram --rom $rom -d $pd2dsy_out_dir -p $pd2dsy_search_paths $no_build
    deactivate

    printf "Building Heavy source with make and attempting upload via DFU...\n" 
    cd $pd2dsy_out_dir/$pd_filename
    sed -i.bak -e "s|.*LIBDAISY_DIR = .*|LIBDAISY_DIR = $libdaisy_dir|" Makefile    # fix incorrect libdaisy path
    rm Makefile.bak
    make
    exe make program-dfu

    cd $dahlia_root
    printf "\nBuild Completed! If there are no errors above, the generated source files are located in /gen/$pd_filename\n"
else
    printf "Building Dahlia via hvcc...\n"
    source  ./.venv/$activation_script_directory/activate
    exe hvcc ./src/pd/$pd_filename.pd -o $hvcc_out_dir -p $hvcc_search_paths -n $name $meta -g $gen -v --copyright "$copyright"
    deactivate

    printf "Build Completed! If there are no errors above, the generated source files are located in $hvcc_out_dir\n\n"
fi
