##############################################################################
#  Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler, Benoit Stef
##############################################################################

#Constants
set LibPath "../.."

#Import psi::sim library
namespace import psi::sim::*

#Set library
add_library psi_tb

#suppress messages
compile_suppress 135,1236,1370
run_suppress 8684,3479,3813,8009,3812

# Library
add_sources $LibPath {
	psi_common/hdl/psi_common_array_pkg.vhd \
	psi_common/hdl/psi_common_math_pkg.vhd \
	psi_common/hdl/psi_common_logic_pkg.vhd \
} -tag lib

# project sources
add_sources "../hdl" {	
	psi_tb_txt_util.vhd \
	psi_tb_compare_pkg.vhd \
	psi_tb_activity_pkg.vhd \
	psi_tb_i2c_pkg.vhd \
} -tag src

# testbenches
add_sources "../testbench" {
	psi_tb_i2c_pkg_tb.vhd \
} -tag tb
	
#TB Runs
create_tb_run "psi_tb_i2c_pkg_tb"
add_tb_run



