// s_axi4s_driver.sv

`ifndef __S_AXI4S_DRIVER
`define __S_AXI4S_DRIVER

`define VSAXI_DRV vsaxi.S_DRV.s_drv_cb

class s_axi4s_driver extends uvm_driver;

`uvm_component_utils(s_axi4s_driver)

virtual axi4_stream_if vsaxi;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual axi4_stream_if)::get(this, "", "vsaxi", vsaxi));
    `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vsaxi"});
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

  `VSAXI_DRV.tready <= req.tready;

  wait (`VSAXI_DRV.tvalid);
  
  @(posedge vsaxi.S_DRV.aclk);
endtask

endclass

`endif
