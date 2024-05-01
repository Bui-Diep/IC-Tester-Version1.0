library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;

entity delay is
  generic (
    constant t : integer := 10
  );
  port (ckht    : in  std_logic;
        sig_in  : in  std_logic;
        sig_out : out std_logic
       );
end entity;

architecture behavioral of delay is
  signal cnt : integer range 0 to t := t;

begin
  process (ckht, sig_in)
  begin
    if falling_edge(ckht) then
      if sig_in = '0' then
        if cnt = t then
          cnt <= t;
        else
          cnt <= cnt + 1;
        end if;
      elsif sig_in = '1' then
        cnt <= 0;
      end if;
    end if;
  end process;
  sig_out <= '1' when cnt =(t - 1) else '0';
end architecture;
