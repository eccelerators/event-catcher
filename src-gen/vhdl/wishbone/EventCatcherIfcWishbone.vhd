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

use work.EventCatcherIfcPackage.all;

entity EventCatcherBlk_EventCatcherIfc is
	port (
		Clk : in std_logic;
		Rst : in std_logic;
		Adr : in std_logic_vector(3 downto 0);
		Sel : in std_logic_vector(3 downto 0);
		DatIn : in std_logic_vector(31 downto 0);
		We : in std_logic;
		Stb : in std_logic;
		Cyc : in  std_logic;
		DatOut : out std_logic_vector(31 downto 0);
		Ack : out std_logic;
		Match : out std_logic;
		Mask : out std_logic_vector(3 downto 0);
		CatchToBeRead : in std_logic_vector(3 downto 0);
		CatchWritten : out std_logic_vector(3 downto 0);
		WTransPulseEventCatchReg : out std_logic;
		OverrunToBeRead : in std_logic_vector(3 downto 0);
		OverrunWritten : out std_logic_vector(3 downto 0);
		WTransPulseEventOverrunReg : out std_logic
	);
end;

architecture Behavioural of EventCatcherBlk_EventCatcherIfc is

	signal PreDatOut : std_logic_vector(31 downto 0);
	
	signal PreDatOutEventMaskReg : std_logic_vector(31 downto 0);
	signal PreReadAckEventMaskReg : std_logic;
	signal ReadDiffEventMaskReg : std_logic;
	signal PreWriteAckEventMaskReg : std_logic;
	signal WriteDiffEventMaskReg : std_logic;
	signal WRegMask : std_logic_vector(3 downto 0);
	signal PreMatchReadEventMaskReg : std_logic;
	signal PreMatchWriteEventMaskReg : std_logic;
	
	signal PreDatOutEventCatchReg : std_logic_vector(31 downto 0);
	signal PreReadAckEventCatchReg : std_logic;
	signal ReadDiffEventCatchReg : std_logic;
	signal PreWriteAckEventCatchReg : std_logic;
	signal WriteDiffEventCatchReg : std_logic;
	signal PreMatchReadEventCatchReg : std_logic;
	signal PreMatchWriteEventCatchReg : std_logic;
	
	signal PreDatOutEventOverrunReg : std_logic_vector(31 downto 0);
	signal PreReadAckEventOverrunReg : std_logic;
	signal ReadDiffEventOverrunReg : std_logic;
	signal PreWriteAckEventOverrunReg : std_logic;
	signal WriteDiffEventOverrunReg : std_logic;
	signal PreMatchReadEventOverrunReg : std_logic;
	signal PreMatchWriteEventOverrunReg : std_logic;

