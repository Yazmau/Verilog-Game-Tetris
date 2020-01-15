`timescale 1ns / 1ps

module hold_TRAN(clk,enable,falling_piece_i,falling_piece_j,falling_piece_type,falling_piece_angle,pos_i,pos_j,done);
    input clk,enable;
    input [4:0] falling_piece_i,falling_piece_j;
    input [2:0] falling_piece_type;
    input [1:0] falling_piece_angle;
    output reg [4:0] pos_i,pos_j;
    output done;
    
    reg [2:0] cnt,next_cnt;
    
    assign done = (cnt == 3'd4) ? 1'b1 : 1'b0;
    
    always@(posedge clk) begin
        if(enable == 1'b0) begin
            cnt <= 3'd0;
        end
        else begin
            cnt <= next_cnt;
        end
    end
    
    always@(*) begin
        case(falling_piece_type)
            `Q_PIECE: begin
                case(falling_piece_angle)
                    2'd0: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd1: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd2: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd3: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                endcase
            end
            `S_PIECE: begin
                case(falling_piece_angle)
                    2'd0: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd1: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd2: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd3: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                endcase
            end
            `Z_PIECE: begin
                case(falling_piece_angle)
                    2'd0: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd1: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd2: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd3: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                endcase
            end
            `T_PIECE: begin
                case(falling_piece_angle)
                    2'd0: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd1: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd2: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd3: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                endcase
            end
            `L_PIECE: begin
                case(falling_piece_angle)
                    2'd0: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd1: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd2: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd3: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                endcase
            end
            `J_PIECE: begin
                case(falling_piece_angle)
                    2'd0: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd1: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd2: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd3: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                endcase
            end
            `I_PIECE: begin
                case(falling_piece_angle)
                    2'd0: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 3;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd1: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 3;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd2: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 0;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 2;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 3;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                    2'd3: begin
                        case(cnt)
                            3'd0: begin
                                pos_i = falling_piece_i + 0;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd1: begin
                                pos_i = falling_piece_i + 1;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd2: begin
                                pos_i = falling_piece_i + 2;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd3: begin
                                pos_i = falling_piece_i + 3;
                                pos_j = falling_piece_j + 1;
                                next_cnt = cnt + 1'b1;
                            end
                            3'd4: begin
                                next_cnt = 3'd0;
                            end
                        endcase
                    end
                endcase
            end
        endcase
    end
endmodule
