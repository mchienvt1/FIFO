module async_fifo #(
  parameter WIDTH = 16,
  parameter DEPTH = 16
) (
  input wr_clk, wr_rst,
  input rd_clk, rd_rst,
  input [WIDTH-1:0] data_in,
  input wr_en,
  input rd_en,
  output [WIDTH-1:0] data_out,
  output full,
  output empty
);
  localparam PTR_WIDTH = $clog2(DEPTH);

wire [PTR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;
wire [PTR_WIDTH:0] wr_ptr_sync, rd_ptr_sync;
wire [PTR_WIDTH-1:0] wr_ptr, rd_ptr;

fifomem #(
  .WIDTH(WIDTH),
  .DEPTH(DEPTH)
) mem (
  .wr_clk(wr_clk),
  .wr_rst(wr_rst),
  .rd_clk(rd_clk),
  .rd_rst(rd_rst),
  .data_in(data_in),
  .wr_en(wr_en),
  .rd_en(rd_en),
  .full(full),
  .empty(empty),
  .wr_ptr(wr_ptr),
  .rd_ptr(rd_ptr),
  .data_out(data_out)
);

sync_2flops #(
  .PTR_WIDTH(PTR_WIDTH)
) sync_2flops_wr (
  .clk(wr_clk),
  .rst(wr_rst),
  .data_in(rd_ptr_gray),
  .data_out(rd_ptr_sync)
);

sync_2flops #(
  .PTR_WIDTH(PTR_WIDTH)
) sync_2flops_rd (
  .clk(rd_clk),
  .rst(rd_rst),
  .data_in(wr_ptr_gray),
  .data_out(wr_ptr_sync)
);

checkFull #(
  .WIDTH(WIDTH),
  .PTR_WIDTH(PTR_WIDTH)
) wr_Full (
  .wr_clk(wr_clk),
  .wr_rst(wr_rst),
  .wr_en(wr_en),
  .rd_ptr_sync(rd_ptr_sync),
  .wr_addr(wr_ptr),
  .wr_ptr_gray(wr_ptr_gray),
  .full(full)
);


checkEmpty #(
  .WIDTH(WIDTH),
  .PTR_WIDTH(PTR_WIDTH)
) rd_empty (
  .rd_clk(rd_clk),
  .rd_rst(rd_rst),
  .rd_en(rd_en),
  .wr_ptr_sync(wr_ptr_sync),
  .rd_addr(rd_ptr),
  .rd_ptr_gray(rd_ptr_gray),
  .empty(empty)
);



endmodule