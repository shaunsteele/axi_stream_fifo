// s_axi4_stream_agent.sv

`ifndef __S_AXI4_STREAM_AGENT
`define __S_AXI4_STREAM_AGENT

class s_axi4_stream_agent extends uvm_agent;

`uvm_component_utils(s_axi4_stream_agent)

// uvm_sequencer#(axi4_stream_seq_item)  s_sqr;
s_axi4_stream_driver                  s_drv;
s_axi4_stream_monitor                 s_mon;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  // if (get_is_active()) begin
    // s_sqr = uvm_sequencer#(axi4_stream_seq_item)::type_id::create("s_sqr", this);
    s_drv = m_axi4_stream_driver::type_id::create("s_drv", this);
  // end
  s_mon = m_axi4_stream_monitor::type_id::create("s_mon", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
  // if (get_is_active())
  //   s_drv.seq_item_port.connect(s_sqr.seq_item_export);
endfunction

endclass

`endif
