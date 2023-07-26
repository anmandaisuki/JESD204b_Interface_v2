module jesd204b_lmfc_generator #(
    parameter JESD_F = 1,   // the number of octet per frame
    parameter JESD_K = 8,   // the number of frame per multi frame
    parameter DCLK_DIV = 4, // f_deviceclock@fpga * DCLK_DIV = f_deviceclocl@adc
    parameter LMFC_CNT_WIDTH = 8 // 
) (
    input wire dclk,   // from transceiver clock buffer 
    input wire sysref, // MRCC pin is recommanded

    output wire o_lmfc,
    output wire[LMFC_CNT_WIDTH-1:0] o_lmfc_cnt,
    output wire o_sysref_done
);

reg[LMFC_CNT_WIDTH:0] lmfc_cnt_double = 0;
assign o_lmfc_cnt = lmfc_cnt_double >> 1;
assign o_lmfc = lmfc_cnt_double[0];

localparam dclk_cnt_width = $clog2(((JESD_K * JESD_F)/DCLK_DIV)+1);
reg[dclk_cnt_width-1:0] dclk_cnt = 0;

reg sysref_done_flag = 0;
assign o_sysref_done = sysref_done_flag;

// generate LMFC clock inside of FPGA
always @(posedge dclk ) begin
    if(sysref) begin
        lmfc_cnt_double <= 1;
        dclk_cnt        <= 1;
        sysref_done_flag          <= 1'b1;
    end else begin
        sysref_done_flag <= 1'b0;
        dclk_cnt <= dclk_cnt + 1;
        if( dclk_cnt % (((JESD_K * JESD_F)/DCLK_DIV)/2) == 0) begin
            lmfc_cnt_double <= lmfc_cnt_double + 1;
        end
    end
end
    
endmodule