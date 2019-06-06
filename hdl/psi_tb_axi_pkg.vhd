------------------------------------------------------------------------------
--  Copyright (c) 2017 by Paul Scherrer Institute, Switzerland
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
	use work.psi_common_math_pkg.all;
	use work.psi_tb_compare_pkg.all;
	use work.psi_tb_txt_util.all;

------------------------------------------------------------------------------
-- Package Header
------------------------------------------------------------------------------
package psi_tb_axi_pkg is

	constant xRESP_OKAY_c 		: std_logic_vector(1 downto 0) 		:= "00";
	constant xRESP_EXOKAY_c 	: std_logic_vector(1 downto 0) 		:= "01";
	constant xRESP_SLVERR_c 	: std_logic_vector(1 downto 0) 		:= "10";
	constant xRESP_DECERR_c 	: std_logic_vector(1 downto 0) 		:= "11";
	
	constant xBURST_FIXED_c 	: std_logic_vector(1 downto 0) 		:= "00";
	constant xBURST_INCR_c 		: std_logic_vector(1 downto 0) 		:= "01";
	constant xBURST_WRAP_c 		: std_logic_vector(1 downto 0) 		:= "10";
	
	constant AxSIZE_1_c			: std_logic_vector(2 downto 0)		:= "000";
	constant AxSIZE_2_c			: std_logic_vector(2 downto 0)		:= "001";
	constant AxSIZE_4_c			: std_logic_vector(2 downto 0)		:= "010";
	constant AxSIZE_8_c			: std_logic_vector(2 downto 0)		:= "011";
	constant AxSIZE_16_c		: std_logic_vector(2 downto 0)		:= "100";
	constant AxSIZE_32_c		: std_logic_vector(2 downto 0)		:= "101";
	constant AxSIZE_64_c		: std_logic_vector(2 downto 0)		:= "110";
	constant AxSIZE_128_c		: std_logic_vector(2 downto 0)		:= "111";
	
	type axi_ms_r is record
		-- Read address channel			                             
		arid                : std_logic_vector;     						-- Read address ID. This signal is the identification tag for the read address group of signals.
		araddr              : std_logic_vector;     						-- Read address. This signal indicates the initial address of a read burst transaction.
		arlen               : std_logic_vector(7 downto 0);                 -- Burst length. The burst length gives the exact number of transfers in a burst
		arsize              : std_logic_vector(2 downto 0);                 -- Burst size. This signal indicates the size of each transfer in the burst
		arburst             : std_logic_vector(1 downto 0);                 -- Burst type. The burst type and the size information, determine how the address for each transfer within the burst is calculated.
		arlock              : std_logic;                                    -- Lock type. Provides additional information about the atomic characteristics of the transfer.
		arcache             : std_logic_vector(3 downto 0);                 -- Memory type. This signal indicates how transactions are required to progress through a system.
		arprot              : std_logic_vector(2 downto 0);                 -- Protection type. This signal indicates the privilege and security level of the transaction, and whether the transaction is a data access or an instruction access.
		arqos               : std_logic_vector(3 downto 0);                 -- Quality of Service, QoS identifier sent for each read transaction.
		arregion            : std_logic_vector(3 downto 0);                 -- Region identifier. Permits a single physical interface on a slave to be used for multiple logical interfaces.
		aruser              : std_logic_vector;   							-- Optional User-defined signal in the read address channel.
		arvalid             : std_logic;                                    -- Write address valid. This signal indicates that the channel is signaling valid read address and control information.
		-- Read data channel			                             
		rready              : std_logic;                                    -- Read ready. This signal indicates that the master can accept the read data and response information.
		-- Write address channel                                     
		awid                : std_logic_vector;     						-- Write Address ID
		awaddr              : std_logic_vector;     						-- Write address
		awlen               : std_logic_vector(7 downto 0);           		-- Burst length. The burst length gives the exact number of transfers in a burst
		awsize              : std_logic_vector(2 downto 0);           		-- Burst size. This signal indicates the size of each transfer in the burst
		awburst             : std_logic_vector(1 downto 0);           		-- Burst type. The burst type and the size information, determine how the address for each transfer within the burst is calculated.
		awlock              : std_logic;                              		-- Lock type. Provides additional information about the atomic characteristics of the transfer.
		awcache             : std_logic_vector(3 downto 0);           		-- Memory type. This signal indicates how transactions are required to progress through a system.
		awprot              : std_logic_vector(2 downto 0);           		-- Protection type. This signal indicates the privilege and security level of the transaction, and whether the transaction is a data access or an instruction access.
		awqos               : std_logic_vector(3 downto 0);           		-- Quality of Service, QoS identifier sent for each write transaction.
		awregion            : std_logic_vector(3 downto 0);           		-- Region identifier. Permits a single physical interface on a slave to be used for multiple logical interfaces.
		awuser              : std_logic_vector;   							-- Optional User-defined signal in the write address channel.
		awvalid             : std_logic;                              		-- Write address valid. This signal indicates that the channel is signaling valid write address and control information.
		-- Write data channel                                        
		wdata               : std_logic_vector; 							-- Write Data
		wstrb               : std_logic_vector; 							-- Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
		wlast               : std_logic;                              		-- Write last. This signal indicates the last transfer in a write burst.
		wuser               : std_logic_vector;    							-- Optional User-defined signal in the write data channel.
		wvalid              : std_logic;                              		-- Write valid. This signal indicates that valid write data and strobes are available.
		-- Write response channel                                    
		bready              : std_logic;                  
	end record;
	
	type axi_sm_r is record
		-- Read address channel			                             
		arready             : std_logic;                                    -- Read address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
		-- Read data channel			                             
		rid                 : std_logic_vector;       						-- Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
		rdata               : std_logic_vector;     						-- Read Data
		rresp               : std_logic_vector(1 downto 0);                 -- Read response. This signal indicates the status of the read transfer.
		rlast               : std_logic;                                    -- Read last. This signal indicates the last transfer in a read burst.
		ruser               : std_logic_vector;    							-- Optional User-defined signal in the read address channel.
		rvalid              : std_logic;                                    -- Read valid. This signal indicates that the channel is signaling the required read data.
		-- Write address channel                                     
		awready             : std_logic;                              		-- Write address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
		-- Write data channel                                        
		wready              : std_logic;                              		-- Write ready. This signal indicates that the slave can accept the write data.
		-- Write response channel                                    
		bid                 : std_logic_vector;      						-- Response ID tag. This signal is the ID tag of the write response.
		bresp               : std_logic_vector(1 downto 0);           		-- Write response. This signal indicates the status of the write transaction.
		buser               : std_logic_vector;   							-- Optional User-defined signal in the write response channel.
		bvalid              : std_logic;                              		-- Write response valid. This signal indicates that the channel is signaling a valid write response.
	end record;

	-- Initialization
	procedure axi_master_init(signal ms	: out	axi_ms_r);
	
	procedure axi_slave_init(signal sm	: out	axi_sm_r);
	
	-- Full Transactions
	procedure axi_single_write(	address 	: in	integer;
								value		: in	integer;
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal clk	: in	std_logic);
								
	procedure axi_single_read(	address 	: in	integer;
								value		: out	integer;
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal clk	: in	std_logic;
								msb			: in	natural := 31;
								lsb			: in	natural := 0;
								sex			: in	boolean := false);
								
	procedure axi_single_expect(address 	: in	integer;
								value		: in	integer;
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal clk	: in	std_logic;
								name		: in	string := "No Msg";
								msb			: in	natural := 31;
								lsb			: in	natural := 0;
								sex			: in	boolean := false;
								tol			: in	natural := 0);
								
	-- Partial Transactions
	procedure axi_apply_aw(	AxAddr		: in	integer;
							AxSize		: in	std_logic_vector(2 downto 0);
							AxLen		: in	integer;
							AxBurst		: in	std_logic_vector(1 downto 0);
							signal ms	: out	axi_ms_r;
							signal sm	: in	axi_sm_r;
							signal aclk	: in	std_logic);
							
	procedure axi_apply_ar(	AxAddr		: in	integer;
							AxSize		: in	std_logic_vector(2 downto 0);
							AxLen		: in	integer;
							AxBurst		: in	std_logic_vector(1 downto 0);
							signal ms	: out	axi_ms_r;
							signal sm	: in	axi_sm_r;
							signal aclk	: in	std_logic);							
							
	procedure axi_apply_wd_single(	Data			: in	std_logic_vector;
									Wstrb 			: in	std_logic_vector;
									signal ms		: out	axi_ms_r;
									signal sm		: in	axi_sm_r;
									signal aclk		: in	std_logic);
									
	procedure axi_apply_wd_burst(	Beats		: in 	natural;
									DataStart	: in	natural;
									DataIncr	: in	natural;
									WstrbFirst 	: in	std_logic_vector;
									WstrbLast 	: in	std_logic_vector;
									signal ms	: out	axi_ms_r;
									signal sm	: in	axi_sm_r;
									signal aclk	: in	std_logic;
									VldLowCycles	: in	integer		:= 0);
									
	procedure axi_expect_aw(	AxAddr		: in	integer;
								AxSize		: in	std_logic_vector(2 downto 0);
								AxLen		: in	integer;
								AxBurst		: in	std_logic_vector(1 downto 0);
								signal ms	: in	axi_ms_r;
								signal sm	: out	axi_sm_r;
								signal aclk	: in	std_logic);
								
	procedure axi_expect_ar(	AxAddr		: in	integer;
								AxSize		: in	std_logic_vector(2 downto 0);
								AxLen		: in	integer;
								AxBurst		: in	std_logic_vector(1 downto 0);
								signal ms	: in	axi_ms_r;
								signal sm	: out	axi_sm_r;
								signal aclk	: in	std_logic);								
								
	procedure axi_expect_wd_single(	Data		: in	std_logic_vector;
									Wstrb 		: in	std_logic_vector;
									signal ms	: in	axi_ms_r;
									signal sm	: out	axi_sm_r;
									signal aclk	: in	std_logic);
									
	procedure axi_expect_wd_burst(	Beats		: in 	natural;
									DataStart	: in	natural;
									DataIncr	: in	natural;
									WstrbFirst 	: in	std_logic_vector;
									WstrbLast 	: in	std_logic_vector;
									signal ms	: in	axi_ms_r;
									signal sm	: out	axi_sm_r;
									signal aclk	: in	std_logic;
									RdyLowCycles	: in	integer		:= 0);									
									
	procedure axi_apply_bresp(	Response	: in std_logic_vector(1 downto 0);
								signal ms	: in	axi_ms_r;
								signal sm	: out	axi_sm_r;
								signal aclk	: in	std_logic);
								
	procedure axi_expect_bresp(	Response	: in std_logic_vector(1 downto 0);
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal aclk	: in	std_logic);
								
	procedure axi_apply_rresp_single(	Data		: in	std_logic_vector;
										Response	: in std_logic_vector(1 downto 0);
										signal ms	: in	axi_ms_r;
										signal sm	: out	axi_sm_r;
										signal aclk	: in	std_logic);
										
	procedure axi_apply_rresp_burst(	Beats		: in 	natural;
										DataStart	: in	natural;
										DataIncr	: in	natural;
										Response	: in 	std_logic_vector(1 downto 0);
										signal ms	: in	axi_ms_r;
										signal sm	: out	axi_sm_r;
										signal aclk	: in	std_logic;
										VldLowCycles	: in	integer		:= 0);
										
	procedure axi_expect_rresp_single(	Data				: in	std_logic_vector;
										Response			: in 	std_logic_vector(1 downto 0);
										signal ms			: out	axi_ms_r;
										signal sm			: in	axi_sm_r;
										signal aclk			: in	std_logic;
										IgnoreData			: in	boolean := false;
										IgnoreResponse		: in	boolean := false);
										
	procedure axi_expect_rresp_burst(	Beats				: in 	natural;
										DataStart			: in	natural;
										DataIncr			: in	natural;
										Response			: in 	std_logic_vector(1 downto 0);
										signal ms			: out	axi_ms_r;
										signal sm			: in	axi_sm_r;
										signal aclk			: in	std_logic;
										IgnoreData			: in	boolean := false;
										IgnoreResponse		: in	boolean := false;
										RdyLowCycles		: in	integer		:= 0);
	
