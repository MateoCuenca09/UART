module uart_tx_tb;
    logic mclkx16; // clock que le llega al uart
    logic reset;
    logic write;
    logic[7:0] data;
    logic tx;
    logic txrdy;

    uart_tx dut(mclkx16, reset, write, data, tx, txrdy);
	
    
    initial
    begin
        data <= 8'b00001111;
        reset <= 1; #5; reset <= 0;
		write <= 1; #3255; write <= 0; #3255; write <= 1;
    end

    always
    begin
        mclkx16 <= 0; #3255; mclkx16 <= 1; #3255;
    end

endmodule