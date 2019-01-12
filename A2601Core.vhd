-- A2601 Main Core
-- Copyright 2006, 2010 Retromaster
--
--  This file is part of A2601.
--
--  A2601 is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License,
--  or any later version.
--
--  A2601 is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with A2601.  If not, see <http://www.gnu.org/licenses/>.
--

library ieee;
use ieee.std_logic_1164.all;

entity A2601 is
	port(
		clk_vid: in std_logic;
		clk: in std_logic;
		rst: in std_logic;
		d: inout std_logic_vector(7 downto 0);
		a: out std_logic_vector(12 downto 0);
		r: out std_logic;
		pa: inout std_logic_vector(7 downto 0);
		pb: inout std_logic_vector(7 downto 0);
		paddle_0: in std_logic_vector(7 downto 0);
		paddle_1: in std_logic_vector(7 downto 0);
		paddle_ena1: in std_logic;
		paddle_2: in std_logic_vector(7 downto 0);
		paddle_3: in std_logic_vector(7 downto 0);
		paddle_ena2: in std_logic;
		inpt4: in std_logic;
		inpt5: in std_logic;
		colu: out std_logic_vector(6 downto 0);
		vsyn: out std_logic;
		hsyn: out std_logic;
		hblank: out std_logic;
		vblank: out std_logic;
		rgbx2: out std_logic_vector(23 downto 0);
		au0: out std_logic;
		au1: out std_logic;
		av0: out std_logic_vector(3 downto 0);
		av1: out std_logic_vector(3 downto 0);
		ph0_out: out std_logic;
		ph2_out: out std_logic;
		pal: in std_logic
	);
end A2601;

architecture arch of A2601 is
    signal rdy: std_logic;
    signal cpu_a: std_logic_vector(12 downto 0);
    signal read: std_logic;
    signal riot_rs: std_logic;
    signal riot_cs: std_logic;
    signal riot_irq: std_logic;
    signal riot_pa7: std_logic;
    signal riot_a: std_logic_vector(6 downto 0);
    signal tia_cs: std_logic;
    signal tia_a: std_logic_vector(5 downto 0);
    signal ph0: std_logic;
    signal ph2: std_logic;
begin

    ph0_out <= ph0;
    ph2_out <= ph2;

    r <= read;

    cpu_A6507: work.A6507
        port map(ph0, rst, rdy, d, cpu_a, read);

    riot_A6532: work.A6532
        port map(clk, ph2, read, riot_rs, riot_cs,
            open, d, pa, pb, '0', riot_a);

    tia_inst: work.TIA
        port map(clk_vid, clk, tia_cs, read, tia_a, d,
            colu, hsyn, vsyn, hblank, vblank, rgbx2, rdy, ph0, ph2,
            au0, au1, av0, av1,
				paddle_0, paddle_1, paddle_ena1, 
				paddle_2, paddle_3, paddle_ena2,
				inpt4, inpt5,
				pal);

    tia_cs <= '1' when (cpu_a(12) = '0') and (cpu_a(7) = '0') else '0';
    riot_cs <= '1' when (cpu_a(12) = '0') and (cpu_a(7) = '1') else '0';
    riot_rs <= '1' when (cpu_a(9) = '1') else '0';

    tia_a <= cpu_a(5 downto 0);
    riot_a <= cpu_a(6 downto 0);

    a <= cpu_a;

end arch;

