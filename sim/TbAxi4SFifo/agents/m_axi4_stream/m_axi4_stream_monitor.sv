// m_axi4_stream_monitor.sv

`ifndef __M_AXI4_STREAM_MONITOR
`define __M_AXI4_STREAM_MONITOR

`define M_AXI_MON m_axi.MON.mon_cb

class m_axi4_stream_monitor extends uvm_monitor;

`uvm_component_utils(m_axi4_stream_monitor)

virtual axi4_stream_if m_axi;

uvm_analysis_port #(axi4_stream_seq_item) m_axi_mon_ap;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  m_axi_mon_ap = new("m_axi_mon_ap", this);
  if (!uvm_config_db#(virtual axi4_stream_if)::get(this, "", "m_axi", m_axi))
    `uvm_fatal(get_type_name(), "Failed to get virtual interface handle");
endfunction

virtual task run_phase(uvm_phase phase);
  axi4_stream_seq_item txn = axi4_stream_seq_item::type_id::create("txn", this);
  forever begin
    @(`M_AXI_MON.tvalid && `M_AXI_MON.tready);
    txn.tdata = `M_AXI_MON.tdata;
    m_axi_mon_ap.m_write(txn);
  end
endtask

endclass

`endif
