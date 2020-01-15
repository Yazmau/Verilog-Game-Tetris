`timescale 1ns / 1ps
module changestartscene(clk, rst, h_cnt, v_cnt, state);
    input clk, rst;
    input [9:0] h_cnt, v_cnt;
    output [1:0] state;
    reg [1:0] state, nextstate;
    reg [29:0] cnt, nextcnt;
    always@(posedge clk)begin
        if(rst)begin
            cnt <= 30'd0;
            state <= 2'b10;
        end
        else begin
            cnt <= nextcnt;
            state <= nextstate;;
        end
    end
    always@(*)begin
        if(cnt < 30'd25000000)begin
            nextcnt = cnt + 30'd1;
            nextstate = state;
        end
        else begin
            nextcnt = 30'd0;
            nextstate = state + 2'd1;
        end
    end
endmodule

