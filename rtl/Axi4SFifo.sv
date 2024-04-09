// Fifo.sv

`default_nettype none

module Axi4SFifo # (
  parameter int FIFO_ALEN = 1
)(
  input var         aclk,
  input var         aresetn,

  // Write Interface
  axi4_stream_if.S  wr,

  // Read Interface
  axi4_stream_if.M  rd
);

initial begin
  assert (wr.AXI4SDATALEN == rd.AXI4SDATALEN);
end

/* AXI4 Stream Slave Write Wrapper */
logic                       wen;
logic [wr.AXI4SDATALEN-1:0] wdata;
logic                       wfull;
SAxi4SWr u_WR (
  .wr       (wr),
  .o_wen    (wen),
  .o_wdata  (wdata),
  .i_wfull  (wfull)
);

/* AXI4 Stream Master Read Wrapper */
logic                       ren;
logic [rd.AXI4SDATALEN-1:0] rdata;
logic                       rempty;
MAxi4SRd u_RD (
  .rd       (rd),
  .o_ren    (ren),
  .i_rdata  (rdata),
  .i_rempty (rempty)
);

/* FIFO */
FifoCore # (
  .ALEN   (FIFO_ALEN),
  .DLEN   (wr.AXI4SDATALEN),
  .INCR   (1)
) u_FIFO (
  .clk          (aclk),
  .rstn         (aresetn),
  .i_wen        (wen),
  .i_wdata      (wdata),
  .o_wfull      (wfull),
  .o_woverflow  (),
  .i_ren        (ren),
  .o_rdata      (rdata),
  .o_rempty     (rempty),
  .o_runderflow ()
);


endmodule
