// axi4s_fifo_test.sv

`ifndef __AXI4S_FIFO_TEST
`define __AXI4S_FIFO_TEST

class axi4s_fifo_test extends uvm_test;

`uvm_component_utils(axi4s_fifo_test)

axi4s_fifo_env  env;
// m_axi4s_seq     seq;

function new(string name = "axi4s_fifo_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  env = axi4s_fifo_env::type_id::create("env", this);
  // seq = m_axi4s_seq::type_id::create("seq", this);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);

  // seq.start(env.agt.sqr);

  phase.drop_objection(this);
endtask

endclass

`endif
