#!/bin/bash
echo "Cleaning up previous builds..."
rm -r src/ir && rm -r src/hv && rm -r src/c
echo "Building Dahlia via hvcc..." 
hvcc ./pd/main.pd  -o ./src/ -n dahlia -p lib/heavylib lib/heavylib/hv.filters lib/heavylib/hv.osc --copyright "Winry Litwa-Vulcu 2021-2023 and Licensed under GPL-3.0"
echo "Build Completed! If there are no errors above, the generated source files are located in /src"
