module syn_fifo_tb;

  parameter WIDTH = 16;
  parameter DEPTH = 10;
  parameter clkp = 40;

  // Inputs
  reg clk, rst;
  reg [WIDTH-1:0] data_in;
  reg write_en, read_en;

  // Outputs
  wire [WIDTH-1:0] data_out;
  wire full, empty;

  // Memory for data comparison
  reg [WIDTH-1:0] mem [0:DEPTH-1]; // Fixed-size array
  integer mem_head = 0; // Pointer for writing to the array
  integer mem_tail = 0; // Pointer for reading from the array

  // FIFO instance
  sync_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) s_fifo (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out),  
    .wr_en(write_en),
    .rd_en(read_en),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #(clkp / 2) clk = ~clk;

  // Test procedure
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 0;
    data_in = 0;
    write_en = 0;
    read_en = 0;

    // Apply reset
    repeat(5) @(posedge clk);
    rst = 1;

    // Case 1: Write until FIFO is full
    @(negedge clk) write_en = 1;

    for (integer i = 0; i < DEPTH + 5; i = i + 1) begin
      @(posedge clk);
      data_in = $urandom % 256;
      if (!full && write_en) begin
        mem[mem_head] = data_in; // Store data in memory
        mem_head = (mem_head + 1) % DEPTH;
      end
    end
    write_en = 0;


    // Case 2: Read until FIFO is empty
    repeat(5) @(posedge clk);
    read_en = 1;

    for (integer j = 0; j < DEPTH + 5; j = j + 1) begin
      @(posedge clk);
      if (!empty && read_en) begin
        if (mem[mem_tail] == data_out)
          $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h", $time, mem[mem_tail], data_out);
        else
          $display("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, mem[mem_tail], data_out);
        mem_tail = (mem_tail + 1) % DEPTH;
      end
    end
    read_en = 0;

    // Case 3: Write and Read Alternating
    repeat(5) @(posedge clk);
    @(negedge clk) write_en = 1;
    read_en = 1;
    for (integer k = 0; k < DEPTH * 2; k = k + 1) begin
      @(posedge clk);
      data_in = $urandom % 256;
      if (!full && write_en) begin
        mem[mem_head] = data_in;
        mem_head = (mem_head + 1) % DEPTH;
      end
      if (!empty && read_en) begin
        if (mem[mem_tail] == data_out)
          $display("Time = %0t: Alternating R/W Passed: wr_data = %h and rd_data = %h", $time, mem[mem_tail], data_out);
        else
          $display("Time = %0t: Alternating R/W Failed: expected wr_data = %h, rd_data = %h", $time, mem[mem_tail], data_out);
        mem_tail = (mem_tail + 1) % DEPTH;
      end
    end
    @(negedge clk) write_en = 0;
    read_en = 0;

    // Case 4: Reset during operation
    repeat(5) @(posedge clk);
    @(negedge clk) rst = 0;
    repeat(5) @(posedge clk);
    @(negedge clk) rst = 1;

    // Final delay before ending simulation
    #1000;
    $finish;
  end

  // Dump waveforms
  initial begin
    $dumpfile("sync_fifo_tb.vcd");
    $dumpvars(0, syn_fifo_tb);
  end

endmodule