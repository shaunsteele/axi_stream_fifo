// axi4_stream_if.sv

`default_nettype none

interface axi4_stream_if # (
  parameter int AXI4SDATALEN  = 32,
  parameter int AXI4SSTRBLEN  = AXI4SDATALEN / 8,
  parameter int AXI4SKEEPLEN  = AXI4SDATALEN / 8,
  parameter int AXI4SIDLEN    = 2,
  parameter int AXI4SDESTLEN  = 4,
  parameter int AXI4SUSERLEN  = 8
)(
  input var aclk,
  input var aresetn
);

logic                     tvalid;
logic                     tready;
logic [AXI4SDATALEN-1:0]  tdata;
logic [AXI4SSTRBLEN-1:0]  tstrb;
logic [AXI4SKEEPLEN-1:0]  tkeep;
logic                     tlast;
logic [AXI4SIDLEN-1:0]    tid;
logic [AXI4SDESTLEN-1:0]  tdest;
logic [AXI4SUSERLEN-1:0]  tuser;

modport M (
  input aclk, aresetn,
  output tvalid, input tready,
  output tdata, tstrb, tkeep, tlast,
  output tid, tdest, tuser
);

modport S (
  input aclk, aresetn,
  input tvalid, output tready,
  input tdata, tstrb, tkeep, tlast,
  input tid, tdest, tuser
);

modport MON (
  input aclk, aresetn,
  input tvalid, tready,
  input tdata, tstrb, tkeep, tlast,
  input tid, tdest, tuser
);

endinterface
