module uart(
            // Parametros generales
            input logic mclkx16, // master clock 
            input logic reset, // master reset

            // Parametros Receptor
            input logic rx, // entrada de datos en serie al Rx
            input logic read, // activo x 0, devuelve el dato leido del Rx
            output logic rxrdy, // dato listo para leer en Rx
            output logic [7:0] dataout, // salida de dato recibido
            // Señales de control Receptor
            output logic parityerr, //
            output logic framingerr, //
            output logic overrun, //

            // Parametros Transmisor
            input logic write, // activo x 0, empieza el proceso de envio de dato Tx
            input logic [7:0] datain, // entrada de dato de envio
            output logic txrdy, // dato en proceso de envio en Tx
            output logic tx // salida de datos en serie del Tx
            );

    uart_tx trans(mclkx16, reset, write, datain, tx, txrdy);
    uart_rx rec(mclkx16, reset, read, rx, dataout, rxrdy, parityerr, framingerr, overrun);
endmodule
