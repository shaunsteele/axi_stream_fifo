// axi4_stream_if.sv

`default_nettype none

interface axi4_stream_if # (
  parameter int AXI4SDATALEN  = 32//,
  // parameter int AXI4SSTRBLEN  = AXI4SDATALEN / 8,
  // parameter int AXI4SKEEPLEN  = AXI4SDATALEN / 8,
  // parameter int AXI4SIDLEN    = 2,
  // parameter int AXI4SDESTLEN  = 4,
  // parameter int AXI4SUSERLEN  = 8
)(
  input var aclk,
  input var aresetn
);

logic                     tvalid;
logic                     tready;
logic [AXI4SDATALEN-1:0]  tdata;
// logic [AXI4SSTRBLEN-1:0]  tstrb;
// logic [AXI4SKEEPLEN-1:0]  tkeep;
// logic                     tlast;
// logic [AXI4SIDLEN-1:0]    tid;
// logic [AXI4SDESTLEN-1:0]  tdest;
// logic [AXI4SUSERLEN-1:0]  tuser;

modport M (
  input aclk, aresetn,
  output tvalid, input tready,
  output tdata//, 
  // output tstrb, tkeep, tlast,
  // output tid, tdest, tuser
);

modport S (
  input aclk, aresetn,
  input tvalid, output tready,
  input tdata//, 
  // input tstrb, tkeep, tlast,
  // input tid, tdest, tuser
);

clocking m_drv_cb @(posedge aclk);
  default input #2 output #2;
  output tvalid;
  input tready;
  output tdata;
endclocking

modport M_DRV (clocking m_drv_cb, input aclk, input aresetn);

clocking s_drv_cb @(posedge aclk);
  default input #2 output #2;
  input tvalid;
  output tready;
  input tdata;
endclocking

modport S_DRV (clocking s_drv_cb, input aclk, input aresetn);

clocking mon_cb @(posedge aclk);
  default input #2 output #2;
  input tvalid;
  input tready;
  input tdata;
endclocking

modport MON (clocking mon_cb, input aclk, input aresetn);

endinterface
