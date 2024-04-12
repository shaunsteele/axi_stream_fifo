// fifo_scoreboard.sv

`ifndef __FIFO_SCOREBOARD
`define __FIFO_SCOREBOARD

class fifo_scoreboard extends uvm_scoreboard;

`uvm_component_utils(fifo_scoreboard)

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

uvm_analysis_imp#(axi4_stream_seq_item, fifo_scoreboard)  m_ap_imp;
uvm_analysis_imp#(axi4_stream_seq_item, fifo_scoreboard)  s_ap_imp;

axi4_stream_seq_item model[$];

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  m_ap_imp = new("m_ap_imp", this);
  s_ap_imp = new("s_ap_imp", this);
endfunction

virtual function void m_write(axi4_stream_seq_item txn);
  model.push_front(txn);
endfunction

virtual function void s_write(axi4_stream_seq_item txn);
  if (model[$] == txn)
    `uvm_info(get_type_name(), $sformatf("Data Pass!"), UVM_LOW)
  else
    `uvm_error(get_type_name(), $sformatf("Failed: 0x%02h\t0x%02h", model[$].tdata, txn.tdata))
  model.pop_back();
endfunction

virtual function void connect_phase(uvm_phase phase);
endfunction

virtual task run_phase(uvm_phase phase);
endtask



endclass

`endif
