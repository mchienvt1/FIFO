module fifomem #(
  parameter WIDTH = 16,
  parameter DEPTH = 16
) (
  input wr_clk, wr_rst,
  input rd_clk, rd_rst,
  input [WIDTH-1:0] data_in,
  input wr_en,
  input rd_en,
  input full,
  input empty,
  input [PTR_WIDTH-1:0] wr_ptr,
  input [PTR_WIDTH-1:0] rd_ptr,
  output reg [WIDTH-1:0] data_out
);
  localparam PTR_WIDTH = $clog2(DEPTH);
  reg [WIDTH-1:0] mem [DEPTH-1:0];

  always @(posedge wr_clk) begin
    if(wr_en && !full) begin
      mem[wr_ptr] <= data_in;
    end
  end

  
  always @(posedge rd_clk) begin
    if(rd_en && !empty) begin
      data_out <= mem[rd_ptr];
    end
  end


endmodule