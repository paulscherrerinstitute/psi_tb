------------------------------------------------------------------------------
--  Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler, Benoit Stef
------------------------------------------------------------------------------

-- This package implements simple reading and writing from and to textfiles
-- as required by many bittrue simulations.
--
-- It is assumed that signal values are given in textfiles as integer values,
-- one column per signal, columns separated by spaces (NOT Commas).
--
-- Example:
-- 117 124 -45
-- 111 -123 88
--
-- Example code for producing such files from python:
-- import numpy as np
-- a = np.linspace(100, 200, 10)
-- b = np.linspace(300, 400, 10)
-- np.savetxt("test.txt", np.column_stack((a, b)), fmt="%i")

------------------------------------------------------------------------------
-- Libraries
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library work;
use work.psi_tb_txt_util.all;

------------------------------------------------------------------------------
-- Package Header
------------------------------------------------------------------------------
package psi_tb_textfile_pkg is

	type TextfileData_t is array (natural range <>) of integer;
	--type TextfileFormat_t is array (natural range <>) of PsiFixFmt_t;
	type TextfileName_t is array (natural range <>) of string;

	-- Signal definitions to pass for constant values or unused signals (signals are not allowed to be left open in procedure declarations)
	signal PsiTextfile_SigOne       : std_logic := '1';
	signal PsiTextfile_SigUnused    : std_logic;
	signal PsiTextfile_SigUnusedVec : std_logic_vector(0 downto 0);
	signal PsiTextfile_SigUnusedData	: TextfileData_t(0 downto 0);

	-- Read a textfile and apply it to signals column by column
	procedure ApplyTextfileContent(signal Clk  : in std_logic;
	                                signal Rdy  : in std_logic; -- Pass PsiTextfile_SigOne if Rdy is not used
	                                signal Vld  : out std_logic;
	                                signal Data : out TextfileData_t;
	                                Filepath    : in string;
	                                ClkPerSpl   : in positive := 1;
	                                MaxLines    : in integer  := -1; -- -1 = infinite, else number of lines
	                                IgnoreLines : in natural  := 0;
									DataOnlyOnVld : in boolean := false);

	-- Read a textfile and compare it column by column to signals
	procedure CheckTextfileContent(signal Clk    : in std_logic;
	                                 signal Rdy    : out std_logic; -- Pass PsiTextfile_SigUnused if Rdy is not used
	                                 signal Vld    : in std_logic;
	                                 signal Data   : in TextfileData_t;
	                                 Filepath      : in string;
	                                 ClkPerSpl     : in positive := 1;
	                                 ErrorPrefix   : in string   := "###ERROR###";
	                                 MaxLines      : in integer  := -1; -- -1 = infinite, else number of lines		
	                                 IgnoreLines   : in natural  := 0;
	                                 Msg           : in string := "None");

	-- write a textfile with header line 1 name of data & second line FixPoint format
	procedure WriteTextfile(signal Clk        : in std_logic;
	                         signal Vld        : in std_logic;
	                         signal Data       : in TextfileData_t;
	                         constant nb_data  : integer;
	                         constant time_sim : boolean   := true;
	                         Name              : in TextfileName_t;
	                         spacer            : in string := " , ";
	                         Filepath          : in string := "/data/processing_data.txt"); --filepath & name

