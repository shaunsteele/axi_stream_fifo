// m_axi4s_agent.sv

`ifndef __M_AXI4S_AGENT
`define __M_AXI4S_AGENT

class m_axi4s_agent extends uvm_agent;

// m_axi4s_driver    drv;
m_axi4s_sequencer sqr;
// s_axi4s_monitor   mon;

`uvm_component_utils(m_axi4s_agent)

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (get_is_active() == UVM_ACTIVE) begin
    // drv = m_axi4s_driver::type_id::create("drv", this);
    sqr = m_axi4s_sequencer::type_id::create("sqr", this);
  end

  // mon = s_axi4s_monitor::type_id::create("mon", this);
endfunction

function void connect_phase(uvm_phase phase);
  if (get_is_active() == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sqr.seq_item_export);
  end
endfunction

endclass

`endif
