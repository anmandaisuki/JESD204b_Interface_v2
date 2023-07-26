`timescale 1ps/1ps


module jesd204b_rx_controller_tb ();

localparam LINE_RATE_PS = 50  ;  // 50 ps => 10 GHz. ( = 1000 /(50ps * 2))
localparam DCLK_RATE_PS = 2000;  // 2000 ps => 250 MHz ( 0.25 GHz = 1000 / (2000ps * 2) )
localparam FREERUN_RATE_PS = 2000;

localparam SYSREF_START = 50000000;
localparam INIT_PROCESS_START = 100; // ns


localparam FMLC_CNT_WIDTH = 8;

reg gty_rxp = 1'b0;
wire gty_rxn;
wire io_nsync,o_data_clk,o_data_from_transceiver;
assign gty_rxn =! gty_rxp;

reg dclk = 1'b0;
reg freerunclk = 1'b0;

reg i_sysref = 1'b0;

task init_dclk();
 begin
    dclk = 1'b0;
    i_sysref = 1'b0;
    forever #(DCLK_RATE_PS) dclk =! dclk; 
 end
endtask

task init_freerunclk();
 begin
    freerunclk = 1'b0;
    i_sysref = 1'b0;
    forever #(FREERUN_RATE_PS) freerunclk =! freerunclk; 
 end
endtask

reg [9:0] K285_p = 10'b0101111100;
reg [9:0] K285_n = 10'b1010000011;
reg [19:0] K285_both = {K285_p,K285_n};

//reg [19:0] K285_both = 20'b10100000110101111100;

reg lane_clk;
reg [4:0]K28_cnt = 0;
initial begin
    lane_clk = 1'b0;
    #(10);
//    forever #(63) lane_clk =! lane_clk;
    forever #(LINE_RATE_PS) lane_clk =! lane_clk;
end

always @(posedge lane_clk) begin
    if(K28_cnt > 19)begin
        K28_cnt <= 1;
        gty_rxp <= K285_both[0];
    end else begin
        gty_rxp <= K285_both[K28_cnt];
        K28_cnt <= K28_cnt + 1;    
    end
end


initial begin 
    fork
        init_dclk();
    join_none
    
    #(SYSREF_START);
    i_sysref = 1'b1;
    #(DCLK_RATE_PS * 10);
    i_sysref = 1'b0;
    #(1000);
//    $finish;
end

jesd204b_rx_controller #(
    .DIV_DCLK  (4),   
    .FRAME_SIZE(1),   
    .FMLC_NUM  (8)
) jesd_rx_controller_inst(
    // External for Transceiver
    .i_gtyrxn_in(gty_rxn),
    .i_gtyrxp_in(gty_rxp),
    .i_gtrefclk00_in(dclk),
    .i_clk_freerun(freerunclk), 

    // External for JESD204B core
    .io_nsync(io_nsync),
    .i_sysref(i_sysref),

    // Interface for User Logic or AXI(S) Convertion Logic
    .o_data_clk(o_data_clk),
    .o_data_from_transceiver(o_data_from_transceiver)
);
    
endmodule