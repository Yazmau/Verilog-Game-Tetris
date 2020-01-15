`timescale 1ns / 1ps

module clear_line_TRAN_tb;
    reg clk;
    reg reset;
    reg enable;
    reg [0:19] line_full;
    reg [2:0] piece_type;
    wire [4:0] pos_i,pos_j;
    wire clear_line_done;
    wire read;
    wire [2:0] write_data;
    
    clear_line_TRAN main(
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .line_full(line_full),
        .piece_type(piece_type),
        .pos_i(pos_i),
        .pos_j(pos_j),
        .clear_line_done(clear_line_done),
        .read(read),
        .write_data(write_data)
    );
    
    reg [20:0] i;
    
    initial begin
        clk = 1'b0;
        reset = 1'b0;
        enable = 1'b1;
        line_full = 20'd1;
        piece_type = 3'd3;
        
        for(i=0; i<2000; i=i+1) begin
            #(1);
            
            clk = ~clk;
            if(i==1)    reset = 1'b1;
            if(i==3)    reset = 1'b0;
            if(i==7)    line_full = 20'd0;
        end
        
        $finish;
    end
endmodule
