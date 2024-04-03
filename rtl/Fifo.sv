// Fifo.sv

`default_nettype none

module Fifo # (
  parameter int DLEN = 8,
  parameter int ALEN = 8
)(
  input var                     clk,
  input var                     rstn,

  input var                     i_wen,
  input var         [DLEN-1:0]  i_wdata,
  output var logic              o_wfull,

  input var                     i_ren,
  output var logic  [DLEN-1:0]  o_rdata,
  output var logic              o_rempty
);

/* Pointer Instantiation */
logic [ALEN-1:0]  waddr;
logic [ALEN:0]    wptr;
logic [ALEN-1:0]  raddr;
logic [ALEN:0]    rptr;

// Write Pointer
logic ram_wen;

WrPtr # (.ALEN(ALEN)) u_WR (
  .clk        (clk),
  .rstn       (rstn),
  .i_wen      (i_wen),
  .o_waddr    (waddr),
  .o_wptr     (wptr),
  .i_rptr     (rptr),
  .o_wfull    (o_wfull),
  .o_ram_wen  (ram_wen)
);

// Read Pointer
logic ram_ren;

RdPtr # (.ALEN(ALEN)) u_RD (
  .clk        (clk),
  .rstn       (rstn),
  .i_ren      (i_ren),
  .o_raddr    (raddr),
  .o_rptr     (rptr),
  .i_wptr     (wptr),
  .o_rempty   (o_rempty),
  .o_ram_ren  (ram_ren)
);


/* Memory Instantiation */
SdpRam1 # (
  .DLEN (DLEN),
  .ALEN (ALEN)
) u_RAM (
  .clk      (clk),
  .i_wen    (ram_wen),
  .i_waddr  (waddr),
  .i_wdata  (i_wdata),
  .i_ren    (ram_ren),
  .i_raddr  (raddr),
  .o_rdata  (o_rdata)
);

`ifdef SIMULATION
initial begin
  $dumpfile("waves.vcd");
  $dumpvars();
end
`endif

endmodule
