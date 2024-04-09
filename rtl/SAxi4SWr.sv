// SAxi4SWr.sv

`default_nettype none

module SAxi4SWr(
  axi4_stream_if.S  wr,

  output var logic                        o_wen,
  output var logic  [wr.AXI4SDATALEN-1:0] o_wdata,
  input var                               i_wfull
);

logic                       wvalid;
logic                       wready;
logic [wr.AXI4SDATALEN-1:0] wdata;
SkidBuffer # (
  .DLEN (wr.AXI4SDATALEN)
) u_WSB (
  .clk      (wr.aclk),
  .rstn     (wr.aresetn),
  .i_valid  (wr.tvalid),
  .o_ready  (wr.tready),
  .i_data   (wr.tdata),
  .o_valid  (wvalid),
  .i_ready  (wready),
  .o_data   (wdata)
);

always_comb begin
  wready = ~i_wfull;
  o_wen = wvalid & wready;
end

assign o_wdata = wdata;


endmodule
