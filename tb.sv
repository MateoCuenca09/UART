module tb;

logic mclk16;
logic reset;
logic write;
logic [7:0] data;
logic [7:0] tx;
logic txrdy;

uart dut (mclk16, reset, write, data, tx, txrdy);

// Generación de la señal de reloj
always begin
  mclk16 = 1; #20; mclk16 = 0; #20;
end

// Secuencia de inicialización
initial begin
  reset = 1; #20;
  reset = 0; #100000;
  write = 1; #100000;
  data = 8'b10101111;
end


endmodule
