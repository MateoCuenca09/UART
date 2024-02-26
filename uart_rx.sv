module uart_rx(input logic mclkx16, input logic reset, input logic read, input logic rx,
                output logic[7:0] rdata, output logic rxrdy, output logic parityerr, output logic framingerr, output logic overrun);

    logic [7:0] rhr;
    logic [7:0] rsr;
    logic paritymode, rxparity, paritygen;
    logic rxstop;
    logic idle, idle2, hunt;
    logic read2;
    logic rxclk;
    logic [3:0] cnt;

    assign paritymode = 1'b1;

    always @ (posedge mclkx16 or posedge reset)
    begin
        if (reset) begin
            cnt <= 0;
            hunt <= 0;
        end
        else begin
            if (idle && !rx)
                hunt <= 1;
            else
                hunt <= 0;

            if (hunt || !idle)
                cnt <= cnt + 1;
            else
                cnt <= 0;
        end
    end
	 
    assign rxclk = cnt[3];

    always @ (posedge rxclk or posedge reset)
    begin
        if (reset)
            idle <= 1;
        else begin
            idle <= !idle && !rsr[0];
        end
    end

    assign rdata = ~read ? rhr : 8'h00;

    always @ (posedge mclkx16 or posedge reset)
    begin
        if (reset) begin
            rxrdy <= 0;
            parityerr <= 0;
            framingerr <= 0;
            overrun <= 0;
            idle2 <= 1;
        end
        else begin
            idle2 <= idle;
            read2 <= read;

            if (read && !read2 && rxrdy) begin
                rxrdy <= 0;
                parityerr <= 0;
                framingerr <= 0;
                overrun <= 0;
            end
            else if (!idle2 && idle) begin
                if (!rxrdy) begin
                    rhr <= rsr;
                    overrun <= 0;
                end
                else
                    overrun <= 1;

                parityerr <= paritygen;
                framingerr <= ~rxstop;
                rxrdy <= 1;
            end
        end
    end

task idle_reset;
    begin
        rsr <= 8'b11111111; // All 1's ensure that idle stays low during data shifting.
        rxparity <= 1'b1; // Preset to high to ensure idle = 0 during data shifting.
        paritygen <= paritymode; // Preset to 1 => odd parity mode, 0 => even parity mode.
        rxstop <= 1'b0; // Forces idle = 1, when rsr[0] gets rxstop bit.
    end
endtask

task shift_data;
    begin
        rsr <= rsr >> 1; // Right shift receive shift register.
        rsr[7] <= rxparity; // Load rsr[7] with rxparity.
        rxparity <= rxstop; // Load rxparity with rxstop.
        rxstop <= rx; // At 1'st shift rxstop gets low "start bit".
        paritygen <= paritygen ^ rxstop; // Generate parity as data are shifted.
    end
endtask

always @(posedge rxclk or posedge reset)
    if (reset)
        idle_reset; // Reset internal bits.
    else
        begin
        if (idle)
            idle_reset; // Reset internal bits.
        else
            shift_data; // Shift data and generate parity.
end

endmodule


