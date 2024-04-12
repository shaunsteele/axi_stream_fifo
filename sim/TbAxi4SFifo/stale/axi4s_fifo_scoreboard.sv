// axi4s_fifo_scoreboard.sv

`ifndef __AXI4S_FIFO_SCOREBOARD
`define __AXI4S_FIFO_SCOREBOARD

class axi4s_fifo_scoreboard extends uvm_scoreboard;

`uvm_component_utils(axi4s_fifo_scoreboard)
uvm_analysis_imp#(m_axi4s_seq_item, axi4s_fifo_scoreboard) item_collected_export;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  item_collected_export = new("item_collected_export", this);
endfunction

virtual function void write(m_axi4s_seq_item pkt);
  pkt.print();
endfunction

virtual task run_phase(uvm_phase phase);
  // Comparison Logic
endtask

endclass

`endif
