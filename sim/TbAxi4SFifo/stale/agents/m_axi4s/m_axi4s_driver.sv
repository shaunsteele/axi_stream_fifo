// m_axi4s_driver.sv

`ifndef __M_AXI4S_DRIVER
`define __M_AXI4S_DRIVER

`define VMAXI_DRV vmaxi.M_DRV.m_drv_cb

class m_axi4s_driver extends uvm_driver #(m_axi4s_seq_item);

`uvm_component_utils(m_axi4s_driver)

virtual axi4_stream_if vmaxi;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual axi4_stream_if)::get(this, "", "vmaxi", vmaxi));
    `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vmaxi"});
endfunction

virtual task run_phase(uvm_phase phase);
  forever begin
    super.run_phase(phase);
    seq_item_port.get_next_item(req);
    // respond_to_transfer(req);
    drive();
    seq_item_port.item_done();
  end
endtask

virtual task drive();
  req.print();

  `VMAXI_DRV.tvalid <= req.tvalid;
  `VMAXI_DRV.tdata <= req.tdata;

  wait (`VMAXI_DRV.tready);
  
  @(posedge vmaxi.M_DRV.aclk);
endtask

endclass

`endif
