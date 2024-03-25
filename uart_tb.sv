module uart_tb;
    // Parametros generales
    logic mclkx16; // master clock 
    logic reset; // master reset

    // Parametros Receptor
    logic rx; // entrada de datos en serie al Rx
    logic read; // activo x 0; devuelve el dato leido del Rx
    logic rxrdy; // dato listo para leer en Rx
    logic [7:0] dataout; // salida de dato recibido
    // Señales de control Receptor
    logic parityerr; //
    logic framingerr; //
    logic overrun; //

    // Parametros Transmisor
    logic write; // activo x 0; empieza el proceso de envio de dato Tx
    logic [7:0] datain; // entrada de dato de envio
    logic txrdy; // dato en proceso de envio en Tx
    logic tx; // salida de datos en serie del Tx

    // Reloj para el modulo
    always
    begin
        mclkx16 <= 0; #3255; mclkx16 <= 1; #3255;
    end

    // Definimos el modulo UART
    uart dut (mclkx16, reset, rx, read, rxrdy, dataout, parityerr, framingerr, overrun, write, datain,
              txrdy, tx);

    // Definimos variables de entrada y salida
    logic [7:0] i; // donde guardamos datos de entrada
    logic [7:0] o; // donde guardamos datos de salida
    assign rx = tx; // conexion de la salida a la entrada de la uart 

      task write_to_transmitter();
        datain = i;
        write = 1; #3255; write = 0; #1000; write = 1;
      endtask 

      task read_out_receiver();
        read <= 1; #3255;
        read <= 0; #9765;
        o = dataout;
        read <= 1;
      endtask 

      task compare_data;
          if (i !== dataout) begin
          // Si los valores no son iguales, imprime ambas variables
          $display("Los valores de i y o son diferentes:");
          $display("i: %h", i);
          $display("o: %h", dataout);
      end
      endtask

    initial
    begin
      reset <= 1; #5; reset <= 0;
      i = 8'h00;
      for (i = 8'h00; i <= 8'h86; i = i + 1) begin
        write_to_transmitter(); // Write new data to transmitter.
        @(posedge rxrdy);
        read_out_receiver(); // Read out data from receiver.
        compare_data; // Compare "data send" to "data received".
      end
    end


endmodule