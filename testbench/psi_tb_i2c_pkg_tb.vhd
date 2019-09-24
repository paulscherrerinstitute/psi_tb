------------------------------------------------------------------------------
--  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Libraries
------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.psi_tb_i2c_pkg.all;
	use work.psi_tb_txt_util.all;

------------------------------------------------------------------------------
-- Entity
------------------------------------------------------------------------------
entity psi_tb_i2c_pkg_tb is
end entity;	

------------------------------------------------------------------------------
-- Architecture Declaration
------------------------------------------------------------------------------
architecture sim of psi_tb_i2c_pkg_tb is
	signal scl 	: std_logic := 'H';
	signal sda	: std_logic := 'H';
	
begin
	-- Pullup resistors
	I2cPullup(scl, sda);
	
	-- Master Process
	p_master : process
	begin
		-- Setup
		I2cBusFree(scl, sda);
		I2cSetFrequency(400.0e3);
		wait for 1 us;
		
		-- *** Addressing ***
		print(">> Addressing");
		
		-- Do 7b address cycle without data, ACK, read
		print("Do 7b address cycle without data, ACK, read");
		I2cMasterSendStart(scl, sda, "M: 7b start");
		I2cMasterSendAddr(16#12#, true, scl, sda, "M: 7b address", 7);
		I2cMasterSendStop(scl, sda, "M: 7b stop");
		wait for 10 us;
		
		-- Do 7b address cycle without data, ACK, write
		print("Do 7b address cycle without data, ACK, write");
		I2cMasterSendStart(scl, sda, "M: 7b start");
		I2cMasterSendAddr(16#13#, false, scl, sda, "M: 7b address", 7);
		I2cMasterSendStop(scl, sda, "M: 7b stop");
		wait for 10 us;
		
		-- Do 7b address cycle without data, NACK, read
		print("Do 7b address cycle without data, NACK, read");
		I2cMasterSendStart(scl, sda, "M: 7b start");
		I2cMasterSendAddr(16#12#, true, scl, sda, "M: 7b address", 7, '1');
		I2cMasterSendStop(scl, sda, "M: 7b stop");
		wait for 10 us;
		
		-- Do 10b address cycle without data, ACK, write
		print("Do 10b address cycle without data, ACK, write");
		I2cMasterSendStart(scl, sda, "M: 10b start");
		I2cMasterSendAddr(16#113#, false, scl, sda, "M: 10b address", 10);
		I2cMasterSendStop(scl, sda, "M: 10b stop");
		wait for 10 us;
		
		-- Do 10b address cycle without data, NACK, read
		print("Do 10b address cycle without data, NACK, read");
		I2cMasterSendStart(scl, sda, "M: 10b start");
		I2cMasterSendAddr(16#112#, true, scl, sda, "M: 7b address", 10, '1');
		I2cMasterSendStop(scl, sda, "M: 10b stop");
		wait for 10 us;
		
		-- *** Data Transfers ***
		print(">> Data Transfers");
		
		-- Single Byte Read, ACK
		print("Single Byte Read, ACK");
		I2cMasterSendStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, true, scl, sda, "M: address", 7);
		I2cMasterExpectByte(16#AB#, scl, sda, "M: data-read");
		I2cMasterSendStop(scl, sda, "M: stop");
		wait for 10 us;
		
		-- Single Byte Read, NACK
		print("Single Byte Read, NACK");
		I2cMasterSendStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, true, scl, sda, "M: address", 7);
		I2cMasterExpectByte(16#AB#, scl, sda, "M: data-read", '1');
		I2cMasterSendStop(scl, sda, "M: stop");
		wait for 10 us;
		
		-- Two Byte Read
		print("Two Byte Read");
		I2cMasterSendStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, true, scl, sda, "M: address", 7);
		I2cMasterExpectByte(16#AB#, scl, sda, "M: data-read");
		I2cMasterExpectByte(16#CD#, scl, sda, "M: data-read", '1');
		I2cMasterSendStop(scl, sda, "M: stop");
		wait for 10 us;
		
		-- Single Byte Write, ACK
		print("Single Byte Write, ACK");
		I2cMasterSendStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, false, scl, sda, "M: address", 7);
		I2cMasterSendByte(16#67#, scl, sda, "M: data-write");
		I2cMasterSendStop(scl, sda, "M: stop");
		wait for 10 us;
		
		-- Single Byte Write, NACK
		print("Single Byte Write, NACK");
		I2cMasterSendStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, false, scl, sda, "M: address", 7);
		I2cMasterSendByte(16#67#, scl, sda, "M: data-write", '1');
		I2cMasterSendStop(scl, sda, "M: stop");
		wait for 10 us;
		
		-- Two Byte Write
		print("Two Byte Write");
		I2cMasterSendStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, false, scl, sda, "M: address", 7);
		I2cMasterSendByte(16#67#, scl, sda, "M: data-write");
		I2cMasterSendByte(16#89#, scl, sda, "M: data-write", '1');
		I2cMasterSendStop(scl, sda, "M: stop");
		wait for 10 us;	
		
		-- *** Repeated Start (Mixed Transfer) ***
		print(">> Repeated Start (Mixed Transfer)");	
		
		-- 1 Byte Write, Then 1 Byte Read
		print("1 Byte Write, Then 1 Byte Read");
		I2cMasterSendStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, false, scl, sda, "M: address", 7);
		I2cMasterSendByte(16#67#, scl, sda, "M: data-write");
		I2cMasterSendRepeatedStart(scl, sda, "M: start");
		I2cMasterSendAddr(16#13#, true, scl, sda, "M: address", 7);
		I2cMasterExpectByte(16#89#, scl, sda, "M: data-read", '1');
		I2cMasterSendStop(scl, sda, "M: stop");
		wait for 10 us;
		
		wait;
	end process;
	
	
	-- Slave Process
	p_slave : process
	begin
		-- setup		
		I2cBusFree(scl, sda);
	
		-- *** Addressing ***
		
		-- Do 7b address cycle without data, ACK, read
		I2cSlaveWaitStart(scl, sda, "S: 7b wait start");
		I2cSlaveExpectAddr(16#12#, true, scl, sda, "S: 7b check address", 7);
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Do 7b address cycle without data, ACK, write
		I2cSlaveWaitStart(scl, sda, "S: 7b wait start");
		I2cSlaveExpectAddr(16#13#, false, scl, sda, "S: 7b check address", 7);
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Do 7b address cycle without data, NACK, read
		I2cSlaveWaitStart(scl, sda, "S: 7b wait start");
		I2cSlaveExpectAddr(16#12#, true, scl, sda, "S: 7b check address", 7, '1');
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Do 10b address cycle without data, ACK, write
		I2cSlaveWaitStart(scl, sda, "S: 10b wait start");
		I2cSlaveExpectAddr(16#113#, false, scl, sda, "S: 10b check address", 10);
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Do 10b address cycle without data, NACK, read
		I2cSlaveWaitStart(scl, sda, "S: 10b wait start");
		I2cSlaveExpectAddr(16#112#, true, scl, sda, "S: 10b check address", 10, '1');
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- *** Data Transfers ***
		-- Single Byte Read, ACK
		I2cSlaveWaitStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, true, scl, sda, "S: check address", 7);
		I2cSlaveSendByte(16#AB#, scl, sda, "S: data-read");
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Single Byte Read, NACK
		I2cSlaveWaitStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, true, scl, sda, "S: check address", 7);
		I2cSlaveSendByte(16#AB#, scl, sda, "S: data-read", '1');
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Two Byte Read
		I2cSlaveWaitStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, true, scl, sda, "S: check address", 7);
		I2cSlaveSendByte(16#AB#, scl, sda, "S: data-read");
		I2cSlaveSendByte(16#CD#, scl, sda, "S: data-read", '1');
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Single Byte Write, ACK
		I2cSlaveWaitStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, false, scl, sda, "S: check address", 7);
		I2cSlaveExpectByte(16#67#, scl, sda, "S: data-write");
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Single Byte Write, NACK
		I2cSlaveWaitStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, false, scl, sda, "S: check address", 7);
		I2cSlaveExpectByte(16#67#, scl, sda, "S: data-write", '1');
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		-- Two Byte Write
		I2cSlaveWaitStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, false, scl, sda, "S: check address", 7);
		I2cSlaveExpectByte(16#67#, scl, sda, "S: data-write");
		I2cSlaveExpectByte(16#89#, scl, sda, "S: data-write", '1');
		I2cSlaveWaitStop(scl, sda, "S: wait stop");	

		-- *** Repeated Start (Mixed Transfer) ***
		
		-- 1 Byte Write, Then 1 Byte Read
		I2cSlaveWaitStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, false, scl, sda, "S: check address", 7);
		I2cSlaveExpectByte(16#67#, scl, sda, "S: data-write");
		I2cSlaveWaitRepeatedStart(scl, sda, "S: wait start");
		I2cSlaveExpectAddr(16#13#, true, scl, sda, "S: check address", 7);
		I2cSlaveSendByte(16#89#, scl, sda, "S: data-read", '1');
		I2cSlaveWaitStop(scl, sda, "S: wait stop");
		
		
		wait;
	end process;

	
end sim;

