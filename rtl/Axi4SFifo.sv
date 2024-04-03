// Fifo.sv

`default_nettype none

module Axi4SFifo # (
  parameter int AXI4SDATALEN = 32,
  parameter int BLEN = 8,
  parameter int WLEN = AXI4SDATALEN / BLEN,
  parameter int DLEN = AXI4SDATALEN,
  parameter int MLEN = 128,
  parameter int ALEN = $clog2(MLEN),
  parameter int ENDIAN = 0
)(
  input var         aclk,
  input var         aresetn,

  // Write Interface
  if_axi4_stream.S  wr,

  // Read Interface
  if_axi4_stream.M  rd
);

logic             wvalid;
logic             wready;
logic [DLEN-1:0]  wdata;
ElasticBuffer # (
  .DLEN (AXI4SDATALEN)
) u_WRBUF (
  .clk      (aclk),
  .rstn     (aresetn),
  .i_valid  (wr.tvalid),
  .o_ready  (wr.tready),
  .i_data   (wr.tdata),
  .o_valid  (wvalid),
  .i_ready  (wready),
  .o_data   (wdata)
);


// Write Pointer
logic             wen;
always_comb begin
  wen = wvalid & wready;
end


logic [ALEN-1:0]  waddr;
logic [ALEN-1:0]  raddr;
logic             wfull;
WrPtr # (
  .ALEN (ALEN),
  .INCR (WLEN)
) u_WR (
  .clk      (aclk),
  .rstn     (aresetn),
  .i_wen    (wen),
  .o_waddr  (waddr),
  .i_raddr  (raddr),
  .o_wfull  (wfull)
);

assign wready = ~wfull;

// Read Pointer
logic ren;
logic rvalid;
logic rready;

always_comb begin
  ren = rvalid & rready;
end

logic rempty;
RdPtr # (
  .ALEN (ALEN),
  .INCR (WLEN)
) u_RD (
  .clk      (aclk),
  .rstn     (aresetn),
  .i_ren    (ren),
  .o_raddr  (raddr),
  .i_waddr  (waddr),
  .o_rempty (rempty)
);

logic [2:0] rst_ct;
logic rst_rdy;

always_comb begin
  rst_rdy = &rst_ct;
end

always_ff @(posedge aclk) begin
  if (!aresetn) begin
    rst_ct <= 0;
  end else begin
    if (rst_rdy) begin
      rst_ct <= rst_ct;
    end else begin
      rst_ct <= rst_ct + 1;
    end
  end
end

assign rvalid = rst_rdy & ~rempty;

// Ram
logic [DLEN-1:0] rdata;
SdpRam1 # (
  .BLEN (BLEN),
  .WLEN (WLEN),
  .MLEN (MLEN)
) u_RAM (
  .clk      (aclk),
  .rstn     (aresetn),
  .i_wen    (wen),
  .i_waddr  (waddr),
  .i_wdata  (wdata),
  .i_ren    (ren),
  .i_raddr  (raddr),
  .o_rdata  (rdata)
);


SkidBuffer #(
  .DLEN(DLEN)
) u_RDBUF (
  .clk      (aclk),
  .rstn     (aresetn),
  .i_valid  (rvalid),
  .o_ready  (rready),
  .i_data   (rdata),
  .o_valid  (rd.tvalid),
  .i_ready  (rd.tready),
  .o_data   (rd.tdata)
);

// assign rd.tvalid = rvalid;
// assign rready = rd.tready;
// assign rd.tdata = rdata;


endmodule
