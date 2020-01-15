`timescale 1ns / 1ps
`include "__BUS.h"

// to read and to write the data in board
module board_controller(clk,reset,pos_i,pos_j,write_enable,write_data,output_data,print_i,print_j,print_data,line_full);
    input clk,reset;
    input [4:0] pos_i,pos_j;
    input write_enable;
    input [2:0] write_data;     // write
    output [2:0] output_data;   // read
    
    input [4:0] print_i,print_j;
    output [2:0] print_data;
    output [0:`BOARD_HEIGHT-1] line_full;
    
    reg [0:`BOARD_HEIGHT*`BOARD_WIDTH*3-1] board;
    reg [3:0] piece_number_in_line[0:`BOARD_HEIGHT-1];
    
    always@(posedge clk) begin
        if(reset == 1'b1) begin
            board <= 600'd0;
            piece_number_in_line[0] <= 4'd0;
            piece_number_in_line[1] <= 4'd0;
            piece_number_in_line[2] <= 4'd0;
            piece_number_in_line[3] <= 4'd0;
            piece_number_in_line[4] <= 4'd0;
            piece_number_in_line[5] <= 4'd0;
            piece_number_in_line[6] <= 4'd0;
            piece_number_in_line[7] <= 4'd0;
            piece_number_in_line[8] <= 4'd0;
            piece_number_in_line[9] <= 4'd0;
            piece_number_in_line[10] <= 4'd0;
            piece_number_in_line[11] <= 4'd0;
            piece_number_in_line[12] <= 4'd0;
            piece_number_in_line[13] <= 4'd0;
            piece_number_in_line[14] <= 4'd0;
            piece_number_in_line[15] <= 4'd0;
            piece_number_in_line[16] <= 4'd0;
            piece_number_in_line[17] <= 4'd0;
            piece_number_in_line[18] <= 4'd0;
            piece_number_in_line[19] <= 4'd0;
        end
        else begin
            if(write_enable == 1'b1) begin
                piece_number_in_line[pos_i] <= (write_data == `NULL_PIECE) ? 
                    piece_number_in_line[pos_i] - ({board[(pos_i*`BOARD_WIDTH+pos_j)*3],board[(pos_i*`BOARD_WIDTH+pos_j)*3+1],board[(pos_i*`BOARD_WIDTH+pos_j)*3+2]} == `NULL_PIECE ? 1'b0 : 1'b1) :
                    piece_number_in_line[pos_i] + ({board[(pos_i*`BOARD_WIDTH+pos_j)*3],board[(pos_i*`BOARD_WIDTH+pos_j)*3+1],board[(pos_i*`BOARD_WIDTH+pos_j)*3+2]} == `NULL_PIECE ? 1'b1 : 1'b0);

                {board[(pos_i*`BOARD_WIDTH+pos_j)*3],board[(pos_i*`BOARD_WIDTH+pos_j)*3+1],board[(pos_i*`BOARD_WIDTH+pos_j)*3+2]} <= write_data;
            end
            else begin
                piece_number_in_line[pos_i] <= piece_number_in_line[pos_i];

                {board[(pos_i*`BOARD_WIDTH+pos_j)*3],board[(pos_i*`BOARD_WIDTH+pos_j)*3+1],board[(pos_i*`BOARD_WIDTH+pos_j)*3+2]} <= {board[(pos_i*`BOARD_WIDTH+pos_j)*3],board[(pos_i*`BOARD_WIDTH+pos_j)*3+1],board[(pos_i*`BOARD_WIDTH+pos_j)*3+2]};
            end
        end
    end
    
    assign output_data = ((pos_i >= `BOARD_HEIGHT) || (pos_j >= `BOARD_WIDTH)) ? `NULL_PIECE :
                        {board[(pos_i*`BOARD_WIDTH+pos_j)*3],board[(pos_i*`BOARD_WIDTH+pos_j)*3+1],board[(pos_i*`BOARD_WIDTH+pos_j)*3+2]};
    assign print_data = ((print_i >= `BOARD_HEIGHT) || (print_j >= `BOARD_WIDTH)) ? `NULL_PIECE :
                        {board[(print_i*`BOARD_WIDTH+print_j)*3],board[(print_i*`BOARD_WIDTH+print_j)*3+1],board[(print_i*`BOARD_WIDTH+print_j)*3+2]};
    assign line_full[0] = (piece_number_in_line[0] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[1] = (piece_number_in_line[1] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[2] = (piece_number_in_line[2] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[3] = (piece_number_in_line[3] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[4] = (piece_number_in_line[4] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[5] = (piece_number_in_line[5] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[6] = (piece_number_in_line[6] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[7] = (piece_number_in_line[7] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[8] = (piece_number_in_line[8] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[9] = (piece_number_in_line[9] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[10] = (piece_number_in_line[10] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[11] = (piece_number_in_line[11] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[12] = (piece_number_in_line[12] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[13] = (piece_number_in_line[13] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[14] = (piece_number_in_line[14] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[15] = (piece_number_in_line[15] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[16] = (piece_number_in_line[16] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[17] = (piece_number_in_line[17] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[18] = (piece_number_in_line[18] == 4'd10) ? 1'b1 : 1'b0;
    assign line_full[19] = (piece_number_in_line[19] == 4'd10) ? 1'b1 : 1'b0;
endmodule
