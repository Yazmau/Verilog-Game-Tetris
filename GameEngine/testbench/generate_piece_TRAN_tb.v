`timescale 1ns / 1ps

module generate_piece_TRAN_tb;
    reg clk;
    reg enable;
    wire [4:0] pos_i,pos_j;
    wire [2:0] piece_type;
    wire done;
    
    generate_piece_TRAN main(
        .clk(clk),
        .enable(enable),
        .pos_i(pos_i),
        .pos_j(pos_j),
        .piece_type(piece_type),
        .done(done)
    );
    
    reg [9:0] i;
    
    initial begin
        clk = 1'b0;
        enable = 1'b0;
        
        for(i=0 ; i<12 ; i=i+1) begin
            #(1);
            clk = ~clk;
            if(i==1)    enable = 1'b1;
        end
        
        $finish;
    end
endmodule
