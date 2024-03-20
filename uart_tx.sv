module uart_tx(input logic mclkx16, input logic reset, input logic write, input logic[7:0] data,
                   output logic tx, output logic txrdy
                   , output logic [7:0] thr, output logic [7:0] tsr, output logic txclk, output logic txparity, output logic paritycycle);

    //logic [7:0] thr; // transmitter hold register
    //logic [7:0] tsr; // transmitter shift register
    //logic paritymode, txparity, paritycycle; // modo, recuento y ciclo de paridad
    logic tag1, tag2; // 
    //logic txclk; 
    logic txdone, txdatardy, txloaded;
    logic [3:0] cnt;

    assign paritymode = 1'b1;

    // clock divider
    always @ (posedge mclkx16 or posedge reset)
    begin
        if (reset) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
	 
	assign txclk = cnt[3]; // clk / 8

    // async write
    always @ (posedge write or posedge reset)
    begin
        if (write)
            thr <= data;
        else
            thr <= 8'hxx;
    end

    always @ (posedge write or posedge reset or posedge txloaded)
    begin
        if (reset || txloaded)
            txdatardy <= 0;
        else
            txdatardy <= 1;
    end

    assign txrdy = !txdatardy;

    // processing
    assign paritycycle = tsr[1] && !(tag2 || tag1 || tsr[7] || tsr[6] || tsr[5] || tsr[4] || tsr[3] || tsr[2]);
    assign txdone = !(tag2 || tag1 || tsr[7] || tsr[6] || tsr[5] || tsr[4] || tsr[3] || tsr[2] || tsr[1] || tsr[0]);

    always @ (posedge txclk or posedge reset)
    begin
        if (reset) 
            idle_reset;
        else 
            if (txdone && txdatardy) 
                load_data;
            else 
                begin
                    shift_data;
                    if (txdone)
                        tx <= 1'b1;
                    else if (paritycycle)
                        tx <= txparity;
                    else
                        tx <= tsr[0];
                end
    end

task idle_reset;
    begin
        tx <= 1'b1;
        tsr <= 0;
        tag1 <= 1'b0;
        tag2 <= 1'b0;
        txloaded <= 1'b0;
    end
endtask

task load_data;
    begin
        txloaded <= 1'b1;
        tsr <= thr;
        tx <= 1'b0;  // start of transmission
        tag1 <= 1'b1;
        tag2 <= 1'b1;
        txparity <= paritymode;

    end
endtask

task shift_data;
    begin
        txloaded <= 1'b0;
        tsr <= tsr >> 1;
        tsr[7] <= tag1;
        tag1 <= tag2;
        tag2 <= 1'b0;
        txparity <= txparity ^ tsr[0];
    end
endtask


    


endmodule


