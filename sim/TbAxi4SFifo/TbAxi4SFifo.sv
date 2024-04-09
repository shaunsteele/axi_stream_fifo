// TbAxi4SFifo.sv

`default_nettype none

module TbAxi4SFifo;

parameter int TIMEOUT = 10000;
initial begin
  #TIMEOUT;
  $error("SIMULATION TIMEOUT");
  $finish(1);
end

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
  uvm_config_db#(virtual u_wr)::set(uvm_root::get,"*",vaxi);
end

initial begin
  $timeformat(-9, 2, " ns", 20);
  $monitor("[%06t]", $realtime);
end

endmodule