begin

	DatOut <= PreDatOut;
	
	Match <= PreMatchReadEventMaskReg or PreMatchWriteEventMaskReg
		  or PreMatchReadEventCatchReg or PreMatchWriteEventCatchReg
		  or PreMatchReadEventOverrunReg or PreMatchWriteEventOverrunReg;
	
	Ack <= PreReadAckEventMaskReg or PreWriteAckEventMaskReg
		or PreReadAckEventCatchReg or PreWriteAckEventCatchReg
		or PreReadAckEventOverrunReg or PreWriteAckEventOverrunReg;
	
	PreDatOutMux: process (
		PreDatOutEventMaskReg,
		PreMatchReadEventMaskReg,
		PreReadAckEventMaskReg,
		PreDatOutEventCatchReg,
		PreMatchReadEventCatchReg,
		PreReadAckEventCatchReg,
		PreDatOutEventOverrunReg,
		PreMatchReadEventOverrunReg,
		PreReadAckEventOverrunReg
	) begin
		PreDatOut <= (others => '0');
		if (PreMatchReadEventMaskReg = '1' and PreReadAckEventMaskReg = '1') then
			PreDatOut <= std_logic_vector(resize(unsigned(PreDatOutEventMaskReg), PreDatOut'LENGTH));
		elsif (PreMatchReadEventCatchReg = '1' and PreReadAckEventCatchReg = '1') then
			PreDatOut <= std_logic_vector(resize(unsigned(PreDatOutEventCatchReg), PreDatOut'LENGTH));
		elsif (PreMatchReadEventOverrunReg = '1' and PreReadAckEventOverrunReg = '1') then
			PreDatOut <= std_logic_vector(resize(unsigned(PreDatOutEventOverrunReg), PreDatOut'LENGTH));
		end if;
	end process;
	
	PreMatchReadEventMaskRegProcess : process (Adr, We, Stb, Cyc)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTMASKREG_ADDRESS)) then
			PreMatchReadEventMaskReg <= not We and Stb and Cyc;
		else
			PreMatchReadEventMaskReg <= '0';
		end if;
	end process;
	
	PreMatchWriteEventMaskRegProcess : process (Adr, We, Stb, Cyc)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTMASKREG_ADDRESS)) then
			PreMatchWriteEventMaskReg <= We and Stb and Cyc;
		else
			PreMatchWriteEventMaskReg <= '0';
		end if;
	end process;
	
	WriteDiffEventMaskRegProcess : process (Adr, We, Stb, Cyc, PreWriteAckEventMaskReg)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTMASKREG_ADDRESS)) then
			WriteDiffEventMaskReg <=  We and Stb and Cyc and not PreWriteAckEventMaskReg;
		else
			WriteDiffEventMaskReg <= '0';
		end if;
	end process;
	
	ReadDiffEventMaskRegProcess : process (Adr, We, Stb, Cyc, PreReadAckEventMaskReg)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTMASKREG_ADDRESS)) then
			ReadDiffEventMaskReg <= not We and Stb and Cyc and not PreReadAckEventMaskReg;
		else
			ReadDiffEventMaskReg <= '0';
		end if;
	end process;
	
	SyncPartEventMaskReg : process (Clk, Rst)
	begin
		if (Rst = '1') then
			PreReadAckEventMaskReg <= '0';
			PreWriteAckEventMaskReg <= '0';
			WRegMask <= EVENTENABLED;
		elsif rising_edge(Clk) then
			PreWriteAckEventMaskReg <= WriteDiffEventMaskReg;
			PreReadAckEventMaskReg <= ReadDiffEventMaskReg;
			if (WriteDiffEventMaskReg = '1') then
				if (Sel(0) = '1') then WRegMask(3 downto 0) <= DatIn(3 downto 0); end if;
			end if;
		end if;
	end process;
	
	DataOutPreMuxForEventMaskReg : process (
		WRegMask
	) begin
		PreDatOutEventMaskReg <= (others => '0');
		PreDatOutEventMaskReg(3 downto 0) <= WRegMask;
	end process;
	
	Mask <= WRegMask;
	
	PreMatchReadEventCatchRegProcess : process (Adr, We, Stb, Cyc)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTCATCHREG_ADDRESS)) then
			PreMatchReadEventCatchReg <= not We and Stb and Cyc;
		else
			PreMatchReadEventCatchReg <= '0';
		end if;
	end process;
	
	PreMatchWriteEventCatchRegProcess : process (Adr, We, Stb, Cyc)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTCATCHREG_ADDRESS)) then
			PreMatchWriteEventCatchReg <= We and Stb and Cyc;
		else
			PreMatchWriteEventCatchReg <= '0';
		end if;
	end process;
	
	WriteDiffEventCatchRegProcess : process (Adr, We, Stb, Cyc, PreWriteAckEventCatchReg)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTCATCHREG_ADDRESS)) then
			WriteDiffEventCatchReg <=  We and Stb and Cyc and not PreWriteAckEventCatchReg;
		else
			WriteDiffEventCatchReg <= '0';
		end if;
	end process;
	
	ReadDiffEventCatchRegProcess : process (Adr, We, Stb, Cyc, PreReadAckEventCatchReg)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTCATCHREG_ADDRESS)) then
			ReadDiffEventCatchReg <= not We and Stb and Cyc and not PreReadAckEventCatchReg;
		else
			ReadDiffEventCatchReg <= '0';
		end if;
	end process;
	
	SyncPartEventCatchReg : process (Clk, Rst)
	begin
		if (Rst = '1') then
			PreReadAckEventCatchReg <= '0';
			PreWriteAckEventCatchReg <= '0';
		elsif rising_edge(Clk) then
			PreWriteAckEventCatchReg <= WriteDiffEventCatchReg;
			PreReadAckEventCatchReg <= ReadDiffEventCatchReg;
		end if;
	end process;
	
	DataOutPreMuxForEventCatchReg : process (
		CatchToBeRead
	) begin
		PreDatOutEventCatchReg <= (others => '0');
		PreDatOutEventCatchReg(3 downto 0) <= CatchToBeRead;
	end process;
	
	WTransPulseEventCatchReg <= WriteDiffEventCatchReg;
	
	CatchWritten <= DatIn(3 downto 0);
	
	PreMatchReadEventOverrunRegProcess : process (Adr, We, Stb, Cyc)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTOVERRUNREG_ADDRESS)) then
			PreMatchReadEventOverrunReg <= not We and Stb and Cyc;
		else
			PreMatchReadEventOverrunReg <= '0';
		end if;
	end process;
	
	PreMatchWriteEventOverrunRegProcess : process (Adr, We, Stb, Cyc)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTOVERRUNREG_ADDRESS)) then
			PreMatchWriteEventOverrunReg <= We and Stb and Cyc;
		else
			PreMatchWriteEventOverrunReg <= '0';
		end if;
	end process;
	
	WriteDiffEventOverrunRegProcess : process (Adr, We, Stb, Cyc, PreWriteAckEventOverrunReg)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTOVERRUNREG_ADDRESS)) then
			WriteDiffEventOverrunReg <=  We and Stb and Cyc and not PreWriteAckEventOverrunReg;
		else
			WriteDiffEventOverrunReg <= '0';
		end if;
	end process;
	
	ReadDiffEventOverrunRegProcess : process (Adr, We, Stb, Cyc, PreReadAckEventOverrunReg)
	begin
		if ((unsigned(Adr)/4)*4 = unsigned(EVENTOVERRUNREG_ADDRESS)) then
			ReadDiffEventOverrunReg <= not We and Stb and Cyc and not PreReadAckEventOverrunReg;
		else
			ReadDiffEventOverrunReg <= '0';
		end if;
	end process;
	
	SyncPartEventOverrunReg : process (Clk, Rst)
	begin
		if (Rst = '1') then
			PreReadAckEventOverrunReg <= '0';
			PreWriteAckEventOverrunReg <= '0';
		elsif rising_edge(Clk) then
			PreWriteAckEventOverrunReg <= WriteDiffEventOverrunReg;
			PreReadAckEventOverrunReg <= ReadDiffEventOverrunReg;
		end if;
	end process;
	
	DataOutPreMuxForEventOverrunReg : process (
		OverrunToBeRead
	) begin
		PreDatOutEventOverrunReg <= (others => '0');
		PreDatOutEventOverrunReg(3 downto 0) <= OverrunToBeRead;
	end process;
	
	WTransPulseEventOverrunReg <= WriteDiffEventOverrunReg;
	
	OverrunWritten <= DatIn(3 downto 0);
	
