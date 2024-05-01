library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_decoder is
  generic (
    n : integer := 20; -- so luong chan IC
    -- F : integer := 2;  -- tan so giai ma lay mau
    t : integer := 10  -- thoi gian tre de chot du lieu
  );
  port (
    ckht    : in  std_logic;
    rst     : in  std_logic;
    cnt_in  : in  std_logic;
    done    : out std_logic                    := '0';
    data_in : in  std_logic_vector(7 downto 0);
    -- chan dieu khien logic cua hang chan ben trai 1/0
    -- pin_ctrl_p_l, pin_ctrl_n_l : out std_logic_vector(1 downto 0);
    -- chan dieu khien logic cua hang chan ben phai 1/0
    -- pin_ctrl_p_r, pin_ctrl_n_r : out std_logic_vector(1 downto 0);
    c_p1    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p2    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p3    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p4    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p5    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p6    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p7    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p8    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p9    : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p10   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p11   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p12   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p13   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p14   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p15   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p16   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p17   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p18   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p19   : out STD_LOGIC_VECTOR(1 downto 0) := "01";
    c_p20   : out STD_LOGIC_VECTOR(1 downto 0) := "01";

    debug   : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of top_decoder is

  type buffer_logic is array (n - 1 downto 0) of std_logic_vector(3 downto 0);
  signal cnt_t                  : integer range 0 to 10 := 0;
  signal pin_state              : buffer_logic          := (others => (others => '0'));
  signal pin_ctrl_p, pin_ctrl_n : std_logic_vector(1 downto 0);
  -- tin hieu dieu khien chan ben trai/phai
  signal pin_ctrl_l, pin_ctrl_r : std_logic_vector(1 downto 0) := (others => '0');

  signal trig_enc, trig_data, trig_pin : std_logic;
begin

  -- sampling_frequency_inst: entity work.sampling_frequency
  --   generic map (
  --     F => F
  --   )
  --   port map (
  --     ckht      => ckht,
  --     rst       => rst,
  --     cnt_in    => cnt_in,
  --     ena_pulse => ena_pulse
  --   );
  delay_inst_trig_enc: entity work.delay
    generic map (
      t => t
    )
    port map (
      ckht    => ckht,
      sig_in  => cnt_in,
      sig_out => trig_enc
    );
  delay_inst_trig_data: entity work.delay
    generic map (
      t => t
    )
    port map (
      ckht    => ckht,
      sig_in  => trig_enc,
      sig_out => trig_data
    );
  delay_inst_trig_pin: entity work.delay
    generic map (
      t => t
    )
    port map (
      ckht    => ckht,
      sig_in  => trig_data,
      sig_out => trig_pin
    );

  decoder_inst: entity work.decoder
    port map (
      data_in    => data_in,
      pin_ctrl_n => pin_ctrl_n,
      pin_ctrl_p => pin_ctrl_p
    );

  read_enc_proc: process (trig_enc)
  begin
    if rising_edge(trig_enc) then
      -- dieu khien logic chan ben trai -p/n
      pin_ctrl_l <= pin_ctrl_p(1) & pin_ctrl_n(1);
      -- dieu khien logic chan ben phai -p/n
      pin_ctrl_r <= pin_ctrl_p(0) & pin_ctrl_n(0);
    end if;
  end process;

  trig_data_proc: process (rst, trig_data, cnt_t)
  begin
    if rst = '1' then
      pin_state <= (others => (others => '0'));
    elsif rising_edge(trig_data) then
      pin_state(cnt_t)(3 downto 0) <= pin_ctrl_l(1 downto 0) & pin_ctrl_r(1 downto 0);
    end if;
  end process;

  trig_pin_proc: process (ckht, rst, trig_pin)
  begin
    if rst = '1' then
      cnt_t <= 0;
      c_p1 <= "01";
      c_p2 <= "01";
      c_p3 <= "01";
      c_p4 <= "01";
      c_p5 <= "01";
      c_p6 <= "01";
      c_p7 <= "01";
      c_p8 <= "01";
      c_p9 <= "01";
      c_p10 <= "01";
      c_p11 <= "01";
      c_p12 <= "01";
      c_p13 <= "01";
      c_p14 <= "01";
      c_p15 <= "01";
      c_p16 <= "01";
      c_p17 <= "01";
      c_p18 <= "01";
      c_p19 <= "01";
      c_p20 <= "01";
    elsif rising_edge(trig_pin) then
      if cnt_t = 9 then

        -- chot tin hieu cac chan ben trai
        c_p1(1) <= pin_state(0)(3); --chan dieu khien logic '1'
        c_p1(0) <= pin_state(0)(2); --chan dieu khien logic '0'
        c_p2(1 downto 0) <= pin_state(1)(3 downto 2);
        c_p3(1 downto 0) <= pin_state(2)(3 downto 2);
        c_p4(1 downto 0) <= pin_state(3)(3 downto 2);
        c_p5(1 downto 0) <= pin_state(4)(3 downto 2);
        c_p6(1 downto 0) <= pin_state(5)(3 downto 2);
        c_p7(1 downto 0) <= pin_state(6)(3 downto 2);
        c_p8(1 downto 0) <= pin_state(7)(3 downto 2);
        c_p9(1 downto 0) <= pin_state(8)(3 downto 2);
        c_p10(1 downto 0) <= pin_state(9)(3 downto 2);

        -- chot tin hieu cac chan ben phai
        c_p20(1 downto 0) <= pin_state(0)(1 downto 0);
        c_p19(1 downto 0) <= pin_state(1)(1 downto 0);
        c_p18(1 downto 0) <= pin_state(2)(1 downto 0);
        c_p17(1 downto 0) <= pin_state(3)(1 downto 0);
        c_p16(1 downto 0) <= pin_state(4)(1 downto 0);
        c_p15(1 downto 0) <= pin_state(5)(1 downto 0);
        c_p14(1 downto 0) <= pin_state(6)(1 downto 0);
        c_p13(1 downto 0) <= pin_state(7)(1 downto 0);
        c_p12(1 downto 0) <= pin_state(8)(1 downto 0);
        c_p11(1 downto 0) <= pin_state(9)(1 downto 0);

        -- pin_ctrl_n_l(0) <= pin_state(0)(3);
        -- pin_ctrl_p_l(0) <= pin_state(0)(2);
        -- pin_ctrl_n_r(0) <= pin_state(0)(1);
        -- pin_ctrl_p_r(0) <= pin_state(0)(0);
        -- pin_ctrl_n_l(1) <= pin_state(1)(3);
        -- pin_ctrl_p_l(1) <= pin_state(1)(2);
        -- pin_ctrl_n_r(1) <= pin_state(1)(1);
        -- pin_ctrl_p_r(1) <= pin_state(1)(0);
        debug(0) <= pin_state(0)(3);
        debug(1) <= pin_state(0)(2);
        debug(2) <= pin_state(0)(1);
        debug(3) <= pin_state(0)(0);
        debug(4) <= pin_state(1)(3);
        debug(5) <= pin_state(1)(2);
        debug(6) <= pin_state(1)(1);
        debug(7) <= pin_state(1)(0);
        cnt_t <= 0;
      else
        cnt_t <= cnt_t + 1;
      end if;
    end if;
  end process;
  done     <= '1' when cnt_t = 9 else '0';
  --  debug(0) <= pin_ctrl_n_l(0);
  --  debug(1) <= pin_ctrl_p_l(0);
  --  debug(2) <= pin_ctrl_n_r(0);
  --  debug(3) <= pin_ctrl_p_r(0);
  --  debug(4) <= pin_ctrl_n_l(1);
  --  debug(5) <= pin_ctrl_p_l(1);
  --  debug(6) <= pin_ctrl_n_r(1);
  --  debug(7) <= pin_ctrl_p_r(1);
end architecture;


