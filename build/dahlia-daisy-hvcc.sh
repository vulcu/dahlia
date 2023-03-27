#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        activation_script_directory=bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # MacOS (this might be wrong!)
        activation_script_directory=bin
elif [[ "$OSTYPE" == "msys" ]]; then
        # Win (GitBash/MinGW)
        activation_script_directory=Scripts
fi

pd_filename="main_daisy"

printf "\nCleaning up previous builds...\n"
rm -r src/ir && rm -r src/hv && rm -r src/c

printf "Building Dahlia via hvcc...\n"
source  ./.venv/$activation_script_directory/activate
hvcc ./pd/$pd_filename.pd  -o ./src/ -n dahlia -p lib/heavylib lib/heavylib/hv.filters lib/heavylib/hv.osc --copyright "Winry Litwa-Vulcu 2021-2023 and Licensed under GPL-3.0"
deactivate

printf "Build Completed! If there are no errors above, the generated source files are located in /src\n"
