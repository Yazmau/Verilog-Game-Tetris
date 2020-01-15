`timescale 1ns / 1ps
`include "__BUS.h"

module clear_line_TRAN(clk,reset,enable,line_full,piece_type,pos_i,pos_j,clear_line_done,read,write_data);
    input clk,reset,enable;
    input [0:`BOARD_HEIGHT-1] line_full;
    input [2:0] piece_type;
    output reg [4:0] pos_i,pos_j;
    output clear_line_done;
    output reg read;
    output reg [2:0] write_data;
    
    assign clear_line_done = ( (enable == 1'b1) && (line_full == 20'd0) && (pos_i >= `BOARD_HEIGHT) ) ? 1'b1 : 1'b0;
    
    reg [4:0] next_pos_i,next_pos_j;
    
    reg next_read;
    
    reg [2:0] next_write_data;
    
    wire [4:0] row_idx;
    least_bit_decoder LBD(line_full,row_idx);
    
    reg [1:0] state,next_state;
    
    parameter WAIT_STATE = 2'd0;
    
    parameter CLEAR_STATE = 2'd1;
    
    parameter UPDATE_STATE = 2'd2;
    reg [1:0] cnt,next_cnt;
    
//    assign next_piece_type = (state != UPDATE_STATE) ? `NULL_PIECE : piece_type;
    
    always@(posedge clk) begin
        if(reset == 1'b1 || enable == 1'b0) begin
            state <= WAIT_STATE;
            pos_i <= 5'd0;
            pos_j <= 5'd0;
            read <= 1'b0;   // don't care
            cnt <= 2'd0;
            write_data <= `NULL_PIECE;
        end
        else begin
            state <= next_state;
            pos_i <= next_pos_i;
            pos_j <= next_pos_j;
            read <= next_read;
            cnt <= next_cnt;
            write_data <= next_write_data;
        end
    end
    
    always@(*) begin
        next_state = state;
        next_pos_i = pos_i;
        next_pos_j = pos_j;
        next_read = read;
        next_cnt = cnt;
        next_write_data = `NULL_PIECE;
        case(state)
            WAIT_STATE: begin
                next_state = (line_full != 20'd0) ? CLEAR_STATE : state;
                next_pos_i = (line_full != 20'd0) ? row_idx : 5'd0;
                next_pos_j = 5'd0;
                next_read = 1'b0;
            end
            CLEAR_STATE: begin
                if(pos_j == 5'd9) begin
                    next_state = UPDATE_STATE;
                    next_pos_i = pos_i - 1'b1;
                    next_pos_j = 5'd0;
                    next_read = 1'b1;
                    next_cnt = 2'd0;
                end
                else begin
                    next_state = state;
                    next_pos_i = pos_i;
                    next_pos_j = pos_j + 1'b1;
                end
            end
            UPDATE_STATE: begin
                if( (pos_i >= `BOARD_HEIGHT) && (pos_i + 1'b1 >= `BOARD_HEIGHT) ) begin // natural overflow
                    next_state = WAIT_STATE;        // terminate
                end
                else begin
                    next_state = state;
                    case(cnt)
                        2'd0: begin
                            next_cnt = cnt + 1'b1;
                        end
                        2'd1: begin
                            next_pos_i = pos_i + 1'b1;
                            next_read = 1'b0;
                            next_cnt = cnt + 1'b1;
                            next_write_data = piece_type;
                        end
                        2'd2: begin
                            if(pos_j == 5'd9) begin
                                next_pos_i = pos_i - 5'd2;
                                next_pos_j = 5'd0;
                            end
                            else begin
                                next_pos_i = pos_i - 1'b1;
                                next_pos_j = pos_j + 1'b1;
                            end
                            next_read = 1'b1;
                            next_cnt = 2'd0;
                        end
                    endcase
                end
            end
        endcase
    end
endmodule

module least_bit_decoder(line_full,bit_num);
    input [0:`BOARD_HEIGHT-1] line_full;
    output reg [4:0] bit_num;
    
    always@(*) begin
        bit_num = 5'd0;
        if(line_full[19] == 1'b1)
            bit_num = 5'd19;
        if(line_full[18] == 1'b1)
            bit_num = 5'd18;
        if(line_full[17] == 1'b1)
            bit_num = 5'd17;
        if(line_full[16] == 1'b1)
            bit_num = 5'd16;
        if(line_full[15] == 1'b1)
            bit_num = 5'd15;
        if(line_full[14] == 1'b1)
            bit_num = 5'd14;
        if(line_full[13] == 1'b1)
            bit_num = 5'd13;
        if(line_full[12] == 1'b1)
            bit_num = 5'd12;
        if(line_full[11] == 1'b1)
            bit_num = 5'd11;
        if(line_full[10] == 1'b1)
            bit_num = 5'd10;
        if(line_full[9] == 1'b1)
            bit_num = 5'd9;
        if(line_full[8] == 1'b1)
            bit_num = 5'd8;
        if(line_full[7] == 1'b1)
            bit_num = 5'd7;
        if(line_full[6] == 1'b1)
            bit_num = 5'd6;
        if(line_full[5] == 1'b1)
            bit_num = 5'd5;
        if(line_full[4] == 1'b1)
            bit_num = 5'd4;
        if(line_full[3] == 1'b1)
            bit_num = 5'd3;
        if(line_full[2] == 1'b1)
            bit_num = 5'd2;
        if(line_full[1] == 1'b1)
            bit_num = 5'd1;
        if(line_full[0] == 1'b1)
            bit_num = 5'd0;    
    end
endmodule