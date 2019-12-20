`timescale 1 ps / 1 ps

module system_top
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    hdmi_data,
    hdmi_data_e,
    hdmi_hsync,
    hdmi_out_clk,
    hdmi_vsync,
    led1,
    phy_refclk_n,
    phy_refclk_p,
    reset,
    sfp0_rx_loss,
    sfp0_rxn,
    sfp0_rxp,
    sfp0_tx_disable,
    sfp0_tx_fault,
    sfp0_txn,
    sfp0_txp,
    sfp1_rx_loss,
    sfp1_rxn,
    sfp1_rxp,
    sfp1_tx_disable,
    sfp1_tx_fault,
    sfp1_txn,
    sfp1_txp);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output [15:0]hdmi_data;
  output hdmi_data_e;
  output hdmi_hsync;
  output hdmi_out_clk;
  output hdmi_vsync;
  output led1;
  input phy_refclk_n;
  input phy_refclk_p;
  input reset;
  input sfp0_rx_loss;
  input sfp0_rxn;
  input sfp0_rxp;
  output sfp0_tx_disable;
  input sfp0_tx_fault;
  output sfp0_txn;
  output sfp0_txp;
  input sfp1_rx_loss;
  input sfp1_rxn;
  input sfp1_rxp;
  output sfp1_tx_disable;
  input sfp1_tx_fault;
  output sfp1_txn;
  output sfp1_txp;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [15:0]hdmi_data;
  wire hdmi_data_e;
  wire hdmi_hsync;
  wire hdmi_out_clk;
  wire hdmi_vsync;
  wire led1;
  wire phy_refclk_n;
  wire phy_refclk_p;
  wire reset;
  wire sfp0_rx_loss;
  wire sfp0_rxn;
  wire sfp0_rxp;
  wire sfp0_tx_disable;
  wire sfp0_tx_fault;
  wire sfp0_txn;
  wire sfp0_txp;
  wire sfp1_rx_loss;
  wire sfp1_rxn;
  wire sfp1_rxp;
  wire sfp1_tx_disable;
  wire sfp1_tx_fault;
  wire sfp1_txn;
  wire sfp1_txp;

  system system_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .hdmi_data(hdmi_data),
        .hdmi_data_e(hdmi_data_e),
        .hdmi_hsync(hdmi_hsync),
        .hdmi_out_clk(hdmi_out_clk),
        .hdmi_vsync(hdmi_vsync),
        .led1(led1),
        .phy_refclk_n(phy_refclk_n),
        .phy_refclk_p(phy_refclk_p),
        .reset(reset),
        .sfp0_rx_loss(sfp0_rx_loss),
        .sfp0_rxn(sfp0_rxn),
        .sfp0_rxp(sfp0_rxp),
        .sfp0_tx_disable(sfp0_tx_disable),
        .sfp0_tx_fault(sfp0_tx_fault),
        .sfp0_txn(sfp0_txn),
        .sfp0_txp(sfp0_txp),
        .sfp1_rx_loss(sfp1_rx_loss),
        .sfp1_rxn(sfp1_rxn),
        .sfp1_rxp(sfp1_rxp),
        .sfp1_tx_disable(sfp1_tx_disable),
        .sfp1_tx_fault(sfp1_tx_fault),
        .sfp1_txn(sfp1_txn),
        .sfp1_txp(sfp1_txp));
endmodule
