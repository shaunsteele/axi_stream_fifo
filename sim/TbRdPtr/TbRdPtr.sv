// TbRdPtr.sv

`default_nettype none

module TbRdPtr;


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
parameter int ALEN = 8;
parameter int INCR = 1;

// Inputs
bit ren;
bit [ALEN:0]    wptr;

// Outputs
bit [ALEN-1:0]  raddr;
bit [ALEN:0]    rptr;
bit             rempty;
bit             runderflow;
bit             ram_ren;

// Instantiation
RdPtr # (
  .ALEN (ALEN),
  .INCR (INCR)
) u_DUT (
  .clk          (clk),
  .rstn         (rstn),
  .i_ren        (ren),
  .o_raddr      (raddr),
  .o_rptr       (rptr),
  .i_wptr       (wptr),
  .o_rempty     (rempty),
  .o_runderflow (runderflow),
  .o_ram_ren    (ram_ren)
);


/* Test Cases */
int full_fifo_limit = 2 ** ALEN;

initial begin
  ren = 0;
  wptr = full_fifo_limit -  1;

  wait (rstn);

  for (int i=0; i < full_fifo_limit; i++) begin
    @(negedge clk);
    ren = 1;
  end

  @(negedge clk);
  ren = 0;

  @(negedge clk);
  wptr = rptr;

  @(negedge clk);

  $finish;
end

initial begin
  $monitor(
    "[%0t] ren: %b\traddr: 0x%02h\trptr: 0x%02h\trempty: %b\trunderflow: %b\tram_ren: %b",
    $realtime, ren, raddr, rptr, rempty, runderflow, ram_ren
    );
end

endmodule
