// m_axi4s_sequencer.sv

`ifndef __M_AXI4S_SEQUENCER
`define __M_AXI4S_SEQUENCER

class m_axi4s_sequencer extends uvm_sequencer #(m_axi4s_seq_item);

`uvm_component_utils(m_axi4s_sequencer)

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

endclass

`endif
