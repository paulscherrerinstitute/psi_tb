# General Information

## Maintainer
Oliver Bründler [oliver.bruendler@psi.ch]

## License
This library is published under [PSI HDL Library License](License.txt), which is [LGPL](LGPL2_1.txt) plus some additional exceptions to clarify the LGPL terms in the context of firmware development.

## Changelog
See [Changelog](Changelog.md)

## What belongs into this Library
This library contains VHDL code that is useful for testbenches. The code is meant for testbenches only, so it does not
have to be synthesizable.

It is suggested to use one .vhd file per Package or Entity.

Examples for things that belong into this library:
* Bus-Functional-Modelsim
* Functions for checking values
* Functionality for automated stimuli generation (e.g. random generators)

## What does not belong into this Library

 * Any project specific code
 * Code that better fits into another library 
 * Code that is meant for snythesis
 
# Dependencies

The required folder structure looks as given below (folder names must be matched exactly). 

Alternatively the repository [psi\_fpga\_all](https://github.com/paulscherrerinstitute/psi_fpga_all) can be used. This repo contains all FPGA related repositories as submodules in the correct folder structure.
* TCL
  * [PsiSim](https://github.com/paulscherrerinstitute/PsiSim) (2.2.0 or higher)
* VHDL
  * [psi\_common](https://github.com/paulscherrerinstitute/psi_common) (2.6.0 or hgiher)
  * [**psi\_tb**](https://github.com/paulscherrerinstitute/psi_tb)

## Tagging Policy
Stable releases are tagged in the form *major*.*minor*.*bugfix*. 

* Whenever a change is not fully backward compatible, the *major* version number is incremented
* Whenever new features are added, the *minor* version number is incremented
* If only bugs are fixed (i.e. no functional changes are applied), the *bugfix* version is incremented
 