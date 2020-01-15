`timescale 1ns / 1ps
`include "__BUS.h"

module generate_piece_TRAN(clk,reset,enable,hold_piece_type,real_generate,pos_i,pos_j,piece_type,next_tetris,done);
    input clk,reset,enable;
    input [2:0] hold_piece_type;    // if hold_piece_type != NULL_PIECE => hold button has been pressed
    input real_generate;
    output reg [4:0] pos_i,pos_j;
    output [2:0] piece_type;
    output [2:0] next_tetris;
    output done;
     
    reg [2:0] cnt,next_cnt;
    
    assign done = (cnt == 3'd4) ? 1'b1 : 1'b0;
    
    wire next_took;     // whether took out the next tetris or not
    assign next_took = ( (hold_piece_type == `NULL_PIECE) && (real_generate == 1'b1) ) ? done : 1'b0;
    
    wire [2:0] random_piece_type;
    random_tetris random_tetris1(.clk(clk), .rst(reset), .signal_for_next(next_took), .out(random_piece_type));
    
    assign piece_type = (hold_piece_type != `NULL_PIECE) ? hold_piece_type : random_piece_type;
    assign next_tetris = random_piece_type;
    
    always@(posedge clk) begin
        if(enable == 1'b0) begin
            cnt <= 3'd0;
        end
        else begin
            cnt <= next_cnt;
        end
    end
    
    always@(*) begin
        next_cnt = cnt;
        case(piece_type)
            `Q_PIECE: begin
                case(cnt)
                    3'd0: begin
                        pos_i = 0;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd1: begin
                        pos_i = 0;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd2: begin
                        pos_i = 1;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd3: begin
                        pos_i = 1;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd4: begin
                        next_cnt = 2'd0;
                    end
                endcase
            end
            `S_PIECE: begin
                case(cnt)
                    3'd0: begin
                        pos_i = 0;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd1: begin
                        pos_i = 0;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd2: begin
                        pos_i = 1;
                        pos_j = 3;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd3: begin
                        pos_i = 1;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd4: begin
                        next_cnt = 2'd0;
                    end
                endcase
            end
            `Z_PIECE: begin
                case(cnt)
                    3'd0: begin
                        pos_i = 0;
                        pos_j = 3;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd1: begin
                        pos_i = 0;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd2: begin
                        pos_i = 1;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd3: begin
                        pos_i = 1;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd4: begin
                        next_cnt = 2'd0;
                    end
                endcase
            end
            `T_PIECE: begin
                case(cnt)
                    3'd0: begin
                        pos_i = 0;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd1: begin
                        pos_i = 1;
                        pos_j = 3;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd2: begin
                        pos_i = 1;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd3: begin
                        pos_i = 1;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd4: begin
                        next_cnt = 2'd0;
                    end
                endcase
            end
            `L_PIECE: begin
                case(cnt)
                    3'd0: begin
                        pos_i = 0;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd1: begin
                        pos_i = 1;
                        pos_j = 3;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd2: begin
                        pos_i = 1;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd3: begin
                        pos_i = 1;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd4: begin
                        next_cnt = 2'd0;
                    end
                endcase
            end
            `J_PIECE: begin
                case(cnt)
                    3'd0: begin
                        pos_i = 0;
                        pos_j = 3;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd1: begin
                        pos_i = 1;
                        pos_j = 3;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd2: begin
                        pos_i = 1;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd3: begin
                        pos_i = 1;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd4: begin
                        next_cnt = 2'd0;
                    end
                endcase
            end
            `I_PIECE: begin
                case(cnt)
                    3'd0: begin
                        pos_i = 1;
                        pos_j = 3;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd1: begin
                        pos_i = 1;
                        pos_j = 4;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd2: begin
                        pos_i = 1;
                        pos_j = 5;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd3: begin
                        pos_i = 1;
                        pos_j = 6;
                        next_cnt = cnt + 1'b1;
                    end
                    3'd4: begin
                        next_cnt = 2'd0;
                    end
                endcase
            end
            default: begin
            end
        endcase        
    end
endmodule
