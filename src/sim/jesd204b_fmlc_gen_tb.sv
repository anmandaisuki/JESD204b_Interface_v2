`timescale 1ns/100ps

module jesd204b_fmlc_gen_tb ();

localparam DCLK_FREQ = 2;
localparam FMLC_CNT_WIDTH = 8;

reg dclk,sysref;

wire fmlc;


task init_dclk();
 begin
    dclk = 1'b0;
    sysref = 1'b0;
    #(10);
    forever #(DCLK_FREQ/2) dclk =! dclk; 
 end
endtask

initial begin 
    fork
        init_dclk();
    join_none
    
    #(101);
    sysref = 1'b1;
    #(0.5);
    sysref = 1'b0;
    
    #(100);
    $finish;
    
end

jesd204b_fmlc_generator #(
    .JESD_F(1),   // the number of octet per frame
    .JESD_K(16),   // the number of frame per multi frame
    .DCLK_DIV(2), // f_deviceclock@fpga * DCLK_DIV = f_deviceclocl@adc
    .FMLC_CNT_WIDTH(FMLC_CNT_WIDTH) // 
)jesd_inst (
    .dclk(dclk),
    .sysref(sysref),

    .o_fmlc(fmlc),
    .o_fmlc_cnt()
);
    
endmodule