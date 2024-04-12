// axi4_stream_seq_item.sv

`ifndef __AXI4_STREAM_SEQ_ITEM
`define __AXI4_STREAM_SEQ_ITEM

class axi4_stream_seq_item extends uvm_sequence_item;

rand bit  [DLEN-1:0]  tdata;

`uvm_object_utils(axi4_stream_seq_item)

function new(string name = "axi4_stream_seq_item");
  super.new(name);
endfunction

endclass

`endif
