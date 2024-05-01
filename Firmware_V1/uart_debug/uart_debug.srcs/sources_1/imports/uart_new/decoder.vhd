library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity decoder is
  port (
    -- mode       : out   std_logic;
    data_in    : in  std_logic_vector(7 downto 0);
    pin_ctrl_n : out std_logic_vector(1 downto 0); -- bit 1 chan trai/bit 0 chan phai
    pin_ctrl_p : out std_logic_vector(1 downto 0) -- n: chan dieu khien muc logic '0';p: chan dieu khien muc logic '1'
  );
end entity;
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

architecture rtl of decoder is
  -- signal state_l, state_r : std_logic;

begin

  process (data_in(7 downto 0))
  begin
    case data_in(7 downto 6) is
      when "00" | "01" => case data_in(5 downto 4) is
                            -- when "01" => state_l <= '1';
                            -- when "10" => state_l <= '0';
                            -- when "11" => state_l <= 'Z';
                            -- when others => state_l <= 'Z';
                            when "01" => pin_ctrl_n(1) <= '0'; -- trang thai logic '1'
                                        pin_ctrl_p(1) <= '0';
                            when "10" => pin_ctrl_n(1) <= '1'; -- trang thai logic '0'
                                        pin_ctrl_p(1) <= '1';
                            when "11"=> pin_ctrl_n(1) <= '1'; -- trang thai tro khang cao
                                        pin_ctrl_p(1) <= '0';
                            when others => pin_ctrl_n(1) <= '1';
                                           pin_ctrl_p(1) <= '0';
                          end case;
      when others => pin_ctrl_n(1) <= '1';
                     pin_ctrl_p(1) <= '0';
    end case;
    case data_in(3 downto 2) is
      when "00" | "01" => case data_in(1 downto 0) is
                            -- when "01" => state_r <= '1';
                            -- when "10" => state_r <= '0';
                            -- when "11" => state_r <= 'Z';
                            -- when others => state_r <= 'Z';
                            when "01" => pin_ctrl_n(0) <= '0'; -- trang thai logic '1'
                                        pin_ctrl_p(0) <= '0';
                            when "10" => pin_ctrl_n(0) <= '1'; -- trang thai logic '0'
                                        pin_ctrl_p(0) <= '1';
                            when "11" => pin_ctrl_n(0) <= '1'; -- trang thai tro khang cao
                                        pin_ctrl_p(0) <= '0';
                            when others => pin_ctrl_n(0) <= '1';
                                           pin_ctrl_p(0) <= '0';
                          end case;
      when others => pin_ctrl_n(0) <= '1';
                     pin_ctrl_p(0) <= '0';
    end case;
  end process;

  -- process (state_l, state_r)
  -- begin
  --   case state_l is -- trang thai chan ben trai
  --     when '1' => pin_ctrl_n(1) <= '0'; -- trang thai logic '1'
  --                 pin_ctrl_p(1) <= '0';
  --     when '0' => pin_ctrl_n(1) <= '1'; -- trang thai logic '0'
  --                 pin_ctrl_p(1) <= '0';
  --     when 'Z' => pin_ctrl_n(1) <= '1'; -- trang thai tro khang cao
  --                 pin_ctrl_p(1) <= '1';
  --     when others => pin_ctrl_n(1) <= '1';
  --                    pin_ctrl_p(1) <= '1';
  --   end case;
  --   case state_r is -- trang thai chan ben phai
  --     when '1' => pin_ctrl_n(0) <= '0'; -- trang thai logic '1'
  --                 pin_ctrl_p(0) <= '0';
  --     when '0' => pin_ctrl_n(0) <= '1'; -- trang thai logic '0'
  --                 pin_ctrl_p(0) <= '0';
  --     when 'Z' => pin_ctrl_n(0) <= '1'; -- trang thai tro khang cao
  --                 pin_ctrl_p(0) <= '1';
  --     when others => pin_ctrl_n(0) <= '1';
  --                    pin_ctrl_p(0) <= '1';
  --   end case;
  -- end process;

end architecture;
