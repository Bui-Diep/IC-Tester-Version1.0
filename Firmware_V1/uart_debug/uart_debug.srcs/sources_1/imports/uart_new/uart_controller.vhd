----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:02:45 10/23/2008 
-- Design Name: 
-- Module Name:    uart - Behavioral 
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity uart_controller is
  generic (
    d_bit    : integer := 8;
    sb_tick  : integer := 16;
    dvsr     : integer := 163;
    dvsr_bit : integer := 9;
    fifo_w   : integer := 2);

  port (ckht             : in  std_logic;
        rst              : in  std_logic;

        uart_rx          : in  std_logic;
        uart_tx          : out std_logic;

        fifo_rx_ena_rd   : in  std_logic;
        fifo_rx_data_out : out std_logic_vector(7 downto 0);
        fifo_rx_empty    : out std_logic;

        fifo_tx_ena_wr   : in  std_logic;
        fifo_tx_data_in  : in  std_logic_vector(7 downto 0);
        fifo_tx_full     : out std_logic;

		fifo_rx_wr      : inout std_logic
       );
end entity;

architecture behavioral of uart_controller is
  signal s_tick          : std_logic;
  signal fifo_rx_data_in : std_logic_vector(7 downto 0);


  signal fifo_tx_data_out : std_logic_vector(7 downto 0);
  signal fifo_tx_rd       : std_logic;
  signal fifo_tx_empty    : std_logic;

begin

  U0: entity work.baud_rate_generator(arch) generic map (
    m => dvsr,
    n => dvsr_bit) port map (
    ckht => ckht,
    rst  => rst,
    tick => s_tick);

  U1: entity work.uart_controller_rx(arch) generic map (
    d_bit   => d_bit,
    sb_tick => sb_tick) port map (
    ckht         => ckht,
    rst          => rst,
    s_tick       => s_tick,
    rx           => uart_rx,         --th nhan dl	

    rx_data      => fifo_rx_data_in, --dl dua den fifo
    rx_done_tick => fifo_rx_wr); --th dk fifo luu dl

  U2: entity work.fifo_rx(arch) generic map (
    b => d_bit,
    w => fifo_w) port map (
    ckht    => ckht,
    rst     => rst,

    wr_data => fifo_rx_data_in,  --dl luu vao fifo
    wr      => fifo_rx_wr,       --th dk fifo luu dl

    rd      => fifo_rx_ena_rd,   --th dk doc dl ve
    rd_data => fifo_rx_data_out, --nhan dl ve 						
    empty   => fifo_rx_empty);

  U3: entity work.uart_controller_tx(arch) generic map (
    d_bit   => d_bit,
    sb_tick => sb_tick) port map (
    ckht          => ckht,
    rst           => rst,
    s_tick        => s_tick,

    tx            => uart_tx,
    tx_data       => fifo_tx_data_out, --dl lay tu fifo de goi di

    tx_done_tick  => fifo_tx_rd,       --dk fifo de lay dl 
    tx_fifo_empty => fifo_tx_empty
  ); --ktra fifo neu co dl thi phat

  U4: entity work.fifo_tx(arch) generic map (
    b => d_bit,
    w => fifo_w) port map (
    ckht    => ckht,
    rst     => rst,

    rd      => fifo_tx_rd,       --th dk doc dl
    rd_data => fifo_tx_data_out, --xuat dl den b phat
    empty   => fifo_tx_empty,    --dua tt den bo phat uart_tx

    wr      => fifo_tx_ena_wr,   --dk nhan dl
    wr_data => fifo_tx_data_in,  --nhan dl  							
    full    => fifo_tx_full); --tt day dl	

end architecture;

