![User Interface](docs/img/controls-modern.png)

# Dahlia - Waveshaping Synthesis for HVCC

**Dahlia** is an implementation of the [Waveshape-Synth](https://github.com/vulcu/waveshape-synth) polyphonic synthesizer written in PureData and intended for use with the [Heavy Compiler Collection](https://github.com/Wasted-Audio/hvcc). Possible applications include the [Daisy Audio Platform](https://www.electro-smith.com/daisy) (using [pd2dsy](https://github.com/electro-smith/pd2dsy)), the [Distrho Plugin Framework](https://github.com/DISTRHO/DPF), and Javascript (using [WebAudio](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)).

## Table of Contents

* [General Info](#general-info)
* [Features](#features)
* [User Interface](/docs/01.ui-configurations.md#dahlia-user-interface-configurations)
* [Installation (Dahlia)](/docs/02.1.setup.dahlia.md#installation--setup-dahlia-python--hvcc)
* [Installation (Daisy)](/docs/02.2.setup.daisy.md#installation--setup-daisy)
* [Installation (DPF)](/docs/02.3.setup.dpf.md#installation--setup-distrho-plugin-framework)
* [Installation (Javascript)](/docs/02.4.setup.javascript.md#installation--setup-distrho-plugin-framework)
* [Algorithms](/docs/03.algorithms.md)
* [References](/docs/04.references.md)

## General Info

The original [Waveshape-Synth](https://github.com/vulcu/waveshape-synth) is an 8-voice polyphonic audio synthesizer with per-voice oscillator waveshaping created as a collection of Pure Data subpatches. It was inspired by [wavedist](https://github.com/vulcu/wavedist) and uses the same waveshaping algorithms. **Dahlia** is an evolution of this concept, refactored to work with HVCC and capable of a simplified control scheme accomodating the limited Daisy Pod UI. **Dahlia** can also be used directly from within Pure Data, see `main_puredata.pd` for an example.

The synthesizer itself relies on a handful of waveshaping algorithms to produce differing kinds of overdrive and distortion from the oscillators of each synthesizer voice, and then applies an ADS-envelope low-pass filter to each voice on an individual basis. The harmonic ratios and the balance between even and odd harmonics varies by algorithm, with some sounding better than others for certain oscillator and envelope combinations. There's no hard-and-fast rules here, so just use your ears.

The goal of this project is to provide a quick and simple way for a user to dial in rich, complex synth sounds without needing to know much about synthesizers. Unlike the [wavedist](https://github.com/vulcu/wavedist) plugin, all the waveshapers are active at once here, allowing for some truly wild harmonic ratios.

## Features

* Monophonic (1 Voice) and Polyphonic (8-voices)
  * Polyphonic version easily adaptable to _N_ number of voices based on system resources
  * Monophonic version has midi-adjustable portamento control
  * Lightweight `|miniphonic|` monophonic voice for resource-constrained applications
* 7 Oscillators, 1 ADSR, and 2 ADS envelopes per-voice
* Oscillators selectable between Sine, Saw, and a PWM with a 5%-50% automatable duty-cycle
* 6 different waveshaping algorithms and a Gain control
* Unison control (oscillator de-tune)
* Bit depth control/crush range of 1-12 bits

## To Do

* ~~Pre-development planning~~
* **General**
  * ~~Refactor PD source for HVCC compatibility~~
  * ~~Update docs with details of UI functions/feedback~~
  * ~~Include separate install/build documentation for each Dahlia target~~
* **Daisy**
  * ~~Refactor `main_daisy.pd` to target Daisy build~~
  * ~~Redesign UI for Daisy Pod~~
    * ~~Daisy Pod UI simulator~~
  * ~~Build scripts targeting Daisy (HVCC and pd2dsy)~~
  * ~~Design a new voice for the Daisy platform with lower complexity~~
* **Distrho Plugin Framework**
  * ~~Refactor `main_dpf.pd` to target a DPF build~~
  * ~~Build script targeting DPF (HVCC)~~
* **Javascript**
  * ~~Refactor `main_js.pd` to target a Javascript/WebAudio build~~
  * ~~Build script targeting Javascript/WebAudio (HVCC)~~

**Status: Project feature development is on hiatus, but it is actively maintained.**

<br>
(C) 2021-2023, Winry R. Litwa-Vulcu
