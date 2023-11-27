# Installation & Setup: Daisy

1. Follow the instructions for [installing the Daisy Toolchain for your OS](https://github.com/electro-smith/DaisyWiki/wiki/1.-Setting-Up-Your-Development-Environment#1-install-the-toolchain)
1. Install python for your OS (requires Python >=3.7)
    1. On MacOS and Linux Python 3.x may already be installed, this can be checked in the terminal using `python3 --version`. If it's not installed, installation is easy but the specifics will depend on your package manager (i.e. `brew`, `apt`, `pacman`, etc.)
    1. Details for [installing python on windows](https://github.com/electro-smith/DaisyWiki/wiki/1c.-Installing-the-Toolchain-on-Windows#python-optional). Ensure the installed version is at least 3.7.
1. Clone this repo with `git clone https://github.com/vulcu/dahlia.git`, and navigate to the cloned repository.
1. Once navigated to the repository, run the following to create a new Python virtual environment (commands here are specific to **git-bash** in Windows and may vary slightly for other OS, i.e. `python3` instead of `py`):

```bash
$ py -m ensurepip -U
$ py -m pip install virtualenv

# if there's an existing .venv directory be sure to delete it first!
$ py -m venv ./.venv
```

5. Once the python virtual environment is installed to `dahlia/.venv`, activate it and install the Python package for this fork of the [Heavy Compiler Collection (hvcc)](https://github.com/Wasted-Audio/hvcc), along with some additional required packages:

```bash
$ source ./.venv/Scripts/activate   # for MacOS/Linux this is `./.venv/bin/activate`
$ pip install -r requirements.txt
$ deactivate
```

6. Run the following to initialize all Git submodules, then Build `libdaisy` using the [Daisy toolchain](https://github.com/electro-smith/DaisyWiki/wiki/1.-Setting-Up-Your-Development-Environment#1-install-the-toolchain):

```bash
$ git submodule update --init --recursive
$ cd lib/pd2dsy/libdaisy
$ make clean | grep "warning:\|error:"
$ make -j4 | grep "warning:\|error:"
```

7. Install a second Python virtual environment specifically for `pd2dsy`:

```bash
$ py -m venv ./pd_env
$ source ./pd_env/scripts/activate  # for MacOS/Linux this is `./pd_env/bin/activate`
$ pip install -r requirements.txt
$ pip install setuptools
$ deactivate
```

8. If there's no errors from the above, then everything **Dahlia** needs is ready to go. As a test, return to the `dahlia` root directory and compile for Daisy using hvcc and pd2dsy:

```bash
# generate for a target (e.g. Daisy) from pd source using HVCC only
$ source ./dahlia-hvcc.sh daisy

# build from pd source and compile for Daisy platform using Arm toolchain
$ source ./dahlia-daisy-pd2dsy.sh
```

The second script will automatically try uploading to a Daisy device. The UI is expected to work, but audio will not as the Pd code uses the `|null_voice|` module in place of `|monophonic|`. The reason for this is a known memory limitation; Electrosmith [has not released a working `pd2dsy` solution](https://github.com/electro-smith/pd2dsy/issues/24) for executables larger than 128 kB.