end psi_tb_axi_pkg;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body psi_tb_axi_pkg is

	procedure axi_master_init(signal ms	: out	axi_ms_r) is
	begin
		ms.awid 		<= std_logic_vector(to_unsigned(0, ms.awid'length));  
		ms.awaddr  		<= std_logic_vector(to_unsigned(0, ms.awaddr'length));
		ms.awlen   		<= (others => '0');
		ms.awsize  		<= std_logic_vector(to_unsigned(0, ms.awsize'length));
		ms.awburst 		<= "01";
		ms.awvalid 		<= '0';
		ms.awlock  		<= '0';
		ms.awcache 		<= (others => '0');
		ms.awprot  		<= (others => '0');
		ms.awqos   		<= (others => '0');
		ms.awregion		<= (others => '0');
		ms.awuser  		<= std_logic_vector(to_unsigned(0, ms.awuser'length));	
		ms.arid         <= std_logic_vector(to_unsigned(0, ms.arid'length));
		ms.araddr       <= std_logic_vector(to_unsigned(0, ms.araddr'length));
		ms.arlen        <= std_logic_vector(to_unsigned(0, ms.arlen'length));
		ms.arsize       <= std_logic_vector(to_unsigned(0, ms.arsize'length));
		ms.arburst      <= std_logic_vector(to_unsigned(0, ms.arburst'length));
		ms.arlock       <= '0';
		ms.arcache      <= std_logic_vector(to_unsigned(0, ms.arcache'length));
		ms.arprot       <= std_logic_vector(to_unsigned(0, ms.arprot'length));
		ms.arqos        <= std_logic_vector(to_unsigned(0, ms.arqos'length));
		ms.arregion     <= std_logic_vector(to_unsigned(0, ms.arregion'length));
		ms.aruser       <= std_logic_vector(to_unsigned(0, ms.aruser'length));
		ms.arvalid      <= '0'; 
		ms.rready		<= '0';                                 
		ms.wdata        <= std_logic_vector(to_unsigned(0, ms.wdata'length));
		ms.wstrb        <= std_logic_vector(to_unsigned(0, ms.wstrb'length));
		ms.wlast        <= '0';
		ms.wuser        <= std_logic_vector(to_unsigned(0, ms.wuser'length));
		ms.wvalid       <= '0';                                  
		ms.bready       <= '0';     
	end procedure;
	
	procedure axi_slave_init(signal sm	: out	axi_sm_r) is
	begin	                             
		sm.arready     	<= '0';		                             
		sm.rid         	<= std_logic_vector(to_unsigned(0, sm.rid'length));  
		sm.rdata		<= std_logic_vector(to_unsigned(0, sm.rdata'length));  
		sm.rresp        <= "00";
		sm.rlast        <= '0';
		sm.ruser        <= std_logic_vector(to_unsigned(0, sm.ruser'length));
		sm.rvalid       <= '0';                                 
		sm.awready      <= '0';                                      
		sm.wready       <= '0';
		sm.bid          <= std_logic_vector(to_unsigned(0, sm.bid'length)); 
		sm.bresp        <= "00";
		sm.buser        <= std_logic_vector(to_unsigned(0, sm.buser'length)); 
		sm.bvalid       <= '0';	
	end procedure;

	procedure axi_single_write(	address 	: in	integer;
								value		: in	integer;
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal clk	: in	std_logic) is
	begin
		-- synchronize
		wait until rising_edge(clk);
		-- Signal write
		ms.awid 		<= std_logic_vector(to_unsigned(0, ms.awid'length));  
		ms.awaddr  		<= std_logic_vector(to_unsigned(address, ms.awaddr'length));
		ms.awlen   		<= (others => '0');
		ms.awsize  		<= std_logic_vector(to_unsigned(log2(ms.wdata'length/8), ms.awsize'length));
		ms.awburst 		<= "01";
		ms.awvalid 		<= '1';
		-- wait for address accepted
		wait until rising_edge(clk) and sm.awready = '1';
		ms.awvalid 		<= '0';
		ms.wdata		<= std_logic_vector(to_signed(value, ms.wdata'length));
		ms.wstrb		<= std_logic_vector(to_signed(-1, ms.wstrb'length));
		ms.wlast		<= '1';
		ms.wvalid		<= '1';
		-- wait for data accepted
		wait until rising_edge(clk) and sm.wready = '1';
		ms.wlast		<= '0';
		ms.wvalid		<= '0';
		ms.bready       <= '1';  
		-- wait for response
		wait until rising_edge(clk) and sm.bvalid = '1';
		ms.bready       <= '0';  
		StdlvCompareStdlv(xRESP_OKAY_c, sm.bresp, "axi_single_write(): received negative response!");
	end procedure;
	
	procedure axi_single_read(	address 	: in	integer;
								value		: out	integer;
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal clk	: in	std_logic;
								msb			: in	natural := 31;
								lsb			: in	natural := 0;
								sex			: in	boolean := false) is
		variable valueStdlv 	:	std_logic_vector(31 downto 0);	
	begin
		-- synchronize
		wait until rising_edge(clk);
		-- Signal write
		ms.arid 		<= std_logic_vector(to_unsigned(0, ms.awid'length));  
		ms.araddr  		<= std_logic_vector(to_unsigned(address, ms.awaddr'length));
		ms.arlen   		<= (others => '0');
		ms.arsize  		<= std_logic_vector(to_unsigned(log2(ms.wdata'length/8), ms.awsize'length));
		ms.arburst 		<= "01";
		ms.arvalid 		<= '1';
		-- wait for address accepted
		wait until rising_edge(clk) and sm.arready = '1';
		ms.arvalid 		<= '0';
		ms.rready		<= '1';
		-- wait for data transmitted
		wait until rising_edge(clk) and sm.rvalid = '1';	
		ms.rready		<= '0';
		-- Mask and correctly shift value
		valueStdlv := sm.rdata;
		valueStdlv(msb-lsb downto 0) := valueStdlv(msb downto lsb);
		if sex then
			valueStdlv(31 downto msb-lsb+1) := (others => valueStdlv(msb));
		else
			valueStdlv(31 downto msb-lsb+1) := (others => '0');
		end if;
		value := to_integer(signed(valueStdlv));
		StdlvCompareStdlv(xRESP_OKAY_c, sm.rresp, "axi_single_read(): received negative response!");
	end procedure;
	
	procedure axi_single_expect(address 	: in	integer;
								value		: in	integer;
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal clk	: in	std_logic;
								name		: in	string := "No Msg";
								msb			: in	natural := 31;
								lsb			: in	natural := 0;
								sex			: in	boolean := false;
								tol			: in	natural := 0) is
		variable val : integer;
		variable valuePos_v : integer;
		variable valPos_v : integer;
	begin	
		axi_single_read(address, val, ms, sm, clk, msb, lsb, sex);
		IntCompare(value, val, "axi_single_expect() received unexpected result - " & name, tol);
	end procedure;
	
	procedure axi_apply_aw(	AxAddr		: in	integer;
							AxSize		: in	std_logic_vector(2 downto 0);
							AxLen		: in	integer;
							AxBurst		: in	std_logic_vector(1 downto 0);
							signal ms	: out	axi_ms_r;
							signal sm	: in	axi_sm_r;
							signal aclk	: in	std_logic) is
	begin
		ms.awaddr 	<= std_logic_vector(to_unsigned(AxAddr, ms.awaddr'length));
		ms.awvalid 	<= '1';
		ms.awlen	<= std_logic_vector(to_unsigned(AxLen, ms.awlen'length));
		ms.awburst 	<= AxBurst;
		ms.awsize	<= AxSize;
		wait until rising_edge(aclk) and sm.awready = '1';
		axi_master_init(ms);	
	end procedure;	
	
	procedure axi_apply_ar(	AxAddr		: in	integer;
							AxSize		: in	std_logic_vector(2 downto 0);
							AxLen		: in	integer;
							AxBurst		: in	std_logic_vector(1 downto 0);
							signal ms	: out	axi_ms_r;
							signal sm	: in	axi_sm_r;
							signal aclk	: in	std_logic) is
	begin
		ms.araddr 	<= std_logic_vector(to_unsigned(AxAddr, ms.awaddr'length));
		ms.arvalid 	<= '1';
		ms.arlen	<= std_logic_vector(to_unsigned(AxLen, ms.awlen'length));
		ms.arburst 	<= AxBurst;
		ms.arsize	<= AxSize;
		wait until rising_edge(aclk) and sm.arready = '1';
		axi_master_init(ms);	
	end procedure;		

	procedure axi_apply_wd_single(	Data		: in	std_logic_vector;
									Wstrb 		: in	std_logic_vector;
									signal ms	: out	axi_ms_r;
									signal sm	: in	axi_sm_r;
									signal aclk	: in	std_logic) is
	begin							
		ms.wdata <= Data;
		ms.wlast <= '1';
		ms.wvalid <= '1';
		ms.wstrb <= Wstrb;		
		wait until rising_edge(aclk) and sm.wready = '1';
		axi_master_init(ms);
	end procedure;
	
	procedure axi_apply_wd_burst(	Beats		: in 	natural;
									DataStart	: in	natural;
									DataIncr	: in	natural;
									WstrbFirst 	: in	std_logic_vector;
									WstrbLast 	: in	std_logic_vector;
									signal ms	: out	axi_ms_r;
									signal sm	: in	axi_sm_r;
									signal aclk	: in	std_logic;
									VldLowCycles	: in	integer		:= 0) is
		variable DataCnt_v		: natural;
		variable DataStdlv_v	: std_logic_vector(ms.wdata'range);
	begin		
		ms.wvalid 	<= '1';	
		DataCnt_v := DataStart;
		for beat in 1 to Beats loop	
			-- last transfer
			if beat = Beats then
				ms.wlast <= '1';
				ms.wstrb <= WstrbLast;	
			elsif beat = 1 then
				ms.wstrb <= WstrbFirst;
			else
				ms.wstrb <= std_logic_vector(to_signed(-1, ms.wstrb'length));
			end if;
			-- Apply Data
			DataStdlv_v := std_logic_vector(to_unsigned(DataCnt_v, DataStdlv_v'length));
			ms.wdata <= DataStdlv_v;			
			wait until rising_edge(aclk) and sm.wready = '1';
			DataCnt_v := DataCnt_v + DataIncr;
			-- Low cycles if required
			if not (beat = Beats) then
				for lc in 1 to VldLowCycles loop
					ms.wvalid <= '0';
					wait until rising_edge(aclk) and sm.wready = '1';
				end loop;
				ms.wvalid <= '1';
			end if;
		end loop;
		axi_master_init(ms);
	end procedure;
	
	procedure axi_expect_aw(	AxAddr		: in	integer;
								AxSize		: in	std_logic_vector(2 downto 0);
								AxLen		: in	integer;
								AxBurst		: in	std_logic_vector(1 downto 0);
								signal ms	: in	axi_ms_r;
								signal sm	: out	axi_sm_r;
								signal aclk	: in	std_logic) is
	begin
		sm.awready <= '1';
		wait until rising_edge(aclk) and ms.awvalid = '1';
		StdlvCompareInt(AxAddr, ms.awaddr, "wrong AWADDR", false);
		StdlvCompareStdlv(AxSize, ms.awsize, "wrong AWSIZE");
		StdlvCompareInt(AxLen, ms.awlen, "wrong AWLEN", false);
		StdlvCompareStdlv(AxBurst, ms.awburst, "wrong AWBURST");
		sm.awready <= '0';
	end procedure;
	
	procedure axi_expect_ar(	AxAddr		: in	integer;
								AxSize		: in	std_logic_vector(2 downto 0);
								AxLen		: in	integer;
								AxBurst		: in	std_logic_vector(1 downto 0);
								signal ms	: in	axi_ms_r;
								signal sm	: out	axi_sm_r;
								signal aclk	: in	std_logic) is
	begin
		sm.arready <= '1';
		wait until rising_edge(aclk) and ms.arvalid = '1';
		StdlvCompareInt(AxAddr, ms.araddr, "wrong ARADDR", false);
		StdlvCompareStdlv(AxSize, ms.arsize, "wrong ARSIZE");
		StdlvCompareInt(AxLen, ms.arlen, "wrong ARLEN", false);
		StdlvCompareStdlv(AxBurst, ms.arburst, "wrong ARBURST");
		sm.arready <= '0';
	end procedure;	
	
	procedure axi_expect_wd_single(	Data		: in	std_logic_vector;
									Wstrb 		: in	std_logic_vector;
									signal ms	: in	axi_ms_r;
									signal sm	: out	axi_sm_r;
									signal aclk	: in	std_logic) is
	begin
		sm.wready <= '1';
		wait until rising_edge(aclk) and ms.wvalid = '1';
		for byte in 0 to ms.wdata'length/8-1 loop
			-- only check data that is used
			if ms.wstrb(byte) = '1' then
				StdlvCompareStdlv(Data(byte*8-1 downto byte*8), ms.wdata(byte*8-1 downto byte*8), "wrong WDATA - byte " & str(byte));
			end if;
		end loop;
		StdlvCompareStdlv(Wstrb, ms.wstrb, "wrong WSTRB");
		StdlCompare(1, ms.wlast, "wrong WLAST");
		sm.wready <= '0';
	end procedure;
	
	procedure axi_expect_wd_burst(	Beats		: in 	natural;
									DataStart	: in	natural;
									DataIncr	: in	natural;
									WstrbFirst 	: in	std_logic_vector;
									WstrbLast 	: in	std_logic_vector;
									signal ms	: in	axi_ms_r;
									signal sm	: out	axi_sm_r;
									signal aclk	: in	std_logic;
									RdyLowCycles	: in	integer		:= 0) is
		variable DataCnt_v		: natural;
		variable DataStdlv_v	: std_logic_vector(ms.wdata'range);									
	begin
		sm.wready <= '1';
		DataCnt_v := DataStart;
		for beat in 1 to Beats loop	
			wait until rising_edge(aclk) and ms.wvalid = '1';
			-- last transfer
			if beat = Beats then
				StdlCompare(1, ms.wlast, "WLAST not asserted at end of burst transfer");
				StdlvCompareStdlv(WstrbLast, ms.wstrb, "wrong WSTRB at end of burst transfer");
			elsif beat = 1 then
				StdlCompare(0, ms.wlast, "WLAST asserted at beginning of burst transfer");
				StdlvCompareStdlv(WstrbFirst, ms.wstrb, "wrong WSTRB at beginning of burst transfer");
			else
				StdlCompare(0, ms.wlast, "WLAST asserted in the middle of burst transfer");
				StdlvCompareInt (-1, ms.wstrb, "wrong WSTRB in the middle of burst transfer");
			end if;
			-- Apply Data
			DataStdlv_v := std_logic_vector(to_unsigned(DataCnt_v, DataStdlv_v'length));	
			for byte in 0 to ms.wdata'length/8-1 loop
				-- only check data that is used
				if ms.wstrb(byte) = '1' then
					StdlvCompareStdlv(DataStdlv_v(byte*8-1 downto byte*8), ms.wdata(byte*8-1 downto byte*8), "wrong WDATA during butst transfer - byte " & str(byte));
				end if;
			end loop;			
			DataCnt_v := DataCnt_v + DataIncr;	
			-- Low cycles if required
			if not (beat = Beats) then
				for lc in 1 to RdyLowCycles loop
					sm.wready <= '0';
					wait until rising_edge(aclk) and ms.wvalid  = '1';
				end loop;
				sm.wready <= '1';
			end if;			
		end loop;
		sm.wready <= '0';
	end procedure;
	
	procedure axi_apply_bresp(	Response	: in 	std_logic_vector(1 downto 0);
								signal ms	: in	axi_ms_r;
								signal sm	: out	axi_sm_r;
								signal aclk	: in	std_logic) is
	begin
		sm.bvalid <= '1';
		sm.bresp <= Response;
		wait until rising_edge(aclk) and ms.bready = '1';
		axi_slave_init(sm);
	end procedure;
	
	procedure axi_expect_bresp(	Response	: in 	std_logic_vector(1 downto 0);
								signal ms	: out	axi_ms_r;
								signal sm	: in	axi_sm_r;
								signal aclk	: in	std_logic) is
	begin
		ms.bready <= '1';
		wait until rising_edge(aclk) and sm.bvalid = '1';
		StdlvCompareStdlv(Response, sm.bresp, "wrong BRESP");		
		ms.bready <= '0';
	end procedure;
	
	procedure axi_apply_rresp_single(	Data		: in	std_logic_vector;
										Response	: in 	std_logic_vector(1 downto 0);
										signal ms	: in	axi_ms_r;
										signal sm	: out	axi_sm_r;
										signal aclk	: in	std_logic) is
	begin
		sm.rvalid <= '1';
		sm.rdata <= Data;
		sm.rresp <= Response;
		sm.rlast <= '1';
		wait until rising_edge(aclk) and ms.rready = '1';
		axi_slave_init(sm);
	end procedure;
	
	procedure axi_apply_rresp_burst(	Beats		: in 	natural;
										DataStart	: in	natural;
										DataIncr	: in	natural;
										Response	: in 	std_logic_vector(1 downto 0);
										signal ms	: in	axi_ms_r;
										signal sm	: out	axi_sm_r;
										signal aclk	: in	std_logic;
										VldLowCycles	: in	integer		:= 0) is
		variable DataCnt_v		: natural;
		variable DataStdlv_v	: std_logic_vector(ms.wdata'range);
	begin		
		sm.rvalid 	<= '1';	
		sm.rlast 	<= '0';
		DataCnt_v := DataStart;
		sm.rresp <= Response;
		for beat in 1 to Beats loop	
			-- last transfer
			if beat = Beats then
				sm.rlast <= '1';
			end if;
			-- Apply Data
			DataStdlv_v := std_logic_vector(to_unsigned(DataCnt_v, DataStdlv_v'length));
			sm.rdata <= DataStdlv_v;			
			wait until rising_edge(aclk) and ms.rready = '1';
			DataCnt_v := DataCnt_v + DataIncr;
			-- Low cycles if required
			if not (beat = Beats) then
				for lc in 1 to VldLowCycles loop
					sm.rvalid <= '0';
					wait until rising_edge(aclk) and ms.rready = '1';
				end loop;
				sm.rvalid <= '1';
			end if;
		end loop;
		axi_slave_init(sm);
	end procedure;	
	
	procedure axi_expect_rresp_single(	Data			: in	std_logic_vector;
										Response		: in 	std_logic_vector(1 downto 0);
										signal ms		: out	axi_ms_r;
										signal sm		: in	axi_sm_r;
										signal aclk		: in	std_logic;
										IgnoreData		: in	boolean := false;
										IgnoreResponse	: in	boolean := false) is
	begin
		ms.rready <= '1';
		wait until rising_edge(aclk) and sm.rvalid = '1';
		if not IgnoreResponse then
			StdlvCompareStdlv(Response, sm.rresp, "wrong BRESP");	
		end if;
		if not IgnoreData then
			StdlvCompareStdlv(Data, sm.rdata, "wrong RDATA");
		end if;
		StdlCompare(1, sm.rlast, "wrong RLAST");
		ms.rready <= '0';
	end procedure;	
	
	procedure axi_expect_rresp_burst(	Beats			: in 	natural;
										DataStart		: in	natural;
										DataIncr		: in	natural;
										Response		: in 	std_logic_vector(1 downto 0);
										signal ms		: out	axi_ms_r;
										signal sm		: in	axi_sm_r;
										signal aclk		: in	std_logic;
										IgnoreData		: in	boolean := false;
										IgnoreResponse	: in	boolean := false;
										RdyLowCycles	: in	integer		:= 0) is
		variable DataCnt_v		: natural;
		variable DataStdlv_v	: std_logic_vector(ms.wdata'range);
	begin		
		ms.rready <= '1';
		DataCnt_v := DataStart;
		for beat in 1 to Beats loop	
			wait until rising_edge(aclk) and sm.rvalid = '1';
			-- last transfer
			if beat = Beats then
				StdlCompare(1, sm.rlast, "wrong RLAST");
			else
				StdlCompare(0, sm.rlast, "wrong RLAST");
			end if;
			-- Check Data
			if not IgnoreResponse then
				StdlvCompareStdlv(Response, sm.rresp, "wrong BRESP");	
			end if;
			DataStdlv_v := std_logic_vector(to_unsigned(DataCnt_v, DataStdlv_v'length));
			if not IgnoreData then
				StdlvCompareStdlv(DataStdlv_v, sm.rdata, "wrong RDATA");
			end if;				
			DataCnt_v := DataCnt_v + DataIncr;
			-- Low cycles if required
			if not (beat = Beats) then
				for lc in 1 to RdyLowCycles loop
					ms.rready <= '0';
					wait until rising_edge(aclk) and sm.rvalid = '1';
				end loop;
				ms.rready <= '1';
			end if;
		end loop;
		ms.rready <= '0';
	end procedure;	
	
end psi_tb_axi_pkg;

