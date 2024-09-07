--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.2.2 (lin64) Build 4126759 Thu Feb  8 23:52:05 MST 2024
--Date        : Tue Mar 26 11:29:41 2024
--Host        : xfae-workhorse running 64-bit Ubuntu 20.04.6 LTS
--Command     : generate_target system_wrapper.bd
--Design      : system_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity top is
  port (
    ddr4_sdram_act_n : out STD_LOGIC;
    ddr4_sdram_adr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    ddr4_sdram_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_bg : out STD_LOGIC;
    ddr4_sdram_ck_c : out STD_LOGIC;
    ddr4_sdram_ck_t : out STD_LOGIC;
    ddr4_sdram_cke : out STD_LOGIC;
    ddr4_sdram_cs_n : out STD_LOGIC;
    ddr4_sdram_dm_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    ddr4_sdram_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    ddr4_sdram_dqs_c : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    ddr4_sdram_dqs_t : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    ddr4_sdram_odt : out STD_LOGIC;
    ddr4_sdram_reset_n : out STD_LOGIC;
    main_i2c_scl_io : inout STD_LOGIC;
    main_i2c_sda_io : inout STD_LOGIC;
    mdio_io_mdc : out STD_LOGIC;
    mdio_io_mdio_io : inout STD_LOGIC;
    mii_ethernet_col : in STD_LOGIC;
    mii_ethernet_crs : in STD_LOGIC;
    mii_ethernet_rst_n : out STD_LOGIC;
    mii_ethernet_rx_clk : in STD_LOGIC;
    mii_ethernet_rx_dv : in STD_LOGIC;
    mii_ethernet_rx_er : in STD_LOGIC;
    mii_ethernet_rxd : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mii_ethernet_tx_clk : in STD_LOGIC;
    mii_ethernet_tx_en : out STD_LOGIC;
    mii_ethernet_txd : out STD_LOGIC_VECTOR ( 3 downto 0 );
    red_leds_4bits_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    push_buttons_4bits_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sys_uart_rxd : in STD_LOGIC;
    sys_uart_txd : out STD_LOGIC;
    system_clock_300mhz_clk_n : in STD_LOGIC;
    system_clock_300mhz_clk_p : in STD_LOGIC;
    system_resetn : in STD_LOGIC;
    led_rgb_1 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    led_rgb_2 : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
end top;

architecture STRUCTURE of top is
  component system is
  port (
    sys_uart_rxd : in STD_LOGIC;
    sys_uart_txd : out STD_LOGIC;
    red_leds_4bits_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ddr4_sdram_act_n : out STD_LOGIC;
    ddr4_sdram_adr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    ddr4_sdram_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_bg : out STD_LOGIC;
    ddr4_sdram_ck_c : out STD_LOGIC;
    ddr4_sdram_ck_t : out STD_LOGIC;
    ddr4_sdram_cke : out STD_LOGIC;
    ddr4_sdram_cs_n : out STD_LOGIC;
    ddr4_sdram_dm_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    ddr4_sdram_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    ddr4_sdram_dqs_c : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    ddr4_sdram_dqs_t : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    ddr4_sdram_odt : out STD_LOGIC;
    ddr4_sdram_reset_n : out STD_LOGIC;
    system_clock_300mhz_clk_n : in STD_LOGIC;
    system_clock_300mhz_clk_p : in STD_LOGIC;
    mii_ethernet_col : in STD_LOGIC;
    mii_ethernet_crs : in STD_LOGIC;
    mii_ethernet_rst_n : out STD_LOGIC;
    mii_ethernet_rx_clk : in STD_LOGIC;
    mii_ethernet_rx_dv : in STD_LOGIC;
    mii_ethernet_rx_er : in STD_LOGIC;
    mii_ethernet_rxd : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mii_ethernet_tx_clk : in STD_LOGIC;
    mii_ethernet_tx_en : out STD_LOGIC;
    mii_ethernet_txd : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mdio_io_mdc : out STD_LOGIC;
    mdio_io_mdio_i : in STD_LOGIC;
    mdio_io_mdio_o : out STD_LOGIC;
    mdio_io_mdio_t : out STD_LOGIC;
    main_i2c_scl_i : in STD_LOGIC;
    main_i2c_scl_o : out STD_LOGIC;
    main_i2c_scl_t : out STD_LOGIC;
    main_i2c_sda_i : in STD_LOGIC;
    main_i2c_sda_o : out STD_LOGIC;
    main_i2c_sda_t : out STD_LOGIC;
    system_resetn : in STD_LOGIC;
    dfxc_count_hw_trig : in STD_LOGIC_VECTOR ( 1 downto 0 );
    dfxc_shift_hw_trig : in STD_LOGIC_VECTOR ( 1 downto 0 );
    vs_count_rm_decouple : out STD_LOGIC;
    vs_count_rm_reset : out STD_LOGIC;
    vs_shift_rm_decouple : out STD_LOGIC;
    vs_shift_rm_reset : out STD_LOGIC;
    clk_sys : out STD_LOGIC;
    push_buttons_4bits_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component system;

  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;

component dfx_decoupler is 
port (
  s_intf_0_DATA : out std_logic_vector(2 downto 0);
  rp_intf_0_DATA : in std_logic_vector(2 downto 0);
  decouple : in std_logic;
  decouple_status : out std_logic
  );
end component;

  
--component sem_wrapper is 
--port (
--  icap_clk : in std_logic;
--  icap_o : in std_logic_vector(31 downto 0);
--  icap_csib : out std_logic;
--  icap_rdwrb : out std_logic;
--  icap_i : out std_logic_vector(31 downto 0);
--  icap_prerror: in std_logic;
--  icap_prdone:  in std_logic;
--  icap_avail: in std_logic;
--  icap_rel: in std_logic;
--  icap_gnt: in std_logic;
--  icap_req: out std_logic
--  );
--end component;

--Virtual Socket 1: count
component count is 
port (
  rst: in std_logic;
  clk : in std_logic;
  count_out : out std_logic_vector(3 downto 0);
  led_rgb : out std_logic_vector(2 downto 0);
  S_BSCAN_drck : in std_logic;
  S_BSCAN_shift : in std_logic;
  S_BSCAN_tdi : in std_logic;
  S_BSCAN_update : in std_logic;
  S_BSCAN_sel: in std_logic;
  S_BSCAN_tdo: out std_logic;
  S_BSCAN_tms: in std_logic;
  S_BSCAN_tck: in std_logic;
  S_BSCAN_runtest: in std_logic;
  S_BSCAN_reset: in std_logic;
  S_BSCAN_capture: in std_logic;
  S_BSCAN_bscanid_en: in std_logic
  );
  end component;

component shift is 
port (
  en: in std_logic;
  clk: in std_logic;
  addr: in std_logic_vector(11 downto 0);
  data_out: out std_logic_vector(3 downto 0);
  led_rgb : out std_logic_vector(2 downto 0)
  );
end component;
  
  signal clk_icap : std_logic;
  signal clk_sys : std_logic;
 
  signal main_i2c_scl_i : STD_LOGIC;
  signal main_i2c_scl_o : STD_LOGIC;
  signal main_i2c_scl_t : STD_LOGIC;
  signal main_i2c_sda_i : STD_LOGIC;
  signal main_i2c_sda_o : STD_LOGIC;
  signal main_i2c_sda_t : STD_LOGIC;
  signal mdio_io_mdio_i : STD_LOGIC;
  signal mdio_io_mdio_o : STD_LOGIC;
  signal mdio_io_mdio_t : STD_LOGIC;


  signal led_rgb_1_i : std_logic_vector(2 downto 0);
  signal led_rgb_2_i : std_logic_vector(2 downto 0);

  signal vs_count_rm_decouple : STD_LOGIC;
  signal vs_shift_rm_decouple: STD_LOGIC;
  signal vs_count_rm_reset : STD_LOGIC;
  signal vs_shift_rm_reset : STD_LOGIC;

--  signal sem_icap_o : std_logic_vector(31 downto 0);
--  signal sem_icap_csib: STD_LOGIC;
--  signal sem_icap_rdwrb: STD_LOGIC;
--  signal sem_icap_i: std_logic_vector(31 downto 0);
--  signal sem_icap_prerror: STD_LOGIC;
--  signal sem_icap_prdone: STD_LOGIC;
--  signal sem_icap_avail: STD_LOGIC;
--  signal sem_icap_rel: STD_LOGIC;
--  signal sem_icap_gnt: STD_LOGIC;
--  signal sem_icap_req: STD_LOGIC;
  
begin
main_i2c_scl_iobuf: component IOBUF
     port map (
      I => main_i2c_scl_o,
      IO => main_i2c_scl_io,
      O => main_i2c_scl_i,
      T => main_i2c_scl_t
    );
main_i2c_sda_iobuf: component IOBUF
     port map (
      I => main_i2c_sda_o,
      IO => main_i2c_sda_io,
      O => main_i2c_sda_i,
      T => main_i2c_sda_t
    );
mdio_io_mdio_iobuf: component IOBUF
     port map (
      I => mdio_io_mdio_o,
      IO => mdio_io_mdio_io,
      O => mdio_io_mdio_i,
      T => mdio_io_mdio_t
    );
system_i: component system
     port map (
      clk_sys => clk_sys,
      ddr4_sdram_act_n => ddr4_sdram_act_n,
      ddr4_sdram_adr(16 downto 0) => ddr4_sdram_adr(16 downto 0),
      ddr4_sdram_ba(1 downto 0) => ddr4_sdram_ba(1 downto 0),
      ddr4_sdram_bg => ddr4_sdram_bg,
      ddr4_sdram_ck_c => ddr4_sdram_ck_c,
      ddr4_sdram_ck_t => ddr4_sdram_ck_t,
      ddr4_sdram_cke => ddr4_sdram_cke,
      ddr4_sdram_cs_n => ddr4_sdram_cs_n,
      ddr4_sdram_dm_n(3 downto 0) => ddr4_sdram_dm_n(3 downto 0),
      ddr4_sdram_dq(31 downto 0) => ddr4_sdram_dq(31 downto 0),
      ddr4_sdram_dqs_c(3 downto 0) => ddr4_sdram_dqs_c(3 downto 0),
      ddr4_sdram_dqs_t(3 downto 0) => ddr4_sdram_dqs_t(3 downto 0),
      ddr4_sdram_odt => ddr4_sdram_odt,
      ddr4_sdram_reset_n => ddr4_sdram_reset_n,
      dfxc_count_hw_trig(1 downto 0) => ( others => '0'),
      dfxc_shift_hw_trig(1 downto 0) => ( others => '0'),
      main_i2c_scl_i => main_i2c_scl_i,
      main_i2c_scl_o => main_i2c_scl_o,
      main_i2c_scl_t => main_i2c_scl_t,
      main_i2c_sda_i => main_i2c_sda_i,
      main_i2c_sda_o => main_i2c_sda_o,
      main_i2c_sda_t => main_i2c_sda_t,
      mdio_io_mdc => mdio_io_mdc,
      mdio_io_mdio_i => mdio_io_mdio_i,
      mdio_io_mdio_o => mdio_io_mdio_o,
      mdio_io_mdio_t => mdio_io_mdio_t,
      mii_ethernet_col => mii_ethernet_col,
      mii_ethernet_crs => mii_ethernet_crs,
      mii_ethernet_rst_n => mii_ethernet_rst_n,
      mii_ethernet_rx_clk => mii_ethernet_rx_clk,
      mii_ethernet_rx_dv => mii_ethernet_rx_dv,
      mii_ethernet_rx_er => mii_ethernet_rx_er,
      mii_ethernet_rxd(3 downto 0) => mii_ethernet_rxd(3 downto 0),
      mii_ethernet_tx_clk => mii_ethernet_tx_clk,
      mii_ethernet_tx_en => mii_ethernet_tx_en,
      mii_ethernet_txd(3 downto 0) => mii_ethernet_txd(3 downto 0),
      red_leds_4bits_tri_o(3 downto 0) => red_leds_4bits_tri_o(3 downto 0),
      push_buttons_4bits_tri_i => push_buttons_4bits_tri_i,
 
      sys_uart_rxd => sys_uart_rxd,
      sys_uart_txd => sys_uart_txd,
      system_clock_300mhz_clk_n => system_clock_300mhz_clk_n,
      system_clock_300mhz_clk_p => system_clock_300mhz_clk_p,
      system_resetn => system_resetn,

      vs_count_rm_decouple => vs_count_rm_decouple,
      vs_count_rm_reset => vs_count_rm_reset,
      vs_shift_rm_decouple => vs_shift_rm_decouple,
      vs_shift_rm_reset => vs_shift_rm_reset
    );

--DFX Decoupler IP
dfx_decoupler_shift : component dfx_decoupler
port map (
  s_intf_0_DATA => led_rgb_2,
  rp_intf_0_DATA => led_rgb_2_i,
  decouple => vs_shift_rm_decouple,
  decouple_status => open
  );

dfx_decoupler_count : component dfx_decoupler
port map (
  s_intf_0_DATA => led_rgb_1,
  rp_intf_0_DATA => led_rgb_1_i,
  decouple => vs_count_rm_decouple,
  decouple_status => open
  );


--Virtual Socket 1: count
u_count: component count
port map (
  rst => vs_count_rm_reset,
  clk => clk_sys,
  count_out => open,
  led_rgb => led_rgb_1_i,
  S_BSCAN_drck => '0',
  S_BSCAN_shift => '0',
  S_BSCAN_tdi => '0',
  S_BSCAN_update => '0',
  S_BSCAN_sel => '0',
  S_BSCAN_tdo => open,
  S_BSCAN_tms => '0',
  S_BSCAN_tck => '0',
  S_BSCAN_runtest => '0',
  S_BSCAN_reset => '0',
  S_BSCAN_capture => '0',
  S_BSCAN_bscanid_en=> '0'
  );

 u_shift: component shift
 port map (
  en => vs_shift_rm_reset,
  clk => clk_sys,
  addr => (others => '0'),
  data_out => open,
  led_rgb => led_rgb_2_i
  );

end STRUCTURE;