end package;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body psi_tb_textfile_pkg is

	-- Read a textfile and apply it to signals column by column
	procedure ApplyTextfileContent( signal Clk  : in std_logic;
	                                signal Rdy  : in std_logic;
	                                signal Vld  : out std_logic;
	                                signal Data : out TextfileData_t;
	                                Filepath    : in string;
	                                ClkPerSpl   : in positive := 1;
	                                MaxLines    : in integer := -1;
	                                IgnoreLines : in natural := 0;
									DataOnlyOnVld : in boolean := false) is
		file fp         : text;
		variable ln     : line;
		variable Spl    : integer;
		variable lineNr : integer := 1;
	begin
		-- Open File
		file_open(fp, Filepath, read_mode);

		-- Apply input
		wait until rising_edge(Clk);
		while (not endfile(fp)) and ((lineNr <= MaxLines) or (MaxLines < 0)) loop
			-- Ignore header lines if required
			readline(fp, ln);
			if lineNr > IgnoreLines then
				Vld <= '1';
				for idx in 0 to Data'length - 1 loop
					read(ln, Spl);
					Data(idx) <= Spl;
				end loop;
				wait until rising_edge(Clk) and Rdy = '1';
				if ClkPerSpl > 1 then
					if DataOnlyOnVld then
						Data <= (Data'range => 0);
					end if;
					Vld <= '0';
					for i in 0 to ClkPerSpl - 2 loop
						wait until rising_edge(Clk);
					end loop;
				end if;
			end if;
			lineNr := lineNr + 1;
		end loop;
		Vld <= '0';

		-- Close File
		file_close(fp);
	end procedure;

	-- Read a textfile and compare it column by column to signals
	procedure CheckTextfileContent(  signal Clk    : in std_logic;
	                                 signal Rdy    : out std_logic;
	                                 signal Vld    : in std_logic;
	                                 signal Data   : in TextfileData_t;
	                                 Filepath      : in string;
	                                 ClkPerSpl     : in positive := 1;
	                                 ErrorPrefix   : in string := "###ERROR###";
	                                 MaxLines      : in integer := -1;
	                                 IgnoreLines   : in natural := 0;
	                                 Msg           : in string := "None") is
		file fp         : text;
		variable ln     : line;
		variable Spl    : integer;
		variable Sig    : integer;
		variable lineNr : integer := 1;
		variable colNr  : integer := 1;
	begin
		-- Open File
		file_open(fp, Filepath, read_mode);

		-- Check output
		while (not endfile(fp)) and ((lineNr <= MaxLines) or (MaxLines < 0)) loop
			-- Ignore header lines if required		
			readline(fp, ln);
			if lineNr > IgnoreLines then

				-- Wait for sample point
				Rdy <= '1';
				wait until rising_edge(Clk) and Vld = '1';

				-- Check data
				colNr := 0;
				for idx in 0 to Data'length - 1 loop
					read(ln, Spl);
					Sig := Data(idx);
					assert Sig = Spl
					report ErrorPrefix & ": Wrong Sample, Msg=" & Msg & ", line=" & integer'image(lineNr) & " column=" & integer'image(colNr) & LF &
							   " --> Expected " & integer'image(Spl) & " [0x" & hstr(std_logic_vector(to_signed(Spl, 32))) & "]" & LF &
							   " --> Received " & integer'image(Sig) & " [0x" & hstr(std_logic_vector(to_signed(Sig, 32))) & "]" & LF &
							   " --> File " & Filepath
					severity error;
					colNr := colNr + 1;
				end loop;

				-- Wait for next sample before asserting ready
				if ClkPerSpl > 1 then
					Rdy <= '0';
					for i in 0 to ClkPerSpl - 2 loop
						wait until rising_edge(Clk);
					end loop;
				end if;
			end if;

			-- goto next line
			lineNr := lineNr + 1;
		end loop;
		Rdy <= '0';

		-- Close File
		file_close(fp);
	end procedure;

	------------------------------------------------------------------------------
	--TAG 	<=> info: Write to file data to process within Python/Matlab Slv
	--TODO	<=> before procedure was modified to be psi_fix free dependency
	--			this procdure printed out fixed point format at line number 2
	--			and used function PsiFixtoReal to display real number
	--			this procdure may be overloaded in pkg PsiFix later	
	------------------------------------------------------------------------------
	procedure WriteTextfile( signal Clk        : in std_logic;
	                         signal Vld        : in std_logic;
	                         signal Data       : in TextfileData_t;
	                         constant nb_data  : integer;
	                         constant time_sim : boolean := true;
	                         --Fmt               : in TextfileFormat_t;
	                         Name              : in TextfileName_t;
	                         spacer            : in string := " , ";
	                         Filepath          : in string := "/data/processing_data.txt") is
		file fp              : text;
		variable ln          : line;
		variable lineNr      : integer := 1;
		variable file_status : file_open_status := MODE_ERROR;
		constant time_simu	 : string := "time_simulation";
	begin

	while lineNr <= nb_data + 2 loop
		wait until rising_edge(Clk) and Vld = '1';
		if file_status /= OPEN_OK then
			file_open(file_status, fp, Filepath, WRITE_MODE);
		end if;

		if lineNr = 1 then
			if time_sim = false then
				for j in 0 to Data'length - 1 loop
					if j = Data'length - 1 then
						write(ln, Name(j));
					else
						write(ln, Name(j));
						write(ln, spacer);
					end if;
				end loop;
				writeline(fp, ln);
				lineNr := lineNr + 1;
			else
				for j in 0 to Data'length loop
					if j = Data'length then
						write(ln, time_simu);
					else
						write(ln, Name(j));
						write(ln, spacer);
					end if;
				end loop;
				writeline(fp, ln);
				lineNr := lineNr + 1;
			end if;
		else
			if time_sim = false then
				for j in 0 to Data'length - 1 loop
					if j = Data'length - 1 then
						write(ln, work.psi_tb_txt_util.to_string(Data(j)));
					else
						write(ln, work.psi_tb_txt_util.to_string(Data(j)));
						write(ln, spacer);
					end if;
				end loop;
				writeline(fp, ln);
				lineNr := lineNr + 1;
			else
				for j in 0 to Data'length loop
					if j = Data'length then
						write(ln, now);
					else
						write(ln, work.psi_tb_txt_util.to_string(Data(j)));
						write(ln, spacer);
					end if;
				end loop;
				writeline(fp, ln);
				lineNr := lineNr + 1;
			end if;
			end if;
		end loop;
		-- Close File
		file_close(fp);
	end procedure;

end;
