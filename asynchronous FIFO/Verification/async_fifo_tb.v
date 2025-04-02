`timescale 1ns/1ps

module async_fifo_tb;

  parameter WIDTH = 4;
  parameter DEPTH = 8;

  // Clock and reset signals
  reg wr_clk, rd_clk;
  reg wr_rst, rd_rst;
  reg wr_en, rd_en;

  // Data signals
  reg [WIDTH-1:0] data_in;
  wire [WIDTH-1:0] data_out;
  wire full, empty;


  // Instantiate the FIFO
  async_fifo #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) uut (
    .wr_clk(wr_clk),
    .wr_rst(wr_rst),
    .wr_en(wr_en),
    .data_in(data_in),
    .full(full),

    .rd_clk(rd_clk),
    .rd_rst(rd_rst),
    .rd_en(rd_en),
    .data_out(data_out),
    .empty(empty)
  );

  // Clock generation
  always #10 wr_clk = ~wr_clk;  // Write clock with a 20ns period
  always #16 rd_clk = ~rd_clk;  // Read clock with a 60ns period

  // Task: Write data into FIFO and store in expected_data
  task write_fifo(input integer num_writes);
    integer i;
    begin
      for (i = 0; i < num_writes; i = i + 1) begin
        @(negedge wr_clk);
        if (!full) begin
          wr_en = 1;
          data_in = $urandom % 16;
          $display("Time = %t: Writing data: %d", $time, data_in);
        end else begin
          $display("Time = %t: FIFO full, cannot write!", $time);
          wr_en = 0;
        end
      end
    end
  endtask

  // Task: Read data from FIFO and compare with expected_data
  task read_fifo(input integer num_reads);
    integer i;
    begin
      for (i = 0; i < num_reads; i = i + 1) begin
        @(negedge rd_clk);
        if (!empty) begin
          rd_en = 1;
          $display("Time = %t: Data out: %d", $time, data_out);
        end else begin
          $display("Time = %t: FIFO empty, cannot read!", $time);
          rd_en = 0;
        end
      end
    end
  endtask

  initial begin
    // Initialize signals
    wr_clk = 0;
    rd_clk = 0;
    wr_rst = 0;
    rd_rst = 0;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;


    // Apply reset
    #50;
    wr_rst = 0;
    rd_rst = 0;

    #30;
    wr_rst = 1;
    rd_rst = 1;

    #20;

    // Test scenario: Normal operation
    $display("Starting normal operation test...");
    write_fifo(DEPTH+2); // write full
    read_fifo(DEPTH+4); // read full
    #50;
    //Simultaneous write and read
    fork
    write_fifo(DEPTH+8); // write full
    read_fifo(DEPTH+4); // read full
    join

    // End simulation
    $display("All tests completed.");
    #200;
    $finish;
  end

  // Waveform generation
  initial begin
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);
  end

endmodule
