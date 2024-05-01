library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity top_com is
  generic (
    d_bit    : integer := 8;   --do rong fifo
    sb_tick  : integer := 16;  --so lan lay mau cua 1 khung  truyen uart
    dvsr     : integer := 163; --he so chia tan cho toc do baud
    dvsr_bit : integer := 9;   --
    fifo_w   : integer := 6;   --so luong thanh ghi trong fifo
    F        : integer := 100; -- tan so doc fifo Hz
    t        : integer := 10;  -- he so delay
    n        : integer := 20   -- so luong chan IC
  );
  port (ckht    : in    std_logic;
        btn_rst : in    std_logic;
        ---------------------------------------------------------------------------
        uart_rx : in    std_logic;
        uart_tx : out   std_logic;
        ---------------------------------------------------------------------------
        rw      : out   std_logic;                    --read & write control
        e       : out   std_logic;                    --enable control
        rs      : out   std_logic;                    --data or command control
        data    : out   std_logic_vector(7 downto 0); --data line
        ---------------------------------------------------------------------------
        button  : in    STD_LOGIC_VECTOR(3 downto 0);
        beep    : out   std_logic;
        debug   : out   std_logic_vector(7 downto 0);
        mode    : inout STD_LOGIC                    := '1';
        ---------------------------------------------------------------------------
        --                pin_ctrl_p_l : out std_logic_vector(1 downto 0):="11";
        --                pin_ctrl_n_l : out std_logic_vector(1 downto 0):="00";
        --                pin_ctrl_p_r : out std_logic_vector(1 downto 0):="11";
        --                pin_ctrl_n_r : out std_logic_vector(1 downto 0):="00";
        -- khai bao chan dieu khien logic cho IC (muc '1'/'0')
        c_p1    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p1    : in    STD_LOGIC;
        c_p2    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p2    : in    STD_LOGIC;
        c_p3    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p3    : in    STD_LOGIC;
        c_p4    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p4    : in    STD_LOGIC;
        c_p5    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p5    : in    STD_LOGIC;
        c_p6    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p6    : in    STD_LOGIC;
        c_p7    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p7    : in    STD_LOGIC;
        c_p8    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p8    : in    STD_LOGIC;
        c_p9    : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p9    : in    STD_LOGIC;
        c_p10   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p10   : in    STD_LOGIC;
        c_p11   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p11   : in    STD_LOGIC;
        c_p12   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p12   : in    STD_LOGIC;
        c_p13   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p13   : in    STD_LOGIC;
        c_p14   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p14   : in    STD_LOGIC;
        c_p15   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p15   : in    STD_LOGIC;
        c_p16   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p16   : in    STD_LOGIC;
        c_p17   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p17   : in    STD_LOGIC;
        c_p18   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p18   : in    STD_LOGIC;
        c_p19   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p19   : in    STD_LOGIC;
        c_p20   : out   STD_LOGIC_VECTOR(1 downto 0) := "01";
        i_p20   : in    STD_LOGIC

       );
end entity;

architecture rtl of top_com is
  signal rst, fifo_rx_ena_rd, fifo_rx_empty, fifo_tx_ena_wr, fifo_tx_full, fifo_rx_wr, ena_rx, ena_db, done, result : std_logic;
  signal fifo_rx_data_out, fifo_tx_data_in, data_trans, debug_t, data_fifo_tx                                       : std_logic_vector(7 downto 0);
  signal button_db                                                                                                  : std_logic_vector(3 downto 0);
  signal check_pin                                                                                                  : std_logic_vector(n downto 1) := (others => '1');

