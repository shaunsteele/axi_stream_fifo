// MAxi4SRd.sv

`default_nettype none

module MAxi4SRd(
  axi4_stream_if.M                        rd,

  output var logic                        o_ren,
  input var         [rd.AXI4SDATALEN-1:0] i_rdata,
  input var                               i_rempty
);

logic                       rvalid;
logic                       rready;
logic [rd.AXI4SDATALEN-1:0] rdata;
always_comb begin
  rvalid = ~i_rempty;
  o_ren = rvalid & rready;
end

assign rdata = i_rdata;

SkidBuffer # (
  .DLEN (rd.AXI4SDATALEN)
) u_RSB (
  .clk        (rd.aclk),
  .rstn       (rd.aresetn),
  .i_valid  (rvalid),
  .o_ready  (rready),
  .i_data   (rdata),
  .o_valid  (rd.tvalid),
  .i_ready  (rd.tready),
  .o_data   (rd.tdata)
);

endmodule
