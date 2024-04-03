// SdpRam1.sv
// Simple Dual-Port RAM - Single Clock

`default_nettype none

module SdpRam1 # (
  parameter int BLEN = 8,
  parameter int WLEN = 4,
  parameter int DLEN = BLEN * WLEN,
  parameter int MLEN = 1024,
  parameter int ALEN = $clog2(MLEN),
  parameter bit ENDIAN = 0,
  parameter bit OREG = 0
)(
  input var                     clk,
  input var                     rstn,

  input var                     i_wen,
  input var         [ALEN-1:0]  i_waddr,
  input var         [DLEN-1:0]  i_wdata,

  input var                     i_ren,
  input var         [ALEN-1:0]  i_raddr,
  output var logic  [DLEN-1:0]  o_rdata
);

initial begin
  assert ($countones(MLEN) == 1)
  else begin
    $error("Illegal Memory Depth: 0x%0h", MLEN);
  end
end

logic [BLEN-1:0] ram[MLEN];

always_ff @(posedge clk) begin
  assert (i_waddr[1:0] == 0)
  else begin
    $warning("Unaligned Memory Write Address: 0x%0h", i_waddr);
  end
  if (i_wen) begin
    for (int i=0; i < WLEN; i++) begin
      ram[i_waddr+i[ALEN-1:0]] <= i_wdata[i*BLEN+:BLEN];
    end
  end else begin
    ram[i_waddr] <= ram[i_waddr];
  end
end

generate
  if (OREG) begin: l_ff

    always_ff @(posedge clk) begin
      if (!rstn) begin
        o_rdata <= 0;
      end else begin
        if (i_ren) begin
          for (int i=0; i < WLEN; i++) begin
            o_rdata[i*BLEN+:BLEN] <= ram[i_raddr + i[ALEN-1:0]][BLEN-1:0];
          end
        end else begin
          o_rdata <= o_rdata;
        end
      end
    end

  end else begin: l_comb

    always_comb begin
      if (i_ren) begin
        for (int i=0; i < 4; i++) begin
          o_rdata[i*BLEN+:BLEN] = ram[i_raddr + i[ALEN-1:0]][BLEN-1:0];
        end
      end else begin
        o_rdata = 0;
      end
    end

  end
endgenerate


endmodule
