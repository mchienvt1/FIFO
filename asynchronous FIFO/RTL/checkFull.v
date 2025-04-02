
module checkFull #(
  parameter WIDTH = 16,
  parameter PTR_WIDTH = 4
)(
  input wr_clk, wr_rst,
  input wr_en,
  input [PTR_WIDTH:0] rd_ptr_sync,
  output [PTR_WIDTH-1:0] wr_addr,
  output reg [PTR_WIDTH:0] wr_ptr_gray,
  output full
);
  
  reg [PTR_WIDTH:0] wr_ptr_bin;
  wire [PTR_WIDTH:0] wr_ptr_next, wr_ptr_gray_next;
  wire [PTR_WIDTH:0] rd_ptr_bin;

  // Chuyển mã Gray thành nhị phân
  function [PTR_WIDTH:0] gray_to_binary;
    input [PTR_WIDTH:0] gray;
    integer i;
    begin
      gray_to_binary[PTR_WIDTH] = gray[PTR_WIDTH]; // MSB giữ nguyên
      for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
        gray_to_binary[i] = gray_to_binary[i+1] ^ gray[i];
    end
  endfunction

  always @(posedge wr_clk or negedge wr_rst) begin
    if (!wr_rst) begin
      wr_ptr_bin <= 0;
    end else begin
      if (wr_en && !full) begin
        wr_ptr_bin <= wr_ptr_next;
      end
    end
  end

  always @(posedge wr_clk or negedge wr_rst) begin
    if (!wr_rst) begin
      wr_ptr_gray <= 0;
    end else begin
      wr_ptr_gray <= wr_ptr_gray_next;
    end
  end

  assign wr_ptr_next = wr_ptr_bin + (wr_en && !full);
  assign wr_ptr_gray_next = (wr_ptr_next >> 1) ^ wr_ptr_next;
  assign wr_addr = wr_ptr_bin[PTR_WIDTH-1:0];

  // Chuyển rd_ptr_sync (Gray) thành rd_ptr_bin (Binary)
  assign rd_ptr_bin = gray_to_binary(rd_ptr_sync);

  // Kiểm tra trạng thái full
  assign full = (wr_ptr_bin == {~rd_ptr_bin[PTR_WIDTH], rd_ptr_bin[PTR_WIDTH-1:0]}) ? 1'b1 : 1'b0;

endmodule