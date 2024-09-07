

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

entity icap_wrapper is
    port (
        clk : in std_logic;
        avail : out  std_logic;
        o : out std_logic_vector(31 downto 0);
        prdone : out std_logic;
        prerror : out std_logic;
        csib : in std_logic;
        i : in std_logic_vector(31 downto 0);
        rdwrb : in std_logic
    );
end icap_wrapper;

architecture rtl of icap_wrapper is

    attribute X_INTERFACE_INFO : string;
    attribute X_INTERFACE_INFO of avail : signal is "xilinx.com:interface:icap:1.0 ICAP avail";
    attribute X_INTERFACE_INFO of o : signal is "xilinx.com:interface:icap:1.0 ICAP o";
    attribute X_INTERFACE_INFO of prdone : signal is "xilinx.com:interface:icap:1.0 ICAP prdone";
    attribute X_INTERFACE_INFO of prerror : signal is "xilinx.com:interface:icap:1.0 ICAP prerror";
    attribute X_INTERFACE_INFO of csib : signal is "xilinx.com:interface:icap:1.0 ICAP csib";
    attribute X_INTERFACE_INFO of i : signal is "xilinx.com:interface:icap:1.0 ICAP i";
    attribute X_INTERFACE_INFO of rdwrb : signal is "xilinx.com:interface:icap:1.0 ICAP rdwrb";

begin

   ICAPE3_inst : ICAPE3
   generic map (
      DEVICE_ID => X"03628093",      -- Specifies the pre-programmed Device ID value to be used for simulation
                                     -- purposes.
      ICAP_AUTO_SWITCH => "DISABLE", -- Enable switch ICAP using sync word.
      SIM_CFG_FILE_NAME => "NONE"    -- Specifies the Raw Bitstream (RBT) file to be parsed by the simulation
                                     -- model.
   )
   port map (
      AVAIL => avail,     -- 1-bit output: Availability status of ICAP.
      O => o,             -- 32-bit output: Configuration data output bus.
      PRDONE => prdone,   -- 1-bit output: Indicates completion of Partial Reconfiguration.
      PRERROR => prerror, -- 1-bit output: Indicates error during Partial Reconfiguration.
      CLK => clk,         -- 1-bit input: Clock input.
      CSIB => csib,       -- 1-bit input: Active-Low ICAP enable.
      I => i,             -- 32-bit input: Configuration data input bus.
      RDWRB => rdwrb      -- 1-bit input: Read/Write Select input.
   );
   
   
end rtl;

