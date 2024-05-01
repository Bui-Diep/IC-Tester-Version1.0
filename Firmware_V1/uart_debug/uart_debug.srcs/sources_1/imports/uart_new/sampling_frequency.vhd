-- sampling_frequency.vhd
library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity sampling_frequency is -- chuong trinh tao xung tick
  generic (
    constant F : INTEGER := 1000 -- F out
  );
  port (
    ckht      : in  STD_LOGIC;
    rst       : in  STD_LOGIC;
    cnt_in    : in  STD_LOGIC;
    ena_pulse : out STD_LOGIC -- tan so ngo ra
  );
end entity;

architecture Behavioral of sampling_frequency is
  constant N : INTEGER := 50000000; -- F xung he thong

  signal D1MHZ_R : INTEGER range 0 to N / F := 1;
  signal D1MHZ_N : INTEGER range 0 to N / F := 1;

  signal q_r : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
  signal q_n : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

  signal ena_pulse_t : STD_LOGIC;
begin
  process (ckht, rst, q_r)
  begin
    if rst = '1' then
      q_r <= (others => '0');
      q_n <= (others => '0');
    elsif falling_edge(ckht) then
      q_r <= q_n;
    end if;

    if rst = '1' then
      q_n <= (others => '0');
    elsif q_r = 10 then
      q_n <= "1010";
    elsif cnt_in = '1' then
      q_n <= q_r + 1;
    else
      q_n <= q_r;
    end if;
  end process;

  --REGISTER
  process (ckht)
  begin
    if FALLING_EDGE(ckht) then
      D1MHZ_R <= D1MHZ_N;
    end if;
  end process;
  --NEXT STATE LOGIC	
  D1MHZ_N <= 1 when D1MHZ_R = N / F else
             D1MHZ_R + 1;
  ena_pulse_t <= '1' when D1MHZ_R = N /(F * 2) else
                 '0';
  ena_pulse <= ena_pulse_t when q_r = 10 else
               '0';

end architecture;
