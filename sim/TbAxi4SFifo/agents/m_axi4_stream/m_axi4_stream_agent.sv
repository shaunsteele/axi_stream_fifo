// m_axi4_stream_agent.sv

`ifndef __M_AXI4_STREAM_AGENT
`define __M_AXI4_STREAM_AGENT

class m_axi4_stream_agent extends uvm_agent;

`uvm_component_utils(m_axi4_stream_agent)

uvm_sequencer#(axi4_stream_seq_item)  m_sqr;
m_axi4_stream_driver                  m_drv;
m_axi4_stream_monitor                 m_mon;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (get_is_active()) begin
    m_sqr = uvm_sequencer#(axi4_stream_seq_item)::type_id::create("m_sqr", this);
    m_drv = m_axi4_stream_driver::type_id::create("m_drv", this);
  end
  m_mon = m_axi4_stream_monitor::type_id::create("m_mon", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
  if (get_is_active())
    m_drv.seq_item_port.connect(m_sqr.seq_item_export);
endfunction

endclass

`endif