end;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity EventCatcherIfcBusMonitor is
	port (
		Clk : in std_logic;
		Rst : in std_logic;
		Cyc : in  std_logic;
		Match : in std_logic;
		UnoccupiedAck : out std_logic;
		TimeoutAck : out std_logic
	);
end;

architecture Behavioural of EventCatcherIfcBusMonitor is

	signal CycDelay : std_logic;
	signal PreUnoccupiedAck : std_logic;
	signal PreTimeoutAck : std_logic;
	signal TimeoutCounter : unsigned(9 downto 0);

begin

	CycDetection : process (Clk, Rst)
	begin
		if (Rst = '1') then
			CycDelay <= '0';
		elsif rising_edge(Clk) then
			CycDelay <= Cyc;
		end if;
	end process;

	MatchDetection : process (Clk, Rst)
	begin
		if (Rst = '1') then
			PreUnoccupiedAck <= '0';
		elsif rising_edge(Clk) then
			PreUnoccupiedAck <= '0';
			if ((Cyc = '1') and (CycDelay = '1') and (Match = '0')) then
				PreUnoccupiedAck <= not PreUnoccupiedAck;
			end if;
		end if;
	end process;
	
	TimeoutDetection : process (Clk, Rst)
	begin
		if (Rst = '1') then
			PreTimeoutAck <= '0';
			TimeoutCounter <= (others => '1');
		elsif rising_edge(Clk) then
			PreTimeoutAck <= '0';
			TimeoutCounter <= (others => '1');
			if ((Cyc = '1') and (CycDelay = '1') and (Match = '1')) then
				if (TimeoutCounter = 0) then
					PreTimeoutAck <= not PreTimeoutAck;
				else
					TimeoutCounter <= TimeoutCounter - 1;
				end if;
			end if;
		end if;
	end process;

	UnoccupiedAck <= PreUnoccupiedAck;
	TimeoutAck <= PreTimeoutAck;
	
