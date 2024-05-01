----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:05:19 09/09/2022 
-- Design Name: 
-- Module Name:    gui_fifo_tx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
  use IEEE.STD_LOGIC_1164.all;

  -- Uncomment the following library declaration if using
  -- arithmetic functions with Signed or Unsigned values
  --use IEEE.NUMERIC_STD.ALL;
  -- Uncomment the following library declaration if instantiating
  -- any Xilinx primitives in this code.
  --library UNISIM;
  --use UNISIM.VComponents.all;

entity gui_fifo_tx is
  port (
    ena_db       : in  std_logic;
    data_in      : in  std_logic_vector(7 downto 0);

    uart_tx_full : in  std_logic;
    uart_tx_data : out std_logic_vector(7 downto 0);
    uart_tx_ena  : out std_logic);
end entity;

architecture Behavioral of gui_fifo_tx is

begin
  process (uart_tx_full, ena_db, data_in)
  begin
    uart_tx_data <= data_in; -- gan dl goi di
    if uart_tx_full = '0' then
      uart_tx_ena <= ena_db; -- tao xung phat
    else
      uart_tx_ena <= '0';
    end if;
  end process;

end architecture;

