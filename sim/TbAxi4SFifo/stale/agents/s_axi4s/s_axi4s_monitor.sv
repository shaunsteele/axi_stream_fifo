// s_axi4s_monitor.sv

`ifndef __S_AXI4S_MONITOR
`define __S_AXI4S_MONITOR

`define VSAXI_MON vsaxi.MON.m_mon_cb

class s_axi4s_monitor extends uvm_monitor;

virtual axi4_stream_if vsaxi;

uvm_analysis_port #(m_axi4s_seq_item) item_collected_port;

m_axi4s_seq_item trans_collected;

`uvm_component_utils(s_axi4s_monitor)

function new(string name, uvm_component parent);
  super.new(name, parent);
  trans_collected = new();
  item_collected_port = new("item_collected_port", this);
endfunction

function void build_phase(uvm_phase phase);
  super.build(phase);
  if (!uvm_config_db#(virtual axi4_stream_if)::get(this, "", "vsaxi", vsaxi))
    `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name, ".vsaxi"});
endfunction

virtual task build(uvm_phase build);
  forever begin
    @(posedge vsaxi.MON.aclk);

    wait (`VSAXI_MON.tvalid && `VSAXI_MON.tready);

    trans_collected.tvalid = `VSAXI_MON.tvalid;
    trans_collected.tready = `VSAXI_MON.tready;
    trans_collected.tdata = `VSAXI_MON.tdata;

    item_collected_port.write(trans_collected);
  end
endtask


endclass

`endif
