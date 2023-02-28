# Dahlia - Waveshaping Synthesis for the Daisy Platform
Dahlia is a waveshaping polyphonic synthesizer for the [Daisy Audio Platform](https://www.electro-smith.com/daisy). It is based on the [Waveshape-Synth](https://github.com/vulcu/waveshape-synth) project written in Pure Data, and cross-compiled to the Daisy platorm using [pd2dsy](https://github.com/electro-smith/pd2dsy) and the [Heavy Compiler Collection](https://github.com/enzienaudio/hvcc).

The overarching goal of placing it in an embedded platform is to make an instrument which sits halfway between playable and generative synthesizer, allowing people without a background in music to create complex compositional patterns by through interaction with a limited and intuitive control set.

## Table of Contents
* [General Info](#general-info)
* [Features](#features)
* [Algorithms](#algorithms)
* [References](#references)

## General Info
The original [Waveshape-Synth](https://github.com/vulcu/waveshape-synth) is an 8-voice polyphonic audio synthesizer with per-voice oscillator waveshaping created as a collection of Pure Data subpatches. It was inspired by [wavedist](https://github.com/vulcu/wavedist) and uses the same waveshaping algorithms. Dahlia is a simplified version of this, with the controls modified to accomodate the limited Daisy Pod UI.

#### Installation
1. Follow the instructions for [installing the Daisy Toolchain for your OS](https://github.com/electro-smith/DaisyWiki/wiki/1.-Setting-Up-Your-Development-Environment#1-install-the-toolchain)
1. Install python for your OS (requires Python >=3.7)
    1. On MacOS and Linux Python 3.x may already be installed, this can be checked in the terminal using `python3 --version`. If it's not installed, installation is easy but the specifics will depend on your package manager (i.e. `brew`, `apt`, `pacman`, etc.)
    1. Details for [installing python on windows](https://github.com/electro-smith/DaisyWiki/wiki/1c.-Installing-the-Toolchain-on-Windows#python-optional). Ensure the installed version is at least 3.7.
1. Clone this repo with `git clone https://github.com/vulcu/dahlia`, and navigate to the cloned repository.
1. Once navigated to the repository, run the following to create a new Python virtual environment (commands here are specific to **git-bash** in Windows and may vary slightly for other OS, i.e. `python3` instead of `py`):
```bash
py -m ensurepip -U
py -m pip install virtualenv

# if there's an existing .venv directory be sure to delete it first!
pip -m venv ./.venv
```
5. Once the python virtual environment is installed to `dahlia/.venv`, activate it and install this fork of the [Heavy Cross-Compiler (hvcc)](https://github.com/Wasted-Audio/hvcc) along with [the pd2dsy dependencies](https://github.com/electro-smith/pd2dsy).
```bash
source ./.venv/Scripts/activate
pip install -r requirements.txt
```
6. Run the following to update all Git submodules and build `pd2dsy`:
```bash
git submodule update --init --recursive
cd lib/pd2dsy/libdaisy
make clean | grep "warningr:\|error:"
make -j4 | grep "warning:r\|error:"
cd ../../..
```
7. If there's no errors from the above, then everything Dahlia needs is ready to go.


## General Info
This project is a synthesizer not quite like any other. It relies on a handful of waveshaping algorithms to produce differing kinds of overdrive and distortion from the oscillators of each synthesizer voice, and then applies an ADS-envelope low-pass filter to each voice on an individual basis. The harmonic ratios and the balance between even and odd harmonics varies by algorithm, with some sounding better than others for certain oscillator and envelope combinations. There's no hard-and-fast rules here, so just use your ears.

The goal of this project is to provide a quick and simple way for a user to dial in rich, complex synth sounds without needing to know much about synthesizers. Unlike the [wavedist](https://github.com/vulcu/wavedist) plugin, all the waveshapers are active at once here, allowing for some truly wild harmonic ratios.

## Features
* Monophonic (1 Voice)
  * Includes polyphonic version (8-voices) easily reusable on more capable hardware
  * Portamento control (monophonic only)
* 7 Oscillators, 1 ADSR, and 2 ADS envelopes per-voice
* Oscillators selectable between Sine, Saw, and a PWM with a 5%-50% automatable duty-cycle
* 6 different waveshaping algorithms and a Gain control
* Unison control (oscillator de-tune)
* Bit depth control/crush range of 1-12 bits

#### To Do
* Pre-development planning

#### Status: This project is in the pre-development stage.

## Algorithms
This project uses the following algorithms for waveshaping and signal limiting:
```
 1) soft clip alg:        y[n] = (1.5*x[n]) - (0.5*x[n]^3);
 2) leaky integrator alg: y[n] = ((1 - A) * x[n]) + (A * y[n - 1]);
 3) soft knee clip alg:   y[n] = x[n] / (K * abs(x[n]) + 1);
 4) cubic soft clip alg:  y[n] = (1.5 * threshold * HardClip(x[n])) -
                                ((0.5 * HardClip(x[n])^3) / threshold);
 5) warp alg: y[n] = (((x[n] * 1.5) - (0.5 * x[n]^3)) * (((2 * K) / (1 - K))
                    + 1)) / ((abs((x[n] * 1.5) - (0.5 * x[n]^3)) 
                    * ((2 * K) / (1 - K))) + 1);
 6) rectify alg: y[n] = ((1 - R) * softclip(x[n])) + (|softclip(x[n])| * R);
```

## References:
1)  Aarts, R.M., Larsen, E., and Schobben, D., 2002, 'Improving Perceived Bass and Reconstruction of High Frequencies for Band Limited Signals' Proc. 1st IEEE Benelux Workshop MPCA-2002, pp. 59-71
 2) Arora et al., 2006, 'Low Complexity Virtual Bass Enhancement Algorithm for Portable Multimedia Device' AES 29th International Conferance, Seoul, Korea, 2006 September 2-4
 3) Gerstle, B., 2009, 'Tunable Virtual Bass Enhancement', [ONLINE] <http:rabbit.eng.miami.edu/students/ddickey/pics/Gerstle_Final_Project.pdf>
 4) Yates, R. and Lyons, R., 2008, 'DC Blocker Algorithms' IEEE Signal Processing Magazine, March 2008, pp. 132-134

## 
(C) 2021-2022, Winry R. Litwa-Vulcu
