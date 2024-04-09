// m_axi4s_driver.sv

`ifndef __M_AXI4S_DRIVER
`define __M_AXI4S_DRIVER

`define VAXIDRV vaxi.M_DRV.m_drv_cb

class m_axi4s_driver extends uvm_driver #(m_axi4s_seq_item);

`uvm_component_utils(m_axi4s_driver)

virtual axi4_stream_if vaxi;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual axi4_stream_if)::get(this, "", "vaxi", vaxi));
    `uvm_fatal("NO_VAXI", {"virtual interface must be set for: ", get_full_name(), ".vaxi"});
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

  `VAXI_M_DRV.aresetn <= req.aresetn;
  `VAXI_M_DRV.tvalid <= req.tvalid;
  `VAXI_M_DRV.tdata <= req.tdata;

  wait (`VAXI.tready);
  
  @(posedge vaxi.M_DRV.aclk);
endtask

endclass

`endif
