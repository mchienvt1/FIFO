module sync_2flops #(
  parameter PTR_WIDTH = 4
) (
  input clk, rst,
  input [PTR_WIDTH:0] data_in,
  output reg [PTR_WIDTH:0] data_out
);

  reg [PTR_WIDTH:0] data_out_1;
  always @(posedge clk or negedge rst) begin
    if(!rst) begin
      data_out <= 0;
      data_out_1 <= 0;
    end else begin
      data_out_1 <= data_in;
      data_out <= data_out_1;
    end
  end
endmodule