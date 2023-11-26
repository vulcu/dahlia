#!/bin/bash
#Python virtualenv activation script location varies with OS type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    activation_script_directory=bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    activation_script_directory=bin
elif [[ "$OSTYPE" == "msys" ]]; then
    # Win (GitBash/MinGW)
    activation_script_directory=Scripts
fi

#echo executed command to the shell
exe() {
    printf "\e[36m++ $(echo "$@")\e[0m\n"
    "$@"
}

# HVCC build arguments
search_paths="lib/heavylib lib/heavylib/hv.filters lib/heavylib/hv.osc"
out_dir="./src/"
name="dahlia"
copyright="Copyright Winry Litwa-Vulcu 2021-2023 and Licensed under GPL-3.0"

# common error messages
errmsg_usage="\e[30mUsage is ./dahlia-hvcc.sh [ daisy | dpf | webaudio ]\e[0m\n\n"

if [[ $# -eq 0 ]]; then
    printf "\n\e[31mError: Generator target not specified!\e[0m\n"
    printf "$errmsg_usage"
    return 1 2> /dev/null || exit 1
elif [[ $# -gt 1 ]]; then
    printf "\n\e[31mError: Too many generator targets!\e[0m\n"
    printf "$errmsg_usage"
    return 1 2> /dev/null || exit 1
else
    if [[ $1 == "daisy" ]]; then
        pd_filename=main_$1
        meta="-m dahlia-daisy.json"
        gen="daisy"
    elif [[ $1 == "dpf" ]]; then
        pd_filename=main_$1
        meta="-m dahlia-dpf.json"
        gen="dpf"
    elif [[ $1 == "webaudio" ]]; then
        pd_filename=main_$1
        meta=""
        gen="js"
    else
        printf "\n\e[31mError: Unrecognized generator target!\e[0m\n"
        printf "$errmsg_usage"
        return 1 2> /dev/null || exit 1
    fi
fi

printf "\nCleaning up previous builds...\n"
rm -r src/ir && rm -r src/hv && rm -r src/c
if [ -d src/daisy ]; then
    rm -r src/daisy
fi
if [ -d src/plugin ]; then
    rm -r src/plugin
fi
if [ -f src/Makefile ]; then
    rm src/Makefile
fi
if [ -f src/README.md ]; then
    rm src/README.md
fi

printf "Building Dahlia via hvcc...\n"
source  ./.venv/$activation_script_directory/activate
exe hvcc ./pd/$pd_filename.pd -o $out_dir -p $search_paths -n $name $meta -g $gen -v --copyright "$copyright"
deactivate

printf "Build Completed! If there are no errors above, the generated source files are located in $out_dir\n\n"
