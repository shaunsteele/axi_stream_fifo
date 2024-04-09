// axi4s_fifo_env.sv

`ifndef __AXI4S_FIFO_ENV
`define __AXI4S_FIFO_ENV

class axi4s_fifo_env extends uvm_env;

axi4s_fifo_agent      agt;
axi4s_fifo_scoreboard scb;

`uvm_component_utils(axi4s_fifo_env)

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  agt = axi4s_fifo_agent::type_id::create("agt", this);
  scb = axi4s_fifo_scoreboard::type_id::create("scb", this);
endfunction

function void connect_phase(uvm_phase phase);
  agt.mon.item_collected_port.connect(scb.item_collected_export);
endfunction

endclass

`endif