end;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

use work.EventCatcherIfcPackage.all;

entity EventCatcherIfcWishbone is
	port (
		Clk : in std_logic;
		Rst : in std_logic;
		WishboneDown : in T_EventCatcherIfcWishboneDown;
		WishboneUp : out T_EventCatcherIfcWishboneUp;
		Trace : out T_EventCatcherIfcTrace;
		EventCatcherBlkDown : out T_EventCatcherIfcEventCatcherBlkDown;
		EventCatcherBlkUp : in T_EventCatcherIfcEventCatcherBlkUp
	);
end;

architecture Behavioural of EventCatcherIfcWishbone is

	signal BlockMatch : std_logic;
	signal UnoccupiedAck : std_logic;
	signal TimeoutAck : std_logic;
	
	signal PreWishboneUp : T_EventCatcherIfcWishboneUp;
	
	signal EventCatcherBlkDatOut : std_logic_vector(31 downto 0);
	signal EventCatcherBlkAck : std_logic;
	signal EventCatcherBlkMatch : std_logic;

begin

	i_EventCatcherIfcBusMonitor : entity work.EventCatcherIfcBusMonitor
		port map (
			Clk => Clk,
			Rst => Rst,
			Cyc => WishboneDown.Cyc,
			Match => BlockMatch,
			UnoccupiedAck => UnoccupiedAck,
			TimeoutAck => TimeoutAck
		);
	
	i_EventCatcherBlk_EventCatcherIfc : entity work.EventCatcherBlk_EventCatcherIfc
		port map (
			Clk => Clk,
			Rst => Rst,
			Adr => WishboneDown.Adr,
			Sel => WishboneDown.Sel,
			DatIn => WishboneDown.DatIn,
			We =>  WishboneDown.We,
			Stb => WishboneDown.Stb,
			Cyc => WishboneDown.Cyc,
			DatOut => EventCatcherBlkDatOut,
			Ack => EventCatcherBlkAck,
			Match => EventCatcherBlkMatch,
			Mask => EventCatcherBlkDown.Mask,
			CatchToBeRead => EventCatcherBlkUp.CatchToBeRead,
			CatchWritten => EventCatcherBlkDown.CatchWritten,
			WTransPulseEventCatchReg => EventCatcherBlkDown.WTransPulseEventCatchReg,
			OverrunToBeRead => EventCatcherBlkUp.OverrunToBeRead,
			OverrunWritten => EventCatcherBlkDown.OverrunWritten,
			WTransPulseEventOverrunReg => EventCatcherBlkDown.WTransPulseEventOverrunReg
		);
	
	Trace.WishboneDown <= WishboneDown;
	Trace.WishboneUp <= PreWishboneUp;
	Trace.UnoccupiedAck <= UnoccupiedAck;
	Trace.TimeoutAck <= TimeoutAck;
	
	WishboneUp <= PreWishboneUp;
	
	PreWishboneUp.DatOut <= EventCatcherBlkDatOut;
	
	PreWishboneUp.Ack <= EventCatcherBlkAck
		or UnoccupiedAck 
		or TimeoutAck;
	
	BlockMatch <= EventCatcherBlkMatch;

end;
