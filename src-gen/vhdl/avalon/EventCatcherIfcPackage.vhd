-- Copyright (C) 2024 Eccelerators GmbH
-- 
-- This code was generated by:
--
-- HxS Compiler v0.0.0-0000000
-- VHDL Extension for HxS 1.0.21-b962bd24
-- 
-- Further information at https://eccelerators.com/hxs
-- 
-- Changes to this file may cause incorrect behavior and will be lost if the
-- code is regenerated.
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

package EventCatcherIfcPackage is

	type T_EventCatcherIfcAvalonDown is
	record
		Address : std_logic_vector(3 downto 0);
		ByteEnable : std_logic_vector(3 downto 0);
		Write : std_logic;
		WriteData : std_logic_vector(31 downto 0);
		Read : std_logic;
	end record;
	
	type T_EventCatcherIfcAvalonUp is
	record
		ReadData : std_logic_vector(31 downto 0);
		WaitRequest : std_logic;
	end record;
	
	type T_EventCatcherIfcTrace is
	record
		AvalonDown : T_EventCatcherIfcAvalonDown;
		AvalonUp : T_EventCatcherIfcAvalonUp;
		UnoccupiedAck : std_logic;
		TimeoutAck : std_logic;
	end record;
	
	type T_EventCatcherIfcEventCatcherBlkDown is
	record
		Mask : std_logic_vector(3 downto 0);
		CatchWritten : std_logic_vector(3 downto 0);
		OverrunWritten : std_logic_vector(3 downto 0);
		WTransPulseEventCatchReg : std_logic;
		WTransPulseEventOverrunReg : std_logic;
	end record;
	
	type T_EventCatcherIfcEventCatcherBlkUp is
	record
		CatchToBeRead : std_logic_vector(3 downto 0);
		OverrunToBeRead : std_logic_vector(3 downto 0);
	end record;
	
	constant EVENTCATCHERBLK_BASE_ADDRESS : std_logic_vector(3 downto 0) := x"0";
	constant EVENTCATCHERBLK_SIZE : std_logic_vector(3 downto 0) := x"C";
	
	constant EVENTMASKREG_WIDTH : integer := 32;
	constant EVENTMASKREG_ADDRESS : std_logic_vector(3 downto 0) := std_logic_vector(x"0" + unsigned(EVENTCATCHERBLK_BASE_ADDRESS));
	
	constant MASK_POSITION : integer := 0;
	constant MASK_WIDTH : integer := 4;
	constant MASK_MASK : std_logic_vector(31 downto 0) := x"0000000F";
	constant EVENTENABLED : std_logic_vector(3 downto 0) := x"1";
	constant EVENTDISABLED : std_logic_vector(3 downto 0) := x"0";
	
	constant EVENTCATCHREG_WIDTH : integer := 32;
	constant EVENTCATCHREG_ADDRESS : std_logic_vector(3 downto 0) := std_logic_vector(x"4" + unsigned(EVENTCATCHERBLK_BASE_ADDRESS));
	
	constant CATCH_POSITION : integer := 0;
	constant CATCH_WIDTH : integer := 4;
	constant CATCH_MASK : std_logic_vector(31 downto 0) := x"0000000F";
	constant CATCHED : std_logic_vector(3 downto 0) := x"1";
	constant NOTCATCHED : std_logic_vector(3 downto 0) := x"0";
	constant CATCH_CONFIRMED : std_logic_vector(3 downto 0) := x"1";
	constant CATCH_INEFFECTIVE : std_logic_vector(3 downto 0) := x"0";
	
	constant EVENTOVERRUNREG_WIDTH : integer := 32;
	constant EVENTOVERRUNREG_ADDRESS : std_logic_vector(3 downto 0) := std_logic_vector(x"8" + unsigned(EVENTCATCHERBLK_BASE_ADDRESS));
	
	constant OVERRUN_POSITION : integer := 0;
	constant OVERRUN_WIDTH : integer := 4;
	constant OVERRUN_MASK : std_logic_vector(31 downto 0) := x"0000000F";
	constant HAPPENED : std_logic_vector(3 downto 0) := x"1";
	constant NOTHAPPENED : std_logic_vector(3 downto 0) := x"0";
	constant OVERRUN_CONFIRMED : std_logic_vector(3 downto 0) := x"1";
	constant OVERRUN_INEFFECTIVE : std_logic_vector(3 downto 0) := x"0";
	
	constant ASYNC_INIT : std_logic_vector(3 downto 0) := x"0";
	
end;
