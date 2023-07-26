`timescale 1ns/100ps

module gtwizard_ulatrascale_0_tb ();

localparam freerun_freq = 200; // MHz
localparam reset_release = 5247.5;
localparam tx_active_in_start = 6092;
localparam tx_active_in_stop = 8800;
localparam tx_active_in_restart = 9212;

reg gtwiz_reset_clk_freerun_in;
reg gtwiz_reset_all_in;
reg gtrefclk00_in;
reg i_gtyrxp_in,i_gtyrxn_in,gtwiz_userclk_tx_active_in,gtwiz_userclk_rx_active_in;

// rest_all_in
initial begin
    gtwiz_reset_all_in = 1'b1;
    #(reset_release);
    gtwiz_reset_all_in = 1'b0;
end

// clk_freerun_in
initial begin
    gtwiz_reset_clk_freerun_in = 1'b0;
    forever #(500/freerun_freq) gtwiz_reset_clk_freerun_in =! gtwiz_reset_clk_freerun_in;
end

// gtrefclk
initial begin
    gtrefclk00_in = 1'b0;
    forever #(500/freerun_freq) gtrefclk00_in =! gtrefclk00_in;
end

// 
initial begin
    i_gtyrxn_in = 1'b1;
    i_gtyrxp_in = 1'b1;
end

initial begin 
    gtwiz_userclk_tx_active_in = 1'b1;
    gtwiz_userclk_rx_active_in = 1'b1;
    //#(tx_active_in_start)  gtwiz_userclk_tx_active_in = 1'b1;
    //gtwiz_userclk_rx_active_in = 1'b1;
    // #(tx_active_in_stop)  gtwiz_userclk_tx_active_in = 1'b0;
    // #(tx_active_in_restart)  gtwiz_userclk_tx_active_in = 1'b1;
    
end

gtwizard_ultrascale_0 gty_inst (
  .gtwiz_userclk_tx_active_in(gtwiz_userclk_tx_active_in),                  // 
  .gtwiz_userclk_rx_active_in(gtwiz_userclk_rx_active_in),                  // 
  .gtwiz_reset_clk_freerun_in(gtwiz_reset_clk_freerun_in),                  // 
  .gtwiz_reset_all_in(gtwiz_reset_all_in),                                  // 
  .gtwiz_reset_tx_pll_and_datapath_in(1'b0),  // 0
  .gtwiz_reset_tx_datapath_in(1'b0),                  // 0
  .gtwiz_reset_rx_pll_and_datapath_in(1'b0),  // 0
  .gtwiz_reset_rx_datapath_in(1'b0),                  // 0
  .gtwiz_reset_rx_cdr_stable_out(gtwiz_reset_rx_cdr_stable_out),            // DNC
  .gtwiz_reset_tx_done_out(gtwiz_reset_tx_done_out),                        // output wire [0 : 0] gtwiz_reset_tx_done_out
  .gtwiz_reset_rx_done_out(gtwiz_reset_rx_done_out),                        // output wire [0 : 0] gtwiz_reset_rx_done_out
  .gtwiz_userdata_tx_in(gtwiz_userdata_tx_in),                              // input wire [127 : 0] gtwiz_userdata_tx_in
  .gtwiz_userdata_rx_out(gtwiz_userdata_rx_out),                            // output wire [127 : 0] gtwiz_userdata_rx_out
  .gtrefclk00_in(gtrefclk00_in),                                            // 
  .qpll0outclk_out(qpll0outclk_out),                                        // not necessary
  .qpll0outrefclk_out(qpll0outrefclk_out),                                  // not necessary
  .gtyrxn_in(i_gtyrxn_in),                                                    // 
  .gtyrxp_in(i_gtyrxp_in),                                                    // 
  .rx8b10ben_in(1'b1),                                                      // 1
  .rxcommadeten_in(1'b1),                                                   // 1
  .rxmcommaalignen_in(rxmcommaalignen_in),                                  // 
  .rxpcommaalignen_in(rxpcommaalignen_in),                                  // 
  .rxusrclk_in(gtwiz_reset_clk_freerun_in),                                                // 
  .rxusrclk2_in(gtwiz_reset_clk_freerun_in),                                              // 
  .tx8b10ben_in(1'b1),                                              // input wire [3 : 0] tx8b10ben_in
  .txctrl0_in(txctrl0_in),                                                  // input wire [63 : 0] txctrl0_in
  .txctrl1_in(txctrl1_in),                                                  // input wire [63 : 0] txctrl1_in
  .txctrl2_in(txctrl2_in),                                                  // input wire [31 : 0] txctrl2_in
  .txusrclk_in(gtwiz_reset_clk_freerun_in),                                                // input wire [3 : 0] txusrclk_in
  .txusrclk2_in(gtwiz_reset_clk_freerun_in),                                              // input wire [3 : 0] txusrclk2_in
  .gtpowergood_out(gtpowergood_out),                                        // 
  .gtytxn_out(gtytxn_out),                                                  // not necessary (this port is only for GTY transceiver)
  .gtytxp_out(gtytxp_out),                                                  // 
  .rxbyteisaligned_out(rxbyteisaligned_out),                                // 
  .rxbyterealign_out(rxbyterealign_out),                                    // not necessariliy used
  .rxcommadet_out(rxcommadet_out),                                          // 
  .rxctrl0_out(rxctrl0_out),                                                //  
  .rxctrl1_out(rxctrl1_out),                                                //  
  .rxctrl2_out(rxctrl2_out),                                                //  
  .rxctrl3_out(rxctrl3_out),                                                //  
  .rxoutclk_out(rxoutclk_out),                                              // output wire [3 : 0] rxoutclk_out
  .rxpmaresetdone_out(rxpmaresetdone_out),                                  // output wire [3 : 0] rxpmaresetdone_out
  .txoutclk_out(txoutclk_out),                                              // output wire [3 : 0] txoutclk_out
  .txpmaresetdone_out(txpmaresetdone_out)                                  // output wire [3 : 0] txpmaresetdone_out
);
    
endmodule