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

use work.EventCatcherPackage.all;
use work.SpiControllerIfcPackage.all;

entity EventCatcher is
    generic (
        BIT_WIDTH : positive := 1
    );
    port (
        Clk : in std_logic;
        Rst : in std_logic;
        EventPuls : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        EventCaptured : out std_logic_vector(BIT_WIDTH - 1 downto 0);
        Mask : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        CaptureWritten : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        WTransPulseEventCaptureReg : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        CaptureToBeRead : out std_logic_vector(BIT_WIDTH - 1 downto 0);
        OverrunWritten : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        WTransPulseEventOverrunReg : in std_logic_vector(BIT_WIDTH - 1 downto 0);
        OverrunToBeRead : out std_logic_vector(BIT_WIDTH - 1 downto 0)
    );
end entity;

architecture RTL of EventCatcher is
    
    signal Capture : std_logic_vector(BIT_WIDTH - 1 downto 0);
    signal Overrun : std_logic_vector(BIT_WIDTH - 1 downto 0);

begin

    EventCaptured <= Mask and Capture;
    CaptureToBeRead <= Capture;
    OverrunToBeRead <= Overrun;
    
    prcCapture : process ( Clk, Rst) is
    begin
        if Rst then
            Capture <= (others => '0');
        elsif rising_edge(Clk) then
            for i in 0 to BIT_WIDTH'high loop
                if EventPuls(i) then
                    Capture(i) <= '1';
                elsif CaptureWritten(i) and WTransPulseEventCaptureReg then
                    Capture(i) <= '0';
                end if;
            end loop;
        end if;  
    end process;
    
    prcOverrun : process ( Clk, Rst) is
    begin
        if Rst then
            Overrun <= (others => '0');
        elsif rising_edge(Clk) then
            for i in 0 to BIT_WIDTH'high loop
                if Capture(i) and EventPuls(i) then
                    Overrun  <= '1';
                elsif OverrunWritten(i) and WTransPulseEventOverrunReg then
                    Overrun(i) <= '0';
                end if;
            end loop;
        end if;  
    end process;
    
end architecture;
