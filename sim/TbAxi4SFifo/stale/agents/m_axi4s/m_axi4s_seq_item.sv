// m_axi4s_seq_item.sv

class m_axi4s_seq_item #(
  parameter int AXI4SDATALEN =1
  ) extends uvm_sequence_item;

rand bit [AXI4SDATALEN-1:0] tdata;

`uvm_object_utils_begin(m_axi4s_seq_item)
  `uvm_field_int(tdata, UVM_ALL_ON)
`uvm_object_utils_end

function new(string name = "m_axi4s_seq_item");
  super.new(name);
endfunction

endclass
