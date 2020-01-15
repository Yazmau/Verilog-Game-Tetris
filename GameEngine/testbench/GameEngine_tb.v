`timescale 1ns / 1ps

module GameEngine_tb;
    reg clk;
    reg reset;
    reg [4:0] pos_i,pos_j;
    wire [2:0] data;
    wire [2:0] next_tetris;
    
    reg right_move_button,left_move_button,direct_down_button,hold_button;
    
    GameEngine main(
        .clk(clk),
        .reset(reset),
        .print_i(pos_i),
        .print_j(pos_j),
        .print_data(data),
        .next_tetris(next_tetris),
        .right_move_button(right_move_button),
        .left_move_button(left_move_button),
        .direct_down_button(direct_down_button),
        .hold_button(hold_button)
    );
    
    reg [19:0] i;
    
    initial begin
        clk = 1'b0;
        reset = 1'b0;
        pos_i = 5'd0;
        pos_j = 5'd0;
        right_move_button = 0;
        left_move_button = 0;
        direct_down_button = 0;
        hold_button = 0;
        
        for(i=0; i<50000; i=i+1) begin
            #(1);
            
            clk = ~clk;
            if(i==1)    reset = 1'b1;
            if(i==3)    reset = 1'b0;
            
            if(i[0] == 1) begin
                if(pos_j == 9) begin
                    if(pos_i == 19)
                        pos_i = 0;
                    else
                        pos_i = pos_i + 1;
                    pos_j = 0;
                end
                else
                    pos_j = pos_j + 1;
            end
            
            if(i % 23 != 0)
                right_move_button = 1;
            else
                right_move_button = 0;
//            if(i==251)  reset = 1'b1;
//            if(i==253)  reset = 1'b0;
        end
        
        $finish;
    end
endmodule
