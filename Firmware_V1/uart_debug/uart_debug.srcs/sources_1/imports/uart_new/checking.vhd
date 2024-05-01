library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity checking is
  generic (
    n : integer := 20; -- so luong chan IC
    t : integer := 10

  );
  port (ckht       : in     std_logic;
        rst        : in     std_logic;
        sig_comp   : in     std_logic;
        pulse_tirg : in     std_logic;
        i_p        : in     std_logic_vector(n downto 1);       -- tin hieu thu tu cac chan IC
        data_std   : in     std_logic_vector(7 downto 0);       -- du lieu trong thu vien chuan
        result_t   : buffer std_logic_vector(n downto 1) := (others => '1');
        result     : buffer    std_logic                    := '1' -- ket qua 1: true/ 0: false
       );
end entity;

architecture rtl of checking is
  type buffer_20x8 is array (n / 2 - 1 downto 0) of std_logic_vector(7 downto 0);
  signal data_buf             : buffer_20x8           := (others => (others => '0'));
  signal cnt_t                : integer range 0 to 10 := 0;
  signal trig_data, trig_comp : std_logic;
begin
  delay_inst_trig_data: entity work.delay
    generic map (
      t => t
    )
    port map (
      ckht    => ckht,
      sig_in  => pulse_tirg,
      sig_out => trig_data
    );
  delay_inst_trig_comp: entity work.delay
    generic map (
      t => t
    )
    port map (
      ckht    => ckht,
      sig_in  => sig_comp,
      sig_out => trig_comp
    );

  process (ckht, rst, trig_data)
  begin
    if rst = '1' then
      cnt_t <= 0;
      data_buf <= (others => (others => '0'));
    elsif rising_edge(trig_data) then
      data_buf(cnt_t)(7 downto 0) <= data_std(7 downto 0);
      if cnt_t = 9 then
        cnt_t <= 0;
      else
        cnt_t <= cnt_t + 1;
      end if;
    end if;
  end process;
  --  byte cấu hình "điện áp(7), số chân(6-5), số bài test (4-1)"
  --              "1xxxxxxx" thể hiện mức điện áp IC 5V
  --              "0xxxxxxx" thể hiện mức điện áp IC 3.3V
  --              "x00xxxxx" thể hiện IC 14 Chân
  --              "x01xxxxx" thể hiện IC 16 Chân
  --              "x10xxxxx" thể hiện IC 20 Chân
  --              "x00xxxxx" thể hiện các trư�?ng hợp còn lại v�? số chân IC
  --  Mã hóa chân dữ liệu (4bit cho một chân)
  --  4bit tr�?ng số cao mã hóa dữ liệu của hàng chân bên trái
  --  4bit tr�?ng số thấp mã hóa dữ liệu của hàng chân bên phải
  --              "00xx" thể hiện chân InPut của IC
  --              "10xx" thể hiện chân OutPut của IC
  --              "01xx" thể hiện chân Nguồn của IC
  -----------------------------------------------------------------
  --              "xx00" không xác định được mức Logic
  --              "xx01" thể hiện mức Logic '1'
  --              "xx10" thể hiện mức Logic '0'

  --              "xx11" thể hiện mức trở kháng cao 'Z'
  process (ckht, trig_comp, data_buf, i_p)
    variable i : integer := 0;
  begin

    ------------------------------chan 1 va 20----------------------------------------
    case data_buf(0)(7 downto 6) is
      when "10" => case data_buf(0)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(1) = '1' then -- muc logic '1'
                                    result_t(1) <= '1'; -- pass
                                  else
                                    result_t(1) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(1) = '0' then -- muc logic '1'
                                    result_t(1) <= '1'; -- pass
                                  else
                                    result_t(1) <= '0'; -- not pass
                                  end if;
                     when others => result_t(1) <= '1';
                   end case;
      when others => result_t(1) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(0)(3 downto 2) is
      when "10" => case data_buf(0)(1 downto 0) is
                     when "01" => if i_p(20) = '1' then
                                    result_t(20) <= '1'; -- pass
                                  else
                                    result_t(20) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(20) = '0' then
                                    result_t(20) <= '1'; -- pass
                                  else
                                    result_t(20) <= '0'; -- not pass
                                  end if;
                     when others => result_t(20) <= '1';
                   end case;
      when others => result_t(20) <= '1';
    end case;

    ------------------------------chan 2 va 19----------------------------------------
    case data_buf(1)(7 downto 6) is
      when "10" => case data_buf(1)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(2) = '1' then -- muc logic '1'
                                    result_t(2) <= '1'; -- pass
                                  else
                                    result_t(2) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(2) = '0' then -- muc logic '1'
                                    result_t(2) <= '1'; -- pass
                                  else
                                    result_t(2) <= '0'; -- not pass
                                  end if;
                     when others => result_t(2) <= '1';
                   end case;
      when others => result_t(2) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(1)(3 downto 2) is
      when "10" => case data_buf(1)(1 downto 0) is
                     when "01" => if i_p(19) = '1' then
                                    result_t(19) <= '1'; -- pass
                                  else
                                    result_t(19) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(19) = '0' then
                                    result_t(19) <= '1'; -- pass
                                  else
                                    result_t(19) <= '0'; -- not pass
                                  end if;
                     when others => result_t(19) <= '1';
                   end case;
      when others => result_t(19) <= '1';
    end case;
    ------------------------------chan 3 va 18----------------------------------------
    case data_buf(2)(7 downto 6) is
      when "10" => case data_buf(2)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(3) = '1' then -- muc logic '1'
                                    result_t(3) <= '1'; -- pass
                                  else
                                    result_t(3) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(3) = '0' then -- muc logic '1'
                                    result_t(3) <= '1'; -- pass
                                  else
                                    result_t(3) <= '0'; -- not pass
                                  end if;
                     when others => result_t(3) <= '1';
                   end case;
      when others => result_t(3) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(2)(3 downto 2) is
      when "10" => case data_buf(2)(1 downto 0) is
                     when "01" => if i_p(18) = '1' then
                                    result_t(18) <= '1'; -- pass
                                  else
                                    result_t(18) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(18) = '0' then
                                    result_t(18) <= '1'; -- pass
                                  else
                                    result_t(18) <= '0'; -- not pass
                                  end if;
                     when others => result_t(18) <= '1';
                   end case;
      when others => result_t(18) <= '1';
    end case;
    ------------------------------chan 4 va 17----------------------------------------
    case data_buf(3)(7 downto 6) is
      when "10" => case data_buf(3)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(4) = '1' then -- muc logic '1'
                                    result_t(4) <= '1'; -- pass
                                  else
                                    result_t(4) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(4) = '0' then -- muc logic '1'
                                    result_t(4) <= '1'; -- pass
                                  else
                                    result_t(4) <= '0'; -- not pass
                                  end if;
                     when others => result_t(4) <= '1';
                   end case;
      when others => result_t(4) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(3)(3 downto 2) is
      when "10" => case data_buf(3)(1 downto 0) is
                     when "01" => if i_p(17) = '1' then
                                    result_t(17) <= '1'; -- pass
                                  else
                                    result_t(17) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(17) = '0' then
                                    result_t(17) <= '1'; -- pass
                                  else
                                    result_t(17) <= '0'; -- not pass
                                  end if;
                     when others => result_t(17) <= '1';
                   end case;
      when others => result_t(17) <= '1';
    end case;
    ------------------------------chan 5 va 16----------------------------------------
    case data_buf(4)(7 downto 6) is
      when "10" => case data_buf(4)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(5) = '1' then -- muc logic '1'
                                    result_t(5) <= '1'; -- pass
                                  else
                                    result_t(5) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(5) = '0' then -- muc logic '1'
                                    result_t(5) <= '1'; -- pass
                                  else
                                    result_t(5) <= '0'; -- not pass
                                  end if;
                     when others => result_t(5) <= '1';
                   end case;
      when others => result_t(5) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(4)(3 downto 2) is
      when "10" => case data_buf(4)(1 downto 0) is
                     when "01" => if i_p(16) = '1' then
                                    result_t(16) <= '1'; -- pass
                                  else
                                    result_t(16) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(16) = '0' then
                                    result_t(16) <= '1'; -- pass
                                  else
                                    result_t(16) <= '0'; -- not pass
                                  end if;
                     when others => result_t(16) <= '1';
                   end case;
      when others => result_t(16) <= '1';
    end case;
    ------------------------------chan 6 va 15----------------------------------------
    case data_buf(5)(7 downto 6) is
      when "10" => case data_buf(5)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(6) = '1' then -- muc logic '1'
                                    result_t(6) <= '1'; -- pass
                                  else
                                    result_t(6) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(6) = '0' then -- muc logic '1'
                                    result_t(6) <= '1'; -- pass
                                  else
                                    result_t(6) <= '0'; -- not pass
                                  end if;
                     when others => result_t(6) <= '1';
                   end case;
      when others => result_t(6) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(5)(3 downto 2) is
      when "10" => case data_buf(5)(1 downto 0) is
                     when "01" => if i_p(15) = '1' then
                                    result_t(15) <= '1'; -- pass
                                  else
                                    result_t(15) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(15) = '0' then
                                    result_t(15) <= '1'; -- pass
                                  else
                                    result_t(15) <= '0'; -- not pass
                                  end if;
                     when others => result_t(15) <= '1';
                   end case;
      when others => result_t(15) <= '1';
    end case;
    ------------------------------chan 7 va 14----------------------------------------
    case data_buf(6)(7 downto 6) is
      when "10" => case data_buf(6)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(7) = '1' then -- muc logic '1'
                                    result_t(7) <= '1'; -- pass
                                  else
                                    result_t(7) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(7) = '0' then -- muc logic '1'
                                    result_t(7) <= '1'; -- pass
                                  else
                                    result_t(7) <= '0'; -- not pass
                                  end if;
                     when others => result_t(7) <= '1';
                   end case;
      when others => result_t(7) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(6)(3 downto 2) is
      when "10" => case data_buf(6)(1 downto 0) is
                     when "01" => if i_p(14) = '1' then
                                    result_t(14) <= '1'; -- pass
                                  else
                                    result_t(14) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(14) = '0' then
                                    result_t(14) <= '1'; -- pass
                                  else
                                    result_t(14) <= '0'; -- not pass
                                  end if;
                     when others => result_t(14) <= '1';
                   end case;
      when others => result_t(14) <= '1';
    end case;
    ------------------------------chan 8 va 13----------------------------------------
    case data_buf(7)(7 downto 6) is
      when "10" => case data_buf(7)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(8) = '1' then -- muc logic '1'
                                    result_t(8) <= '1'; -- pass
                                  else
                                    result_t(8) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(8) = '0' then -- muc logic '1'
                                    result_t(8) <= '1'; -- pass
                                  else
                                    result_t(8) <= '0'; -- not pass
                                  end if;
                     when others => result_t(8) <= '1';
                   end case;
      when others => result_t(8) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(7)(3 downto 2) is
      when "10" => case data_buf(7)(1 downto 0) is
                     when "01" => if i_p(13) = '1' then
                                    result_t(13) <= '1'; -- pass
                                  else
                                    result_t(13) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(13) = '0' then
                                    result_t(13) <= '1'; -- pass
                                  else
                                    result_t(13) <= '0'; -- not pass
                                  end if;
                     when others => result_t(13) <= '1';
                   end case;
      when others => result_t(13) <= '1';
    end case;
    ------------------------------chan 9 va 12----------------------------------------
    case data_buf(8)(7 downto 6) is
      when "10" => case data_buf(8)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(9) = '1' then -- muc logic '1'
                                    result_t(9) <= '1'; -- pass
                                  else
                                    result_t(9) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(9) = '0' then -- muc logic '1'
                                    result_t(9) <= '1'; -- pass
                                  else
                                    result_t(9) <= '0'; -- not pass
                                  end if;
                     when others => result_t(9) <= '1';
                   end case;
      when others => result_t(9) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(8)(3 downto 2) is
      when "10" => case data_buf(8)(1 downto 0) is
                     when "01" => if i_p(12) = '1' then
                                    result_t(12) <= '1'; -- pass
                                  else
                                    result_t(12) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(12) = '0' then
                                    result_t(12) <= '1'; -- pass
                                  else
                                    result_t(12) <= '0'; -- not pass
                                  end if;
                     when others => result_t(12) <= '1';
                   end case;
      when others => result_t(12) <= '1';
    end case;
    ------------------------------chan 10 va 11----------------------------------------
    case data_buf(9)(7 downto 6) is
      when "10" => case data_buf(9)(5 downto 4) is -- tin hieu ra cua IC
                     when "01" => if i_p(10) = '1' then -- muc logic '1'
                                    result_t(10) <= '1'; -- pass
                                  else
                                    result_t(10) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(10) = '0' then -- muc logic '1'
                                    result_t(10) <= '1'; -- pass
                                  else
                                    result_t(10) <= '0'; -- not pass
                                  end if;
                     when others => result_t(10) <= '1';
                   end case;
      when others => result_t(10) <= '1'; -- khong phai tin hieu ngo ra
    end case;
    case data_buf(9)(3 downto 2) is
      when "10" => case data_buf(9)(1 downto 0) is
                     when "01" => if i_p(11) = '1' then
                                    result_t(11) <= '1'; -- pass
                                  else
                                    result_t(11) <= '0'; -- not pass
                                  end if;
                     when "10" => if i_p(11) = '0' then
                                    result_t(11) <= '1'; -- pass
                                  else
                                    result_t(11) <= '0'; -- not pass
                                  end if;
                     when others => result_t(11) <= '1';
                   end case;
      when others => result_t(11) <= '1';
    end case;

    if rst = '1' then
      result_t <= (others => '1');
      result <= '1';
    elsif rising_edge(ckht) then
      if trig_comp = '1' then
        i := 0;
        result <= result_t(1) and result_t(2) and result_t(3) and result_t(4) and result_t(5) and result_t(6) and result_t(7) and result_t(8) and result_t(9) and result_t(10) and result_t(11) and result_t(12) and result_t(13) and result_t(14) and result_t(15) and result_t(16) and result_t(17) and result_t(18) and result_t(19) and result_t(20);
      end if;
      if result = '0' then
        if i = 2000000 then
          i := 2000000;
          result <= '1';
        else
          i := i + 1;
        end if;
      end if;

    end if;

  end process;
end architecture;
