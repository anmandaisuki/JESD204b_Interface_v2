module AXIS_CONVERTION_INTERFACE_FOR_ADC #(
    parameter DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 16 
) (
    // AXIS Interface
        output wire  m_axis_aclk,
        input wire  m_axis_aresetn,

        output reg  m_axis_tvalid,
        output reg [DATAWIDTH - 1 : 0] m_axis_tdata,
        output reg  m_axis_tlast,
        input wire  m_axis_tready,

    // ADC interface
        input wire [DATAWIDTH - 1 : 0] i_adc_data,
        input wire  i_adc_data_clk,

    // Controll and Status
        input  wire i_con_axisside, // 1 : AXIS data is send if FIFO is not empty.          0 : AXIS data is NOT send.  
        input  wire i_con_adcside , // 1 : FIFO is written from ADC if FIFO is not full.    0 : FIFO is not written. 
        output wire o_status        // 1 : fifo is full. Should increase FIFO_DEPTH

);

assign m_axis_aclk = adc_data_clk;  // axis_aclk is correspond to adc_data_clk

reg [DATA_WIDTH-1:0] axis_send_data;
assign m_axis_tdata = fifo_read_data;
wire [DATA_WIDTH-1:0] fifo_read_data;

reg  i_ren;
wire i_wen;
wire o_empty;
wire o_full;

assign i_wen    = i_con_adcside & !o_full ;
assign o_status = o_full;



always @(posedge m_axis_aclk ) begin
    // Reset 
    if(!m_axis_aresetn)begin
        m_axis_tvalid <= 0;
        m_axis_tdata  <= 0;
        m_axis_tlast  <= 0;

        i_ren <= 0;

    end else begin
        if(i_con_axisside && !o_empty)begin
            m_axis_tvalid <= 1'b1;
            axis_send_data <= fifo_read_data;

            if(m_axis_tready == 1)begin
                i_ren <= 1'b1;
            end else begin
                i_ren <= 1'b0;
            end

        end else begin
            m_axis_tvalid <= 1'b0;
        end
    end
end



localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);

FIFO_SYNC #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) fifo_sync_inst (
    .clk(i_adc_data_clk),
    .i_rst(m_axis_aresetn),
    .i_wen(i_wen),
    .i_data(i_adc_data),
    .i_ren(i_ren),
    .o_data(fifo_read_data),
    .o_empty(o_empty),
    .o_full(o_full)
);
    
endmodule