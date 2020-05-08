## 2.6.0
*Added Features
  *In psi_tb_compare_pkg added SignCompare2 (result print hstr)
  *In psi_tb_axi_pkg modification on axi utilities to support 64 bits (overload)

## 2.5.0
* Added Features
  * Add documentation of pkg function
  * In psi_tb_textfile_pkg added option to invalidate data when Vld low
  * In psi_tb_compare_pkg added overloading StdlCompare (sl/sl) function

## 2.4.1

* Bugfixes
  * Corrected response checking in *psi\_tb\_axi\_pkg*
* Added Features
  * None

## 2.4.0

* Bugfixes
  * None
* Added Features
  * Added continuous integration scripts
  * Added *psi\_tb\_activity\_pkg.WaitForClockCycles()* and *psi\_tb\_activity\_pkg.ClockedWaitTime()*
  * Added more features to *psi\_tb\_i2c\_pkg*

## 2.3.0

* Bugfixes
  * None
* Added Features
  * Added *psi\_tb\_i2c\_pkg* to easily test I2C interfaces

## 2.2.5

* Bugfixes
  * Fixed bug in *psi\_tb\_activity\_pkg.GenerateStrobe()* - Reset was sampled only once when the procedure was called, so usually it was stuck in reset. This bug was introduced in 2.2.0.

## 2.2.4

* Bugfixes
  * Remove non-generic content from WaitForValueXXX() procedures
  * Fixed AXI protocol violation in *psi\_tb\_axi\_pkg.axi\_apply\_wd\_burst()* - *wvalid* depended on *wread* if throttling was used

## 2.2.3

* Bugfixes
  * Added conversions from *to* to *downto* for std\_logic\_vector constants because they are *to* by default

## 2.2.2

* Bugfixes
  * Internal cleanup work not visible to outside

## 2.2.1

* Bugfixes
  * Fixed WaitForValueXXX() procedures in psi\_tb\_activity\_pkg
  * Added burst modes to psi\_tb\_axi\_kpkg

## 2.2.0

* Added Features
  * Added WaitForValueXXX() methods to psi\_tb\_activity\_pkg
  * Added Signed/Unsigned compare functions to psi\_tb\_compare\_pkg

## 2.1.0

* Added Features
  * Added compare procedure for time in psi\_tb\_compare\_pkg

## 2.0.0

* First open source release (older history not kept)
* Changes (not reverse compatible)
  * Renamed procedures in psi\_tb\_textfile\_pkg for consistency
  * Changed data format of psi\_tb\_textfile\_pkg to integer in order to support GHDL

## 1.3.0

* Added Features
  * Added stobe generator procedure to psi\_tb\_activity\_pkg
  * Added RealCompare function to psi\_tb\_compare\_pkg
* Bugfixes
  * None

## 1.2.0

* Added Features
  * Added compare function for std\_logic to psi\_tb\_compare\_pkg
  * Added compare function for integers to psi\_tb\_compare\_pkg
  * Added psi\_tb\_activity\_pkg (checking and stimulating signal activity)
  * Added file writing capability to psi\_tb\_textfile\_pkg
* Bugfixes
  * Printing for in std\_logic\_vector compare functions did not work correctly if TO was used (and not DOWNTO)

## 1.1.1

* Added Features
  * None
* Bugfixes
  * Removed non-ASCII characters that are not tolerated by GHDL

## 1.1.0

* Added Features
  * Added conversion package between synthesis AXI definition and TB AXI definition (psi\_tb\_axi\_conv\_pkg.vhd)
  * Added package to automatically apply and check signal agains textfiles (required for bittrue TBs). For details, refer to the examples in psi\_fix (psi\_fix\_dds\_18b\_tb, psi\_fix\_lin\_approx\_sin18b\_tb).
* Bugfixes
  * None

## V1.01

* Added Features
  * Added compare functions with propper message output
* Bugfixes
  * None

## V1.00
* First release
