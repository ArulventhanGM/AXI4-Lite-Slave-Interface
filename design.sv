module axi4lite_slave #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 32
)(
    input logic                   ACLK,
    input logic                   ARESETN,

    // Write Address Channel
    input  logic [ADDR_WIDTH-1:0] AWADDR,
    input  logic                  AWVALID,
    output logic                  AWREADY,

    // Write Data Channel
    input  logic [DATA_WIDTH-1:0] WDATA,
    input  logic [3:0]            WSTRB,
    input  logic                  WVALID,
    output logic                  WREADY,

    // Write Response Channel
    output logic [1:0]            BRESP,
    output logic                  BVALID,
    input  logic                  BREADY,

    // Read Address Channel
    input  logic [ADDR_WIDTH-1:0] ARADDR,
    input  logic                  ARVALID,
    output logic                  ARREADY,

    // Read Data Channel
    output logic [DATA_WIDTH-1:0] RDATA,
    output logic [1:0]            RRESP,
    output logic                  RVALID,
    input  logic                  RREADY
);

    // Internal Registers
    logic [DATA_WIDTH-1:0] reg0, reg1, reg2, reg3;

    // Write FSM
    typedef enum logic [1:0] {
        WR_IDLE,
        WR_ADDR,
        WR_DATA,
        WR_RESP
    } wr_state_t;

    wr_state_t wr_state;

    // Read FSM
    typedef enum logic [1:0] {
        RD_IDLE,
        RD_ADDR,
        RD_DATA
    } rd_state_t;

    rd_state_t rd_state;

    // Write FSM Logic
    always_ff @(posedge ACLK or negedge ARESETN) begin
        if (!ARESETN) begin
            wr_state <= WR_IDLE;
            AWREADY <= 0;
            WREADY  <= 0;
            BVALID  <= 0;
            BRESP   <= 2'b00;
        end else begin
            case (wr_state)
                WR_IDLE: begin
                    if (AWVALID) begin
                        AWREADY <= 1;
                        wr_state <= WR_DATA;
                    end
                end
                WR_DATA: begin
                    AWREADY <= 0;
                    if (WVALID) begin
                        WREADY <= 1;
                        case (AWADDR[3:2])
                            2'd0: reg0 <= WDATA;
                            2'd1: reg1 <= WDATA;
                            2'd2: reg2 <= WDATA;
                            2'd3: reg3 <= WDATA;
                        endcase
                        wr_state <= WR_RESP;
                    end
                end
                WR_RESP: begin
                    WREADY <= 0;
                    BVALID <= 1;
                    if (BREADY) begin
                        BVALID <= 0;
                        wr_state <= WR_IDLE;
                    end
                end
            endcase
        end
    end

    // Read FSM Logic
    always_ff @(posedge ACLK or negedge ARESETN) begin
        if (!ARESETN) begin
            rd_state <= RD_IDLE;
            ARREADY <= 0;
            RVALID  <= 0;
            RRESP   <= 2'b00;
            RDATA   <= 0;
        end else begin
            case (rd_state)
                RD_IDLE: begin
                    if (ARVALID) begin
                        ARREADY <= 1;
                        rd_state <= RD_DATA;
                    end
                end
                RD_DATA: begin
                    ARREADY <= 0;
                    RVALID <= 1;
                    case (ARADDR[3:2])
                        2'd0: RDATA <= reg0;
                        2'd1: RDATA <= reg1;
                        2'd2: RDATA <= reg2;
                        2'd3: RDATA <= reg3;
                    endcase
                    rd_state <= RD_IDLE;
                end
            endcase
            if (RVALID && RREADY) begin
                RVALID <= 0;
            end
        end
    end

endmodule
