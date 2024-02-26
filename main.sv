	module main(input logic clk, reset,
				input logic dip1, dip2, dip3, dip4,
				input logic rx,
				output logic tx,
				output logic[7:0] data);
				
	logic mclk;
	logic[8:0] cnt;
	logic write;
	assign write = mclk;
	
	logic neg_reset;
	assign neg_reset = ~reset;
	
	always @ (posedge clk or posedge neg_reset)
	begin
		if (neg_reset) begin
			cnt <= 0;
			mclk <= 0;
		end
		else begin
			cnt <= cnt + 1;
			if (cnt == 163) begin
				mclk <= ~mclk;
				cnt <= 0;
				end	
			end	
	end
	
	logic nrx;
	assign nrx = ~rx;
	
	assign out = neg_reset;
	
	logic parityerr, framingerr, overrun;
	
    //uart_rx receive(mclkx16,  reset,  read,  rx, rdata, rxrdy, parityerr, framingerr, overrun);
	
	//assign write <= rxrdy;

	
	assign data[7] = 1'b0;
	assign data[6] = 1'b0;
	assign data[5] = 1'b0;
	assign data[4] = 1'b0;
	assign data[3] = dip4;
	assign data[2] = dip3;
	assign data[1] = dip2;
	assign data[0] = dip1;

    
	uart_tx trans(mclk, neg_reset, write, mdata, tx, txrdy);

	//arm_single dut(mclk, neg_reset, nrx, tx, WriteData, DataAdr, MemWrite, parityerr, framingerr, overrun);
endmodule


				
	
	