// tb_axi4sfifo_pkg.sv

`include "uvm_macros.svh"

package tb_axi4sfifo_pkg;

import uvm_pkg::*;

// TODO: figure out write interface monitor
// TODO: write queue model for scoreboard
// TODO: write scoreboard logic

`include "agents/m_axi4s/m_axi4s_seq_item.sv"
`include "agents/m_axi4s/m_axi4s_seq.sv"
`include "agents/m_axi4s/m_axi4s_sequencer.sv"
// `include "agent/m_axi4s_driver.sv"
// `include "agent/s_axi4s_monitor.sv"
`include "agents/m_axi4s/m_axi4s_agent.sv"
// `include "axi4s_fifo_scoreboard.sv"
`include "axi4s_fifo_env.sv"
`include "axi4s_fifo_test.sv"

endpackage
