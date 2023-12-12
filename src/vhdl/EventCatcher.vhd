-- ******************************************************************************
-- 
--                   /------o
--             eccelerators
--          o------/
-- 
--  This file is an Eccelerators GmbH sample project.
-- 
--  MIT License:
--  Copyright (c) 2023 Eccelerators GmbH
-- 
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- 
--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
-- 
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.
-- ******************************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.EventCatcherIfcPackage.all;

entity EventCatcher is
    generic (
        BIT_WIDTH : positive := 1
    );
    port (
        Clk : in std_logic;
        Rst : in std_logic;
        EventPuls : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        EventCatch : out std_logic_vector(BIT_WIDTH - 1 downto 0);
        Mask : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        CatchWritten : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        WTransPulseEventCatchReg : in std_logic;
        CatchToBeRead : out std_logic_vector(BIT_WIDTH - 1 downto 0);
        OverrunWritten : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        WTransPulseEventOverrunReg : in std_logic;
        OverrunToBeRead : out std_logic_vector(BIT_WIDTH - 1 downto 0)
    );
end entity;

architecture RTL of EventCatcher is
    
    signal Catch : std_logic_vector(BIT_WIDTH - 1 downto 0);
    signal Overrun : std_logic_vector(BIT_WIDTH - 1 downto 0);

begin

    EventCatch <= Mask and Catch;
    CatchToBeRead <= Catch;
    OverrunToBeRead <= Overrun;
    
    prcCatch : process ( Clk, Rst) is
    begin
        if Rst then
            Catch <= (others => '0');
        elsif rising_edge(Clk) then
            for i in 0 to BIT_WIDTH - 1 loop
                if EventPuls(i) then
                    Catch(i) <= '1';
                elsif CatchWritten(i) and WTransPulseEventCatchReg then
                    Catch(i) <= '0';
                end if;
            end loop;
        end if;  
    end process;
    
    prcOverrun : process ( Clk, Rst) is
    begin
        if Rst then
            Overrun <= (others => '0');
        elsif rising_edge(Clk) then
            for i in 0 to BIT_WIDTH - 1 loop
                if OverrunWritten(i) and WTransPulseEventOverrunReg then
                    Overrun(i) <= '0';
                elsif Catch(i) and EventPuls(i) 
                   and not (CatchWritten(i) and WTransPulseEventCatchReg) then
                    Overrun(i) <= '1';
                end if;
            end loop;
        end if;  
    end process;
    
end architecture;
