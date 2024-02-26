module uart(input logic mclkx16, input logic reset, input logic read, input logic write,
            output logic parityerr, output logic framingerr, output logic overrun,
            output logic rxrdy, output logic txrdy,
            input logic [7:0] datain,
            output logic [7:0] dataout,
            input logic rx, output logic tx);

    uart_tx trans(mclkx16, reset, write, datain, tx, txrdy);
    //receiver rec(mclkx16, reset, read, rx, dataout, rxrdy, parityerr, framingerr, overrun);
endmodule
