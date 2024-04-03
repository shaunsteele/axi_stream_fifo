// TbWrPtr.sv

`default_nettype none

module TbWrPtr;


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

/* DUT Instantiation */
// Parameters
parameter int ALEN = 8;
parameter int INCR = 1;

// Inputs
bit wen;
bit [ALEN:0]    rptr;

// Outputs
bit [ALEN-1:0]  waddr;
bit [ALEN:0]    wptr;
bit             wfull;
bit             ram_wen;

WrPtr # (
  .ALEN (ALEN),
  .INCR (INCR)
) u_DUT (
  .clk        (clk),
  .rstn       (rstn),
  .i_wen      (wen),
  .o_waddr    (waddr),
  .o_wptr     (wptr),
  .i_rptr     (rptr),
  .o_wfull    (wfull),
  .o_ram_wen  (ram_wen)
);


/* Test Cases */
int full_fifo_limit = 2 ** ALEN;

initial begin
  wen = 0;
  rptr = 0;

  wait (rstn);

  for (int i=0; i < full_fifo_limit; i++) begin
    @(negedge clk);
    wen = 1;
  end

  @(negedge clk);
  wen = 0;

  @(negedge clk);
  rptr = wptr;

  for (int i=0; i < full_fifo_limit + 1; i++) begin
    @(negedge clk);
    wen = 1;
  end

  @(negedge clk);
  wen = 0;

  @(negedge clk);

  $finish;
end

initial begin
  $monitor(
    "[%0t] wen: %b\twaddr: 0x%02h\twptr: 0x%02h\twfull: %b\tram_wen: %b",
    $realtime, wen, waddr, wptr, wfull, ram_wen
    );
end

endmodule
