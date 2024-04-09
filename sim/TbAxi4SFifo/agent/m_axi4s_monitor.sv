// m_axi4s_monitor.sv

`ifndef __M_AXI4S_MONITOR
`define __M_AXI4S_MONITOR

`define VAXI_M_MON vaxi.M_MON.m_mon_cb

class m_axi4s_monitor extends uvm_monitor;

virtual axi4_stream_if vaxi;

uvm_analysis_port #(m_axi4s_seq_item) item_collected_port;

m_axi4s_seq_item trans_collected;

`uvm_component_utils(m_axi4s_monitor)

function new(string name, uvm_component parent);
  super.new(name, parent);
  trans_collected = new();
  item_collected_port = new("item_collected_port", this);
endfunction

function void build_phase(uvm_phase phase);
  super.build(phase);
  if (!uvm_config_db#(virtual axi4_stream_if)::get(this, "", "vaxi", vaxi))
    `uvm_fatal("NO_VAXI", {"virtual interface must be set for: ", get_full_name, ".vaxi"});
endfunction

virtual task build(uvm_phase build);
  forever begin
    @(posedge vaxi.M_MON.aclk);

    wait (`VAXI_M_MON.tvalid && `VAXI_M_MON.tready);

    trans_collected.tvalid = `VAXI_M_MON.tvalid;
    trans_collected.tready = `VAXI_M_MON.tready;
    trans_collected.tdata = `VAXI_M_MON.tdata;

    item_collected_port.write(trans_collected);
  end
endtask


endclass

`endif
