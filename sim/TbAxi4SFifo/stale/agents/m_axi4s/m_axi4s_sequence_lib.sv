// m_axi4s_seq.sv

`ifndef __M_AXI4S_SEQUENCE_LIB
`define __M_AXI4S_SEQUENCE_LIB

class m_axi4s_base_sequence extends uvm_sequence #(m_axi4s_seq_item);

`uvm_object_utils(m_axi4s_base_sequence)

function new(string name = "m_axi4s_base_sequence");
  super.new(name);
endfunction

endclass

class m_axi4s_sequence extends m_axi4s_base_sequence;

function new(string name = "m_axi4s_sequence");
  super.new(name);
endfunction

virtual task body();

endtask

endclass

`endif
