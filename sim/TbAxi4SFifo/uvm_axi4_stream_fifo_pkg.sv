// uvm_axi4_stream_fifo_pkg.sv

`include "uvm_macros.svh"

package uvm_axi4_stream_fifo_pkg;

parameter int DLEN = 8;

import uvm_pkg::*;

`include "sequences/axi4_stream_seq_item.sv"

`include "agents/m_axi4_stream/m_axi4_stream_driver.sv"
`include "agents/m_axi4_stream/m_axi4_stream_monitor.sv"
`include "agents/m_axi4_stream/m_axi4_stream_agent.sv"

`include "agents/s_axi4_stream/s_axi4_stream_driver.sv"
`include "agents/s_axi4_stream/s_axi4_stream_monitor.sv"
`include "agents/s_axi4_stream/s_axi4_stream_agent.sv"

`include "fifo_scoreboard.sv"

endpackage
