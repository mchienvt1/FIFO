module checkEmpty #(
  parameter WIDTH = 16,
  parameter PTR_WIDTH = 4
)(
  input rd_clk, rd_rst,
  input rd_en,
  input [PTR_WIDTH:0] wr_ptr_sync,
  output [PTR_WIDTH-1:0] rd_addr,
  output reg [PTR_WIDTH:0] rd_ptr_gray,
  output empty
);
  reg [PTR_WIDTH:0] rd_ptr_bin;
  wire [PTR_WIDTH:0] rd_ptr_next, rd_ptr_gray_next;
  wire [PTR_WIDTH:0] wr_ptr_bin;

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

  always @(posedge rd_clk or negedge rd_rst) begin
    if (!rd_rst) begin
      rd_ptr_bin <= 0;
    end
    else begin
      if (rd_en && !empty) begin
        rd_ptr_bin <= rd_ptr_next;
      end
    end
  end

  always @(posedge rd_clk or negedge rd_rst) begin
    if(!rd_rst) begin
      rd_ptr_gray <= 0;
    end
    else begin
      rd_ptr_gray <= rd_ptr_gray_next;
    end
  end

  assign rd_ptr_next = rd_ptr_bin + (rd_en && !empty);
  assign rd_ptr_gray_next = (rd_ptr_next >> 1) ^ rd_ptr_next;
  assign rd_addr = rd_ptr_bin[PTR_WIDTH-1:0];

  // Chuyển wr_ptr_sync (Gray) thành wr_ptr_bin (Binary)
  assign wr_ptr_bin = gray_to_binary(wr_ptr_sync);

  // Kiểm tra trạng thái empty
  assign empty = (rd_ptr_bin == wr_ptr_bin) ? 1'b1 : 1'b0;


endmodule