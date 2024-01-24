--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: AND20.vhd
-- File history:
--      20150930:15.00: Start version
--
-- Description:
--
-- And a 20 ingressi
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: Baldus
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity AND20 is
port (
	A : in  std_logic; -- 01
	B : in  std_logic; -- 02
	C : in  std_logic; -- 03
	D : in  std_logic; -- 04
	E : in  std_logic; -- 05
	F : in  std_logic; -- 06
	G : in  std_logic; -- 07
	H : in  std_logic; -- 08
	I : in  std_logic; -- 09
	J : in  std_logic; -- 10
	K : in  std_logic; -- 11
	L : in  std_logic; -- 12
	M : in  std_logic; -- 13
	N : in  std_logic; -- 14
	O : in  std_logic; -- 15
	P : in  std_logic; -- 16
	Q : in  std_logic; -- 17
	R : in  std_logic; -- 18
	S : in  std_logic; -- 19
	T : in  std_logic; -- 20
	Y : out std_logic);-- output
end AND20;
architecture AND20_arch of AND20 is
begin
	Y_handler : process(A, B, C, D, E,
	                    F, G, H, I, J,
	                    K, L, M, N, O,
	                    P, Q, R, S, T)
	begin
		Y <= A and B and C and D and E and
             F and G and H and I and J and
             K and L and M and N and O and
             P and Q and R and S and T;
	end process;
end AND20_arch;
