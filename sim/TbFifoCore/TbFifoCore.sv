// TbFifoCore.sv

`default_nettype none

module TbFifoCore;

parameter int TIMEOUT = 10000;
initial begin
  #TIMEOUT;
  $error("SIMULATION TIMEOUT");
  $finish(1);
end

/* Clock Generation */
parameter int CLKT = 10;
bit clk;
initial begin
  clk = 0;
  #CLKT;
  forever #(CLKT/2) clk = ~clk;
end

/* Reset Generation */
parameter int RESET_CYCLES = 10;
bit rstn;
initial begin
  rstn = 0;
  repeat (RESET_CYCLES) @(negedge clk);
  rstn = 1;
end

/* DUT */
// Parameters
parameter int ALEN = 4;
parameter int DLEN = 8;
parameter int INCR = 1;

// Inputs
bit             i_wen;
bit [DLEN-1:0]  i_wdata;
bit             i_ren;

// Outputs
bit             o_wfull;
bit             o_woverflow;
bit [DLEN-1:0]  o_rdata;
bit             o_rempty;
bit             o_runderflow;

// Instantiation
FifoCore # (
  .ALEN (ALEN),
  .DLEN (DLEN),
  .INCR (INCR)
) u_DUT (
  .clk          (clk),
  .rstn         (rstn),
  .i_wen        (i_wen),
  .i_wdata      (i_wdata),
  .o_wfull      (o_wfull),
  .o_woverflow  (o_woverflow),
  .i_ren        (i_ren),
  .o_rdata      (o_rdata),
  .o_rempty     (o_rempty),
  .o_runderflow (o_runderflow)
);

/* Test Cases */
localparam FifoSize = 2 ** ALEN;

function void reset_inputs();
  i_wen = 0;
  i_wdata = 0;
  i_ren = 0;
endfunction

initial begin
  bit [7:0] simple_buf;
  bit [7:0] array_buf[FifoSize];
  reset_inputs();

  wait (rstn);


// Simple Write then Read
  $display("[%06t]\t### Simple Write/Read Test ###", $realtime);

  simple_buf = $urandom();
  reset_inputs();

  @(negedge clk);
  i_wdata = simple_buf;
  i_wen = 1;

  @(negedge clk);
  i_wen = 0;

  @(negedge clk);
  i_ren = 1;

  @(negedge clk);
  i_ren = 0;
  assert (o_rdata == simple_buf);
  $display("[%06t]\t### Passed Simple Write/Read Test ###\n", $realtime);


// Write until Full
  $display("[%06t]\t### Full Test ###", $realtime);

  foreach (array_buf[i]) begin
    array_buf[i] = $urandom();
  end

  reset_inputs();
  
  foreach (array_buf[i]) begin
    @(negedge clk);
    i_wen = 1;
    i_wdata = array_buf[i];
  end

  @(negedge clk);
  i_wen = 0;
  assert (o_wfull);
  $display("[%06t]\t### Passed Full Test ###\n", $realtime);


// Write Overflow
  $display("[%06t]\t### Overflow Test ###", $realtime);

  reset_inputs();

  @(negedge clk);
  i_wen = 1;

  @(negedge clk);
  i_wen = 0;
  assert (o_woverflow);
  $display("[%06t]\t### Passed Overflow Test ###\n", $realtime);


// Read until Empty
  $display("[%06t]\t### Empty Test ###", $realtime);

  reset_inputs();
  
  @(negedge clk);
  i_ren = 1;
  foreach (array_buf[i]) begin
    @(negedge clk);
    i_ren = 1;
    assert (o_rdata == array_buf[i]);
  end
  i_ren = 0;
  assert (o_rempty);
  $display("[%06t]\t### Passed Empty Test ###\n", $realtime);


// Read Underflow
  $display("[%06t]\t### Underflow Test ###", $realtime);
  
  reset_inputs();

  @(negedge clk);
  i_ren = 1;

  @(negedge clk);
  i_ren = 0;
  assert (o_runderflow);
  $display("[%06t]\t### Passed Underflow Test ###\n", $realtime);

// Reset Overflow and Underflow bits
  $display("[%06t]\t### Reset Test ###", $realtime);

  reset_inputs();

  @(negedge clk);
  rstn = 0;

  @(negedge clk);
  rstn = 1;
  assert (!o_woverflow && !o_runderflow);  
  $display("[%06t]\t### Passed Reset Test ###\n", $realtime);

// Finish
  @(posedge clk);
  $finish;
end


initial begin
  $timeformat(-9, 2, " ns", 20);
  $monitor(
    "[%06t]\trstn: %b\ti_wen: %b\ti_wdata: 0x%02h\to_wfull: %b\t \
    o_woverflow: %b\ti_ren: %b\to_rdata: 0x%02h\to_rempty: %b\t \
    o_runderflow: %b",
    $realtime, rstn, i_wen, i_wdata, o_wfull, o_woverflow, i_ren, o_rdata,
    o_rempty, o_runderflow
    );
end

endmodule
