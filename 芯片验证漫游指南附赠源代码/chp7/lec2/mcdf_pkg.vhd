
library ieee;
use ieee.std_logic_1164.all;

package mcdf_pkg is

type reg2arb_t is record
  slv0_prio : std_logic_vector(1 downto 0);
  slv1_prio : std_logic_vector(1 downto 0);
  slv2_prio : std_logic_vector(1 downto 0);
end record;

type reg2fmt_t is record
  slv0_len : std_logic_vector(2 downto 0);
  slv1_len : std_logic_vector(2 downto 0);
  slv2_len : std_logic_vector(2 downto 0);
end record;

end mcdf_pkg;
