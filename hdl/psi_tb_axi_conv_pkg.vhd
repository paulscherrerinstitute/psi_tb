------------------------------------------------------------------------------
--  Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

-- This package implementes the conversions between the synthesis-friendly
-- AXI package from psi_common and the testbench friendly AXI package from
-- psi_tb. 
-- This is done in a separate package to avoid everbody using the TB AXI package
-- from having to also include the synthesis AXI package.

------------------------------------------------------------------------------
-- Libraries
------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.psi_tb_axi_pkg.all;
	use work.psi_common_axi_pkg.all;

------------------------------------------------------------------------------
-- Package Header
------------------------------------------------------------------------------
package psi_tb_axi_conv_pkg is
								
	-- Conversion between TB AXI package and synthesis AXI pkg for master side
	procedure axi_conv_tb_synth_master(	signal tb_ms	: in	axi_ms_r;
										signal tb_sm	: out	axi_sm_r;
										signal syn_ms	: out	axi_slv_inp;
										signal syn_sm	: in	axi_slv_oup);
	
end package;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body psi_tb_axi_conv_pkg is
	
	procedure axi_conv_tb_synth_master(	signal tb_ms	: in	axi_ms_r;
										signal tb_sm	: out	axi_sm_r;
										signal syn_ms	: out	axi_slv_inp;
										signal syn_sm	: in	axi_slv_oup) is
	begin
		-- master -> slave
		syn_ms.ar.id 		<= tb_ms.arid;
		syn_ms.ar.addr		<= tb_ms.araddr;
		syn_ms.ar.len 		<= tb_ms.arlen;
		syn_ms.ar.size 		<= tb_ms.arsize;
		syn_ms.ar.burst		<= tb_ms.arburst;
		syn_ms.ar.lock		<= tb_ms.arlock;
		syn_ms.ar.cache		<= tb_ms.arcache;
		syn_ms.ar.prot		<= tb_ms.arprot;
		syn_ms.ar.qos		<= tb_ms.arqos;
		syn_ms.ar.region	<= tb_ms.arregion;
		syn_ms.ar.user		<= tb_ms.aruser;
		syn_ms.ar.valid		<= tb_ms.arvalid;
		syn_ms.dr.ready		<= tb_ms.rready;
		syn_ms.aw.id		<= tb_ms.awid;
		syn_ms.aw.addr		<= tb_ms.awaddr;
		syn_ms.aw.len		<= tb_ms.awlen;
		syn_ms.aw.size		<= tb_ms.awsize;
		syn_ms.aw.burst		<= tb_ms.awburst;
		syn_ms.aw.lock		<= tb_ms.awlock;
		syn_ms.aw.cache		<= tb_ms.awcache;
		syn_ms.aw.prot		<= tb_ms.awprot;
		syn_ms.aw.qos		<= tb_ms.awqos;
		syn_ms.aw.region	<= tb_ms.awregion;
		syn_ms.aw.user		<= tb_ms.awuser;
		syn_ms.aw.valid		<= tb_ms.awvalid;
		syn_ms.dw.data		<= tb_ms.wdata;
		syn_ms.dw.strb		<= tb_ms.wstrb;
		syn_ms.dw.last		<= tb_ms.wlast;
		syn_ms.dw.user		<= tb_ms.wuser;
		syn_ms.dw.valid		<= tb_ms.wvalid;
		syn_ms.b.ready		<= tb_ms.bready;		
		-- slave -> master
		tb_sm.arready		<= syn_sm.ar.ready;
		tb_sm.rid			<= syn_sm.dr.id;
		tb_sm.rdata			<= syn_sm.dr.data;
		tb_sm.rresp			<= syn_sm.dr.resp;
		tb_sm.rlast			<= syn_sm.dr.last;
		tb_sm.ruser			<= syn_sm.dr.user;
		tb_sm.rvalid		<= syn_sm.dr.valid;
		tb_sm.awready		<= syn_sm.aw.ready;
		tb_sm.wready		<= syn_sm.dw.ready;
		tb_sm.bid			<= syn_sm.b.id;
		tb_sm.bresp			<= syn_sm.b.resp;
		tb_sm.buser			<= syn_sm.b.user;
		tb_sm.bvalid		<= syn_sm.b.valid;		
	end procedure;

	
end;

