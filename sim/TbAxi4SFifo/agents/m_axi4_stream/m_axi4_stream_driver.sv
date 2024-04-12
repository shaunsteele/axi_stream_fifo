// m_axi4s_driver.sv

`ifndef __M_AXI4_STREAM_DRIVER
`define __M_AXI4_STREAM_DRIVER

`define M_AXI_DRV m_axi.M_DRV.m_drv_cb

class m_axi4_stream_driver extends uvm_driver #(axi4_stream_seq_item);

`uvm_component_utils(m_axi4_stream_driver)

virtual axi4_stream_if m_axi;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual axi4_stream_if)::get(this, "", "m_axi", m_axi))
    `uvm_fatal(get_type_name(), "Failed to get virtual interface handle");
endfunction

virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    axi4_stream_seq_item txn = axi4_stream_seq_item::type_id::create("txn");
    seq_item_port.get_next_item(txn);
    drive(txn);
    seq_item_port.item_done();
  end
endtask

virtual task drive(axi4_stream_seq_item txn);
  @(posedge m_axi.M_DRV.aclk);
  `M_AXI_DRV.tvalid <= 1;
  `M_AXI_DRV.tdata <= txn.tdata;
  wait (`M_AXI_DRV.tready);

  @(posedge m_axi.M_DRV.aclk);
  `M_AXI_DRV.tvalid <= 0;
endtask

endclass

`endif