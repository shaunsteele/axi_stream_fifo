// TbAxi4SFifo.sv

`default_nettype none

`include "uvm_macros.svh"

module TbAxi4SFifo;
import uvm_pkg::*;
import uvm_axi4_stream_fifo_pkg::*;

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
// Interfaces
axi4_stream_if u_wr(.aclk(clk), .aresetn(rstn));
axi4_stream_if u_rd(.aclk(clk), .aresetn(rstn));

// Module
Axi4SFifo # (
  .FIFO_ALEN(1)
) u_DUT (
  .aclk         (clk),
  .aresetn      (rstn),
  .wr           (u_wr),
  .rd           (u_rd)
);

initial begin
  uvm_config_db#(virtual axi4_stream_if)::set(null,"uvm_test_top","s_axi",u_wr);
  uvm_config_db#(virtual axi4_stream_if)::set(null,"uvm_test_top","m_axi",u_rd);
end

initial begin
  run_test();
end

// initial begin
//   $timeformat(-9, 2, " ns", 20);
//   $monitor("[%06t]", $realtime);
// end

endmodule
