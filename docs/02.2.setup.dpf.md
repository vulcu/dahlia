# Installation & Setup: Distrho Plugin Framework

1. Install your preferred toolchain for compiling C++ code for your operating system.
    1. In Ubuntu Linux, this can be done easily by installing the `build-essentials` and `pkg-config` packages. Other Linux distributions may require different packages, but need to be configured with the appropriate C++ tools and libraries.
    1. In Windows, the necessary tools can be installed using the [MSYS2 Software Distribution and Building Platform](https://www.msys2.org/).
        1. Get the latest version of MSYS2 via [the MSYS2 homepage](https://www.msys2.org/), which provides up-to-date native builds of GCC, GDB, MinGW, and other helpful C++ tools and libraries. The latest installer is found under **Step 1** of 'Installation'.
        1. Run the installer and follow the steps of the install wizard. Once installed, open the MSYS terminal and run the following to install the MinGW-w64 toolchain: `pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain`
        1. Accept the default number of packages in the toolchain group by pressing Enter, followed by `Y` to complete the installation. To check that your MinGW-w64 tools are correctly installed, open a new MSYS terminal and run the separate commands `gcc --version`, `g++ --version`, and `gdb --version`. They should all return version and copyright information.
1. Clone the Dahlia repo using `git clone https://github.com/vulcu/dahlia.git`, and navigate to the cloned repository.
1. Once navigated to the repository, run the following to create a new Python virtual environment (commands here are specific to **git-bash** in Windows and may vary slightly for other OS, i.e. `python3` instead of `py`):

```bash
$ py -m ensurepip -U
$ py -m pip install virtualenv

# if there's an existing .venv directory be sure to delete it first!
$ py -m venv ./.venv
```

4. Once the python virtual environment is installed to `dahlia/.venv`, activate it and install the Python package for this fork of the [Heavy Compiler Collection (hvcc)](https://github.com/Wasted-Audio/hvcc), along with some additional required packages:

```bash
$ source ./.venv/Scripts/activate   # for MacOS/Linux this is `./.venv/bin/activate`
$ pip install -r requirements.txt
$ deactivate
```

5. Run the following to initialize all Git submodules:

```bash
$ git submodule update --init --recursive
```

6. If there's no errors from any of the above steps, then everything **Dahlia** needs is ready to go. As a test, the code can be compiled using hvcc:

```bash
# generate for a target (e.g. DPF) from pd source using HVCC only
$ source ./dahlia-hvcc.sh dpf
```

Followed by compilation of the hvcc output using `make`. On Windows, this may require changing to a different shell environment, e.g. UCRT64/MSYS2, depending on how the C++ build tools from Step **1.** above are installed/configured.
