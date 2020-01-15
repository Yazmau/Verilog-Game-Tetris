`timescale 1ns / 1ps
`include "__BUS.h"

// todo : make "long-pressing"  have an effect ; (actively) increase the falling speed ; (actively) make the piece donw to the bottom
module get_input_TRAN(clk,reset,left_move_button,right_move_button,spin_button,direct_down_button,hold_button,op_executed,hold_valid,next_op_type);
    input clk,reset;
    input left_move_button,right_move_button,spin_button,direct_down_button,hold_button;
    input op_executed;     // if execute the op (op_executed will keep 1'b1 while state is PLAYER_OP_STATE . We use one-pulse on op_executed signal to avoid the signal keep 1'b1 too long.
    input hold_valid;
    output reg [2:0] next_op_type;
       
    wire db_left_move_button,op_left_move_button;
    debounce db1(.clk(clk),.in(left_move_button),.out(db_left_move_button));
    one_pulse op1(.clk(clk),.in(db_left_move_button),.out(op_left_move_button));    
    wire db_right_move_button,op_right_move_button;
    debounce db2(.clk(clk),.in(right_move_button),.out(db_right_move_button));
    one_pulse op2(.clk(clk),.in(db_right_move_button),.out(op_right_move_button));    
    wire db_spin_button,op_spin_button;
    debounce db3(.clk(clk),.in(spin_button),.out(db_spin_button));
    one_pulse op3(.clk(clk),.in(db_spin_button),.out(op_spin_button)); 
    wire db_direct_down_button,op_direct_down_button;
    debounce db4(.clk(clk),.in(direct_down_button),.out(db_direct_down_button));
    one_pulse op4(.clk(clk),.in(db_direct_down_button),.out(op_direct_down_button)); 
    wire db_hold_button,op_hold_button;
    debounce db5(.clk(clk),.in(hold_button),.out(db_hold_button));
    one_pulse op5(.clk(clk),.in(db_hold_button),.out(op_hold_button));
    
    reg [4:0] op_mem,next_op_mem;       // extend the input signal
    
    always@(posedge clk) begin
        if(reset == 1'b1) begin
            op_mem <= 5'd0;
        end
        else begin
            if(op_executed == 1'b1) begin   //  remove the op executed from op_mem
                op_mem <= ((next_op_mem - 1) & next_op_mem);    // make the least bit which is 1 into 0
                                                                // actually some problem will happen when you press the same button twice in short period of time
                                                                // , but human can't archive such speed
            end
            else begin
                op_mem <= next_op_mem;
            end
        end
    end
    
    always@(*) begin    // the least operation (by encoding) has the highest priority priority
        next_op_mem = op_mem;
        if(op_left_move_button == 1'b1)
            next_op_mem[0] = 1'b1;
        if(op_right_move_button == 1'b1)
            next_op_mem[1] = 1'b1;
        if(op_spin_button == 1'b1)
            next_op_mem[2] = 1'b1;
        if(op_direct_down_button == 1'b1)
            next_op_mem[3] = 1'b1;
        if(op_hold_button == 1'b1 && hold_valid == 1'b1)
            next_op_mem[4] = 1'b1;
    end
    
    always@(*) begin
        next_op_type = `NULL_OP;
        if(op_mem[4] == 1'b1)
            next_op_type = `HOLD_OP;
        if(op_mem[3] == 1'b1)
            next_op_type = `DOWN_MOVE_OP;
        if(op_mem[2] == 1'b1)
            next_op_type = `SPIN_OP;
        if(op_mem[1] == 1'b1)
            next_op_type = `RIGHT_MOVE_OP;
        if(op_mem[0] == 1'b1)
            next_op_type = `LEFT_MOVE_OP;
    end
endmodule

module debounce(clk,in,out);
    input clk,in;
    output out;
    
    parameter CYCLE_NUMBER = 10;
    reg [CYCLE_NUMBER-1:0] DFF;
    
    always@(posedge clk) begin
        DFF[CYCLE_NUMBER-1:1] <= DFF[CYCLE_NUMBER-2:0];
        DFF[0] <= in;
    end
    
    assign out = (&DFF);
endmodule

module one_pulse(clk,in,out);
    input clk,in;
    output reg out;
    
    reg pre;
    
    always@(posedge clk) begin
        out <= in & (~pre);
        pre <= in;
    end
endmodule