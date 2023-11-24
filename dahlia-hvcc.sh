#!/bin/bash
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

# HVCC build arguments
search_paths="lib/heavylib lib/heavylib/hv.filters lib/heavylib/hv.osc"
out_dir="./src/"
name="dahlia"
meta=""
copyright="Copyright Winry Litwa-Vulcu 2021-2023 and Licensed under GPL-3.0"

# common error messages
errmsg_usage="Usage is ./dahlia-hvcc.sh [ daisy | dpf | webaudio ]\n\n"

if [[ $# -eq 0 ]]; then
    printf "\nError: Generator target not specified!\n"
    printf "$errmsg_usage"
    return 1 2> /dev/null || exit 1
elif [[ $# -gt 1 ]]; then
    printf "\nError: Too many generator targets!\n"
    printf "$errmsg_usage"
    return 1 2> /dev/null || exit 1
else
    if [[ $1 == "daisy" ]] || [[ $1 == "dpf" ]] || [[ $1 == "webaudio" ]]; then
        pd_filename=main_$1
        if [[ $1 == "dpf" ]]; then
            meta="dahlia-dpf.json"
        fi
    else
        printf "\nError: Unrecognized generator target!\n"
        printf "$errmsg_usage"
        return 1 2> /dev/null || exit 1
    fi
fi

printf "\nCleaning up previous builds...\n"
rm -r src/ir && rm -r src/hv && rm -r src/c

printf "Building Dahlia via hvcc...\n"
source  ./.venv/$activation_script_directory/activate
hvcc ./pd/$pd_filename.pd -o $out_dir -n $name -p $search_paths -m $meta --copyright "$copyright"
deactivate

printf "Build Completed! If there are no errors above, the generated source files are located in $out_dir\n\n"
