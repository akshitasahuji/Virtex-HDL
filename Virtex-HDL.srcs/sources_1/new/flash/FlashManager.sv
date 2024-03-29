`timescale 1ns / 1ps

/* FlashManager - uses the FPGA's JTAG to write external flash memory (that is then read from at boot)

    Flash: MX25V1635FM2I (2,000,000 x 8-bits)
     - Docs: https://www.macronix.com/Lists/Datasheet/Attachments/7409/MX25V1635F,%202.5V,%2016Mb,%20v1.4.pdf
     - 80MHz
    */
module FlashManager(
    input wire CLK100,
    output reg SPI_CS, //active low
    output wire SPI_WP, //active low
    output wire SPI_HOLD, //active low
    output reg SPI_MOSI,
    input wire SPI_MISO
    );
    
    //Connect User Logic to JTAG Boundry Scan
    wire BSCAN_TDI, BSCAN_TCK, BSCAN_TMS;
    wire BSCAN_DRCK1, BSCAN_SEL1, BSCAN_SHIFT;
    wire BSCAN_CAPTURE, BSCAN_UPDATE;
    reg BSCAN_TDO1 = 0;
    BSCANE2 BSCANE2 (
        .TDI(BSCAN_TDI),
        .TCK(BSCAN_TCK),
        .TMS(BSCAN_TMS),
        .DRCK1(BSCAN_DRCK1),
        .DRCK2(),
        .RESET(),
        .SEL1(BSCAN_SEL1),
        .SEL2(),
        .SHIFT(BSCAN_SHIFT),
        .CAPTURE(BSCAN_CAPTURE),
        .UPDATE(BSCAN_UPDATE),
        .TDO1(BSCAN_TDO1),
        .TDO2(1'b1)
    );

    //TODO INTERCEPT JTAG PROBE & OVERRIDE P/N

    //Connect User Logic to Config Logic
    wire SPI_CLK;
    STARTUPE2 STARTUPE2 (
        .CLK(0),
        .GSR(0),
        .GTS(0),
        .KEYCLEARB(0),
        .PACK(0),
        .PREQ(),
        .USRCCLKO(SPI_CLK),
        .USRCCLKTS(0),
        .USRDONEO(1),
        .USRDONETS(1),
        .CFGCLK(),
        .CFGMCLK(),
        .EOS()
    );

    //Link JTAG to Flash SPI interface
    assign SPI_CS = BSCAN_SEL1 & BSCAN_SHIFT;
    assign SPI_MOSI = SPI_CS ? BSCAN_TDI : 0;
    assign SPI_CLK = SPI_CS ? BSCAN_DRCK1 : 1;
    assign SPI_WP = 1; //we dont need write protection OR holding
    assign SPI_HOLD = 1;

    always_ff @(posedge BSCAN_DRCK1) begin
        BSCAN_TDO1 <= SPI_MISO;
    end
endmodule