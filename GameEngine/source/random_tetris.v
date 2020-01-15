`timescale 1ns / 1ps
module random_tetris(clk, rst, signal_for_next, out);
	input clk, rst;
	input signal_for_next;
	output reg [2:0] out;
	//每輪會掉落七種不同的方塊，並依照隨機的順序掉落，一輪結束後會再開始新的一輪
	reg [2:0] nextout;
	reg [2:0] cnt, nextcnt;//數到now中的第幾個
	reg [2:0] isseven, nextisseven;//當前順序用到第幾個方塊
	reg [9:0] howmanyclk, nexthowmanyclk;//經過幾個clk
	reg [2:0] now [6:0];//當前方塊順序
	reg [2:0] nextnow [6:0];
	reg [2:0] arr [6:0];//一直更新的方塊順序，當前這輪方塊用完，傳給now
	reg [2:0] nextarr [6:0];
	reg [2:0] label, nextlabel;//決定arr更新方式
	always@(posedge clk)begin
		if(rst)begin
			out <= 3'b001;
			cnt <= 3'd0;
			isseven <= 3'd0;
			howmanyclk <= 10'd0;
			{now[6], now[5], now[4], now[3], now[2], now[1], now[0]} <= 21'b111_110_101_100_011_010_001;
			{arr[6], arr[5], arr[4], arr[3], arr[2], arr[1], arr[0]} <= 21'b111_110_101_100_011_010_001;
			label <= 3'b000;
		end
		else begin
			out <= nextout;
			cnt <= nextcnt;
			isseven <= nextisseven;
			howmanyclk <= nexthowmanyclk;
			{now[6], now[5], now[4], now[3], now[2], now[1], now[0]} <= {nextnow[6], nextnow[5], nextnow[4], nextnow[3], nextnow[2], nextnow[1], nextnow[0]};
			{arr[6], arr[5], arr[4], arr[3], arr[2], arr[1], arr[0]} <= {nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]};
			label <= nextlabel;
		end
	end
	always@(*)begin
		if((signal_for_next == 1'b1))begin
			nextout = now[cnt];
			if(isseven < 3'd6)begin//當前這輪的方塊還沒用完
			    nextisseven = isseven + 3'd1; 
			    {nextnow[6], nextnow[5], nextnow[4], nextnow[3], nextnow[2], nextnow[1], nextnow[0]} = {now[6], now[5], now[4], now[3], now[2], now[1], now[0]};
			    if(cnt < 3'd6)begin
                    nextcnt = cnt + 3'd1;
                end
                else begin
                    nextcnt = 3'd0;
                end
			end
			else begin//用完了，更新方塊順序
			    nextisseven = 3'd0;
			    nextcnt = howmanyclk % 7;
			    {nextnow[6], nextnow[5], nextnow[4], nextnow[3], nextnow[2], nextnow[1], nextnow[0]} = {arr[6], arr[5], arr[4], arr[3], arr[2], arr[1], arr[0]};
			end
		end
		else begin
			nextout = out;
			nextcnt = cnt;
			nextisseven = isseven;
			{nextnow[6], nextnow[5], nextnow[4], nextnow[3], nextnow[2], nextnow[1], nextnow[0]} = {now[6], now[5], now[4], now[3], now[2], now[1], now[0]};
		end
	end
	always@(*)begin
	    nexthowmanyclk = howmanyclk + 10'd1;
		if(label < 3'd6)begin
			nextlabel = label + 3'd1;
		end
		else begin
			nextlabel = 3'd0;
		end
	end
	always@(*)begin
		case(label)//不斷更新方塊順序
			3'd0:begin
				{nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]} = {arr[6], arr[5], arr[0], arr[3], arr[2], arr[1], arr[4]};
			end
			3'd1:begin
				{nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]} = {arr[6], arr[1], arr[4], arr[3], arr[2], arr[5], arr[0]};
			end
			3'd2:begin
				{nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]} = {arr[2], arr[5], arr[4], arr[3], arr[6], arr[1], arr[0]};
			end
			3'd3:begin
				{nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]} = {arr[6], arr[5], arr[4], arr[0], arr[2], arr[1], arr[3]};
			end
			3'd4:begin
				{nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]} = {arr[6], arr[5], arr[1], arr[3], arr[2], arr[4], arr[0]};
			end
			3'd5:begin
				{nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]} = {arr[6], arr[2], arr[4], arr[3], arr[5], arr[1], arr[0]};
			end
			3'd6:begin
				{nextarr[6], nextarr[5], nextarr[4], nextarr[3], nextarr[2], nextarr[1], nextarr[0]} = {arr[3], arr[5], arr[4], arr[6], arr[2], arr[1], arr[0]};
			end
		endcase
	end
endmodule


