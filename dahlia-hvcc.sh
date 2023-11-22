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

if [[ $# -eq 0 ]] || [[ $# -gt 1 ]]; then
        printf "\nError: Illegal number of parameters\n"
        printf "Arguments are [main_daisy|main_dpf|main_webaudio]\n\n"
        return 1 2> /dev/null || exit 1
else
        pd_filename=$1
        if [[ $1 == "main_daisy" ]] || [[ $1 == "main_dpf" ]] || [[ $1 == "main_webaudio" ]]; then
                pd_filename=$1
        else
                printf "\nError: Unrecognized build filename\n"
                printf "Arguments are [main_daisy|main_dpf|main_webaudio]\n\n"
                return 1 2> /dev/null || exit 1
        fi
fi

printf "\nCleaning up previous builds...\n"
rm -r src/ir && rm -r src/hv && rm -r src/c

printf "Building Dahlia via hvcc...\n"
source  ./.venv/$activation_script_directory/activate
hvcc ./pd/$pd_filename.pd  -o ./src/ -n dahlia -p lib/heavylib lib/heavylib/hv.filters lib/heavylib/hv.osc --copyright "Winry Litwa-Vulcu 2021-2023 and Licensed under GPL-3.0"
deactivate

printf "Build Completed! If there are no errors above, the generated source files are located in /src\n\n"
