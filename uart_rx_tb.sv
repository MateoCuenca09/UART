module uart_rx_tb;
logic mclkx16;
logic reset;
logic read;
logic rx;
logic[7:0] rdata;
logic rxrdy;
logic parityerr;
logic framingerr;
logic overrun;
logic [7:0] message;
assign read = ~rxrdy;


uart_rx dut( mclkx16, reset, read, rx, rdata, rxrdy, parityerr, framingerr, overrun);
initial
begin
    message <= 8'h0f;
    rx <= 1;

    // txclk starts at 15
    reset <= 1; #10; reset <= 0; #5;

    // at 20
    rx <= 0; # 104166; // start
    rx <= message[0]; #104166;
    rx <= message[1]; #104166;
    rx <= message[2]; #104166;
    rx <= message[3]; #104166;
    rx <= message[4]; #104166;
    rx <= message[5]; #104166;
    rx <= message[6]; #104166;
    rx <= message[7]; #104166;
    rx <= 1; #104166; // parity
    rx <= 1; #104166; // stop

    // at 20
    rx <= 0; # 104166; // start
    rx <= message[0]; #104166;
    rx <= message[1]; #104166;
    rx <= message[2]; #104166;
    rx <= message[3]; #104166;
    rx <= message[4]; #104166;
    rx <= message[5]; #104166;
    rx <= message[6]; #104166;
    rx <= message[7]; #104166;
    rx <= 1; #104166; // parity
    rx <= 1; #104166; // stop

    // at 20
    rx <= 0; # 104166; // start
    rx <= message[0]; #104166;
    rx <= message[1]; #104166;
    rx <= message[2]; #104166;
    rx <= message[3]; #104166;
    rx <= message[4]; #104166;
    rx <= message[5]; #104166;
    rx <= message[6]; #104166;
    rx <= message[7]; #104166;
    rx <= 1; #104166; // parity
    rx <= 1; #104166; // stop

    // at 20
    rx <= 0; # 104166; // start
    rx <= message[0]; #104166;
    rx <= message[1]; #104166;
    rx <= message[2]; #104166;
    rx <= message[3]; #104166;
    rx <= message[4]; #104166;
    rx <= message[5]; #104166;
    rx <= message[6]; #104166;
    rx <= message[7]; #104166;
    rx <= 1; #104166; // parity
    rx <= 1; #104166; // stop
end
always
begin
    mclkx16 <= 0; #3255; mclkx16 <= 1; #3255;
end

endmodule