module sync_fifo #(
  parameter WIDTH = 8,
  parameter DEPTH = 16
)(
  input clk,rst,
  input [WIDTH-1:0] data_in,
  output reg [WIDTH-1:0] data_out,
  input wr_en,
  input rd_en,
  output full,
  output empty,
  output reg [4:0] count
);
  localparam PTR_WIDTH = $clog2(DEPTH);
  reg [WIDTH-1:0] mem [DEPTH-1:0];
  reg [PTR_WIDTH:0] wr_ptr,rd_ptr;

  always @(posedge clk or negedge rst) begin
    if(!rst) begin
      data_out <= 0;
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
    end
    else begin
      if(wr_en && !full) begin
        mem[wr_ptr[PTR_WIDTH-1:0] % DEPTH] <= data_in;
        wr_ptr <= wr_ptr + 1;
        count +=1;
      end
      if(rd_en && !empty) begin
        data_out <= mem[rd_ptr[PTR_WIDTH-1:0] % DEPTH];
        rd_ptr <= rd_ptr + 1;
        count -= 1;
      end
    end
  end

  assign full = (wr_ptr - rd_ptr == DEPTH || rd_ptr - wr_ptr == DEPTH);
  assign empty = (wr_ptr == rd_ptr);

endmodule