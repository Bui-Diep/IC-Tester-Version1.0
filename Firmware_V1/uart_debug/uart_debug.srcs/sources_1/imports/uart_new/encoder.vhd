library ieee;
  use ieee.std_logic_1164.all;

entity encoder is
  generic (
    p : integer := 20; -- so luong chan IC
    t : integer := 10
  );
  port (
    ckht      : in  std_logic; --clock i/p
    rst       : in  std_logic;
    sig_enc   : in  std_logic; -- bat dau ma hoa
    check_pin : in  std_logic_vector(p downto 1);
    data_out  : out std_logic_vector(7 downto 0);
    ena_db    : out std_logic := '0'
  );
end entity;

architecture Behavioral of encoder is
  type enc_state is (idle, encoding);
  signal state_encoding : enc_state             := idle;
  signal cnt_byte       : integer range 0 to 11 := 0;
  signal trig_enc       : std_logic;
  --   signal data_temp      : std_logic_vector(24 downto 1) := (others => '1');
begin
  delay_inst_trig_comp: entity work.delay
    generic map (
      t => t
    )
    port map (
      ckht    => ckht,
      sig_in  => sig_enc,
      sig_out => trig_enc
    );

  enc_proc: process (ckht, rst, trig_enc)
  begin
    if rst = '1' then
      state_encoding <= idle;
    elsif rising_edge(ckht) then
      if state_encoding = idle then
        if trig_enc = '1' then
          state_encoding <= encoding;
          cnt_byte <= 0;
        end if;
      elsif state_encoding = encoding then
        if cnt_byte = 11 then
          state_encoding <= idle;
          cnt_byte <= 0;
        else
          cnt_byte <= cnt_byte + 1;
        end if;
      end if;
    end if;
  end process;

  process (cnt_byte)
  begin
    case cnt_byte is
      when 0 => data_out <= check_pin(20 downto 13);
                ena_db <= '0';
      when 1 => ena_db <= '1';
      when 2 => ena_db <= '0';
      when 3 => ena_db <= '0';
      when 4 => data_out <= check_pin(12 downto 5);
                ena_db <= '0';
      when 5 => ena_db <= '1';
      when 6 => ena_db <= '0';
      when 7 => ena_db <= '0';
      when 8 => data_out <= check_pin(4 downto 1) & "1111";
                ena_db <= '0';
      when 9 => ena_db <= '1';
      when 10 => ena_db <= '0';
      when 11 => ena_db <= '0';
    end case;
  end process;

end architecture;
