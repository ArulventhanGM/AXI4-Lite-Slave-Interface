`timescale 1ns / 1ps

module tb_axi4lite_slave;

    logic         ACLK;
    logic         ARESETN;
    logic [3:0]   AWADDR, ARADDR;
    logic         AWVALID, WVALID, BREADY;
    logic         ARVALID, RREADY;
    logic [31:0]  WDATA;
    logic [3:0]   WSTRB;
    logic         AWREADY, WREADY, BVALID;
    logic [1:0]   BRESP;
    logic [31:0]  RDATA;
    logic         ARREADY, RVALID;
    logic [1:0]   RRESP;

    // Instantiate DUT
    axi4lite_slave DUT (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(AWREADY),
        .WDATA(WDATA),
        .WSTRB(WSTRB),
        .WVALID(WVALID),
        .WREADY(WREADY),
        .BRESP(BRESP),
        .BVALID(BVALID),
        .BREADY(BREADY),
        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),
        .RDATA(RDATA),
        .RRESP(RRESP),
        .RVALID(RVALID),
        .RREADY(RREADY)
    );

    // Clock generation
    always #5 ACLK = ~ACLK;

    initial begin
        // Dump for EPWave
        $dumpfile("dump.vcd");
        $dumpvars;

        // Reset
        ACLK = 0;
        ARESETN = 0;
        AWVALID = 0; WVALID = 0; ARVALID = 0;
        BREADY = 0; RREADY = 0;
        #20;
        ARESETN = 1;

        // Write to register 2
        AWADDR = 4 * 2; AWVALID = 1;
        #10;
        AWVALID = 0;

        WDATA = 32'hDEADBEEF;
        WVALID = 1; WSTRB = 4'b1111;
        #10;
        WVALID = 0;

        BREADY = 1;
        #10;
        BREADY = 0;

        // Read from register 2
        ARADDR = 4 * 2; ARVALID = 1;
        #10;
        ARVALID = 0;
        RREADY = 1;
        #10;
        RREADY = 0;

        #30;
        $finish;
    end

endmodule
