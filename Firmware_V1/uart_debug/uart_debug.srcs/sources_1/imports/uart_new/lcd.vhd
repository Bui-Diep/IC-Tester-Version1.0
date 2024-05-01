library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity lcd is
  generic (
    p : integer := 20 -- so luong chan IC
  );
  port (
    ckht      : in  std_logic;                   --clock i/p
    rst       : in  std_logic;
    result    : in  std_logic;                   -- thong bao loi/tot: 0/1
    sig_check : in  std_logic;                   -- bat dau kiem tra
    check_pin : in  std_logic_vector(p downto 1);
    rw        : out std_logic;                   --read & write control
    e         : out std_logic;                   --enable control
    rs        : out std_logic;                   --data or command control
    data      : out std_logic_vector(7 downto 0) --data line

  );
end entity;

architecture Behavioral of lcd is
  type lcd_data is array (1 to 89) of std_logic_vector(7 downto 0);
  constant initial_display : lcd_data := (
    x"38", x"0c", x"06", x"01", x"80", --(5)    ---------------------------------------------------------------------------------------------------------------------
    -- IC Tester v1
    -- Creator: BuiDiep
    x"49", x"43", x"20", x"54", x"65", x"73", x"74", x"65", x"72", x"20", x"56", x"31", --(17)
    x"c0",
    x"43", x"72", x"65", x"61", x"74", x"6F", x"72", x"3A", x"20", x"42", x"75", x"69", x"44", x"69", x"65", x"70", x"20", --(35)
    ---------------------------------------------------------------------------------------------------------------------
    -- Checking .....
    x"01", x"80",
    x"43", x"68", x"65", x"63", x"6B", x"69", x"6E", x"67", x"20", x"2E", x"2E", x"2E", x"2E", x"2E", x"20", --(52)
    ---------------------------------------------------------------------------------------------------------------------
    --The test : FAIL
    x"01", x"80",
    x"54", x"68", x"65", x"20", x"74", x"65", x"73", x"74", x"20", x"7E", x"20", x"46", x"41", x"49", x"4C",x"21", x"20",--(71)
   
    ---------------------------------------------------------------------------------------------------------------------
    --The test : PASS
    x"01", x"80",
    x"54", x"68", x"65", x"20", x"74", x"65", x"73", x"74", x"20", x"7E", x"20", x"50", x"41", x"53", x"53", x"20" --(89)
    ---------------------------------------------------------------------------------------------------------------------
  );
  -- type error_pin is array (1 to 26) of std_logic_vector(7 downto 0);
  -- variable err_pin : error_pin := (
  --   ------------------------------------------
  --   -- pin: 0123456789,
  --   x"70", x"69", x"6E", x"3A", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"
  -- );
  -- signal ic_error : std_logic := '0';
  -- signal ic_perf  : std_logic := '1';
  type state_type is (ini, checking, rsl_err, rsl_perf);
  signal progress : state_type             := ini;
  signal n        : integer range 1 to 110 := 1;
  constant f_scan : integer := 20000;
begin
  rw <= '0'; --lcd write

  process (ckht, progress, n, result, sig_check)
    variable i : integer := 0;
    -- variable time_t : integer := 0;
    variable compl : integer range 0 to (50000000 /(f_scan * 2)) * 2 := 0;
  begin

    if ckht'event and ckht = '1' then
      if rst = '1' then
        i := 0;
        n <= 1;
        progress <= ini;
        compl := 0;
      elsif i <= f_scan then
        i := i + 1;
        e <= '1';
        data <= initial_display(n)(7 downto 0);
      elsif i > f_scan and i < f_scan * 2 then
        i := i + 1;
        e <= '0';
      elsif i = f_scan * 2 then
        n <= n + 1;
        i := 0;
        if compl =(50000000 /(f_scan * 2)) * 2 then
          compl := (50000000 /(f_scan * 2)) * 2;
        else
          compl := compl + 1;
        end if;
      end if;

      case progress is
        when ini => if n <= 5 then
                      rs <= '0'; --command signal
                    elsif n = 18 then
                      rs <= '0';
                    else
                      rs <= '1'; --data signal
                    end if;

                    if n > 34 then --repeated display of data
                      n <= 5;
                    end if;

                    if sig_check = '1' then
                      progress <= checking;
                      n <= 35;
                      compl := 0;
                    end if;
        when rsl_err => if n = 53 or n = 54 then
                          rs <= '0';
                        else
                          rs <= '1'; --data signal
                        end if;

                        if n > 70 then --repeated display of data
                          n <= 54;
                        end if;

        when rsl_perf => if n = 72 or n = 73  then
                           rs <= '0';
                         else
                           rs <= '1'; --data signal
                         end if;

                         if n > 87 then --repeated display of data
                           n <= 73;
                         end if;

                         if result = '0' then
                           progress <= rsl_err;
                           n <= 52;
                         end if;

        when checking => if n = 36 or n = 37 then
                           rs <= '0';
                         else
                           rs <= '1'; --data signal
                         end if;

                         if n > 51 then --repeated display of data
                           n <= 37;
                         end if;

                         if result = '0' then
                           progress <= rsl_err;
                           n <= 52;
                         elsif compl =(50000000 /(f_scan * 2)) * 2 then
                           progress <= rsl_perf;
                           n <= 80;
                         end if;
      end case;

    end if;

  end process;

  -- process (check_pin)
  --   variable c : integer range 6 to 20 := 6;
  -- begin
  --   if event'check_pin then
  --     if check_pin(1) = '0' then
  --       err_pin(c) := x"31";
  --       c := c + 1;
  --     elsif check_pin(2) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"32";
  --       c := c + 2;
  --     elsif check_pin(3) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"33";
  --       c := c + 2;
  --     elsif check_pin(4) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"34";
  --       c := c + 2;
  --     elsif check_pin(5) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"35";
  --       c := c + 2;
  --     elsif check_pin(6) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"36";
  --       c := c + 2;
  --     elsif check_pin(7) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"37";
  --       c := c + 2;
  --     elsif check_pin(8) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"38";
  --       c := c + 2;
  --     elsif check_pin(9) = '0' then
  --       err_pin(c) := x"2C";
  --       err_pin(c + 1) := x"39";
  --       c := c + 2;
  --     end if;
  --   end if;
  -- end process;
end architecture;
