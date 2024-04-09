// m_axi4s_seq.sv

`ifndef __M_AXI4S_SEQ
`define __M_AXI4S_SEQ

class m_axi4s_seq extends uvm_sequence #(m_axi4s_seq_item);

`uvm_object_utils(m_axi4s_seq)

function new(string name = "m_axi4s_seq");
  super.new(name);
endfunction

virtual task body();
  `uvm_do_with(req, {req.tvalid==1;})
endtask

endclass

`endif
