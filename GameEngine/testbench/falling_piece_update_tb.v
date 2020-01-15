`timescale 1ns / 1ps

module falling_piece_update_tb;
    reg clk,reset;
    reg [4:0] falling_piece_i = 5'd5,falling_piece_j = 5'd5;
    reg [2:0] falling_piece_type = 3'd4;
    reg [1:0] falling_piece_angle = 3'd0;
    reg [2:0] op_type = 3'b001;
    
    wire [4:0] pos_i,pos_j;
    wire check_done,valid;
    wire [2:0] new_piece_type;
    wire update_done;
    
    falling_piece_update main(
        .clk(clk),
        .reset(reset),
        .falling_piece_i(falling_piece_i),
        .falling_piece_j(falling_piece_j),
        .falling_piece_type(falling_piece_type),
        .falling_piece_angle(falling_piece_angle),
        .op_type(op_type),
        .pos_i(pos_i),
        .pos_j(pos_j),
        .piece_type(3'b000),
        .check_done(check_done),
        .valid(valid),
        .new_piece_type(new_piece_type),
        .update_done(update_done)
    );
    
    reg [9:0] i;
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        for(i=0; i<50 ;i=i+1) begin
            #(1);
            clk = ~clk;
            if(i==1)    reset = 1'b0;
        end
        $finish;
    end
endmodule
