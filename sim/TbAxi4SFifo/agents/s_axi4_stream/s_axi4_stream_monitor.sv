// s_axi4_stream_monitor.sv

`ifndef __S_AXI4_STREAM_MONITOR
`define __S_AXI4_STREAM_MONITOR

`define S_AXI_MON s_axi.MON.mon_cb

class s_axi4_stream_monitor extends uvm_monitor;

`uvm_component_utils(s_axi4_stream_monitor)

virtual axi4_stream_if s_axi;

uvm_analysis_port #(axi4_stream_seq_item) s_axi_mon_ap;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  s_axi_mon_ap = new("s_axi_mon_ap", this);
  if (!uvm_config_db#(virtual axi4_stream_if)::get(this, "", "s_axi", s_axi))
    `uvm_fatal(get_type_name(), "Failed to get virtual interface handle");
endfunction

virtual task run_phase(uvm_phase phase);
  axi4_stream_seq_item txn = axi4_stream_seq_item::type_id::create("txn", this);
  forever begin
    @(`S_AXI_MON.tvalid && `S_AXI_MON.tready);
    txn.tdata = `S_AXI_MON.tdata;
    s_axi_mon_ap.s_write(txn);
  end
endtask

endclass

`endif
