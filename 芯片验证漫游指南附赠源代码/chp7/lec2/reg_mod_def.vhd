library ieee;
use ieee.std_logic_1164.all;
-- definition type3
entity ctrl_regs3 is
  port(
  clk_i         : in  std_logic;
  rstn_i        : in  std_logic;
  cmd_i         : in  std_logic_vector(1  downto 0);
  cmd_addr_i    : in  std_logic_vector(7  downto 0);
  cmd_data_i    : in  std_logic_vector(31 downto 0);
  cmd_data_o    : out std_logic_vector(31 downto 0);
  slv0_avail_i  : in  std_logic_vector(7  downto 0);
  slv1_avail_i  : in  std_logic_vector(7  downto 0);
  slv2_avail_i  : in  std_logic_vector(7  downto 0);
  slv0_len_o    : out std_logic_vector(2  downto 0);
  slv1_len_o    : out std_logic_vector(2  downto 0);
  slv2_len_o    : out std_logic_vector(2  downto 0);
  slv0_prio_o   : out std_logic_vector(1  downto 0);
  slv1_prio_o   : out std_logic_vector(1  downto 0);
  slv2_prio_o   : out std_logic_vector(1  downto 0);
  slv0_en_o     : out std_logic;
  slv1_en_o     : out std_logic;
  slv2_en_o     : out std_logic
);

end ctrl_regs3;

architecture rtl of ctrl_regs3 is
begin
end rtl;



-- definition type4
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mcdf_pkg.all;

entity ctrl_regs4 is
  port(
  clk_i         : in  std_logic;
  rstn_i        : in  std_logic;
  cmd_i         : in  std_logic_vector(1  downto 0);
  cmd_addr_i    : in  std_logic_vector(7  downto 0);
  cmd_data_i    : in  std_logic_vector(31 downto 0);
  cmd_data_o    : out std_logic_vector(31 downto 0);
  slv0_avail_i  : in  std_logic_vector(7  downto 0);
  slv1_avail_i  : in  std_logic_vector(7  downto 0);
  slv2_avail_i  : in  std_logic_vector(7  downto 0);
  reg2fmt_o     : out reg2fmt_t;
  reg2arb_o     : out reg2arb_t;
  slv0_en_o     : out std_logic;
  slv1_en_o     : out std_logic;
  slv2_en_o     : out std_logic
);

end ctrl_regs4;

architecture rtl of ctrl_regs4 is
begin
end rtl;