begin

  proc_beep: process (ckht, button_db)
    variable i : integer := 0;
  begin

    rst <= not button_db(0);

    if rising_edge(ckht) then
      if (button_db(3) = '0' or button_db(0) = '0' or result = '0') then
        if i = 1000000 then
          i := 1000000;
          beep <= '1';
        else
          i := i + 1;
          beep <= '0'; --coi bao
        end if;
      else
        i := 0;
        beep <= '1';
      end if;
    end if;
  end process;

  process (button_db)
  begin
    if (falling_edge(button(3))) then
      mode <= not mode;
    end if;
  end process;
  -- debounce_btn_rst_inst: entity work.debounce_btn
  --   port map (
  --     ckht    => ckht,
  --     btn     => not (btn_rst),
  --     db_tick => rst
  --   );
  debounce_btn1_inst: entity work.debounce_btn
    port map (
      ckht    => ckht,
      btn     => button(0),
      db_tick => button_db(0)
    );
  debounce_btn2_inst: entity work.debounce_btn
    port map (
      ckht    => ckht,
      btn     => button(1),
      db_tick => button_db(1)
    );
  debounce_btn3_inst: entity work.debounce_btn
    port map (
      ckht    => ckht,
      btn     => button(2),
      db_tick => button_db(2)
    );
  debounce_btn4_inst: entity work.debounce_btn
    port map (
      ckht    => ckht,
      btn     => button(3),
      db_tick => button_db(3)
    );
  uart_controller_inst: entity work.uart_controller
    generic map (
      d_bit    => d_bit,
      sb_tick  => sb_tick,
      dvsr     => dvsr,
      dvsr_bit => dvsr_bit,
      fifo_w   => fifo_w
    )
    port map (
      ckht             => ckht,
      rst              => rst,
      uart_rx          => uart_rx,
      uart_tx          => uart_tx,
      fifo_rx_ena_rd   => fifo_rx_ena_rd,
      fifo_rx_data_out => fifo_rx_data_out,
      fifo_rx_empty    => fifo_rx_empty,
      fifo_tx_ena_wr   => fifo_tx_ena_wr,
      fifo_tx_data_in  => fifo_tx_data_in,
      fifo_tx_full     => fifo_tx_full,
      fifo_rx_wr       => fifo_rx_wr
    );
  doc_fifo_rx_inst: entity work.doc_fifo_rx
    port map (
      ckht          => ckht,
      rst           => rst,
      ena_rx        => ena_rx,
      uart_rx_empty => fifo_rx_empty,
      uart_rx_data  => fifo_rx_data_out,
      uart_rx_ena   => fifo_rx_ena_rd,
      data_rx       => data_trans
    );
  gui_fifo_tx_inst: entity work.gui_fifo_tx
    port map (
      ena_db       => ena_db,
      data_in      => data_fifo_tx,
      uart_tx_full => fifo_tx_full,
      uart_tx_data => fifo_tx_data_in,
      uart_tx_ena  => fifo_tx_ena_wr
    );
  sampling_frequency_inst: entity work.sampling_frequency
    generic map (
      F => F
    )
    port map (
      ckht      => ckht,
      rst       => '0',
      cnt_in    => fifo_rx_wr,
      ena_pulse => ena_rx
    );
  -- delay_inst: entity work.delay
  --   generic map (
  --     t => t
  --   )
  --   port map (
  --     ckht    => ckht,
  --     sig_in  => fifo_rx_ena_rd,
  --     sig_out => ena_db
  --   );
  encoder_inst: entity work.encoder
    generic map (
      p => n,
      t => 2 * t
    )
    port map (
      ckht      => ckht,
      rst       => rst,
      sig_enc   => done,
      check_pin => check_pin,
      data_out  => data_fifo_tx,
      ena_db    => ena_db
    );
  top_decoder_inst: entity work.top_decoder
    generic map (
      n => n,
      t => t
    )
    port map (
      ckht    => ckht,
      rst     => rst,
      cnt_in  => fifo_rx_ena_rd,
      done    => done,
      data_in => data_trans,
      c_p1    => c_p1,
      c_p2    => c_p2,
      c_p3    => c_p3,
      c_p4    => c_p4,
      c_p5    => c_p5,
      c_p6    => c_p6,
      c_p7    => c_p7,
      c_p8    => c_p8,
      c_p9    => c_p9,
      c_p10   => c_p10,
      c_p11   => c_p11,
      c_p12   => c_p12,
      c_p13   => c_p13,
      c_p14   => c_p14,
      c_p15   => c_p15,
      c_p16   => c_p16,
      c_p17   => c_p17,
      c_p18   => c_p18,
      c_p19   => c_p19,
      c_p20   => c_p20
      -- debug   => debug_t
    );

  checking_inst: entity work.checking
    generic map (
      n => n,
      t => t
    )
    port map (
      ckht       => ckht,
      rst        => rst,
      sig_comp   => done,
      pulse_tirg => fifo_rx_ena_rd,
      i_p(1)     => i_p1,
      i_p(2)     => i_p2,
      i_p(3)     => i_p3,
      i_p(4)     => i_p4,
      i_p(5)     => i_p5,
      i_p(6)     => i_p6,
      i_p(7)     => i_p7,
      i_p(8)     => i_p8,
      i_p(9)     => i_p9,
      i_p(10)    => i_p10,
      i_p(11)    => i_p11,
      i_p(12)    => i_p12,
      i_p(13)    => i_p13,
      i_p(14)    => i_p14,
      i_p(15)    => i_p15,
      i_p(16)    => i_p16,
      i_p(17)    => i_p17,
      i_p(18)    => i_p18,
      i_p(19)    => i_p19,
      i_p(20)    => i_p20,
      data_std   => data_trans,
      result_t   => check_pin,
      result     => result
    );
  --------------------------------------------------------
  lcd_inst: entity work.lcd
    generic map (
      p => n
    )
    port map (
      ckht      => ckht,
      rst       => rst,
      result    => result,
      sig_check => fifo_rx_ena_rd,
      check_pin => check_pin,
      rw        => rw,
      e         => e,
      rs        => rs,
      data      => data
    );
  debug <= (others => '1');

end architecture;

