`timescale 1ns / 1ps
`include "__BUS.h"

module GameEngine(clk,reset,left_move_button,right_move_button,spin_button,direct_down_button,print_i,hold_button,print_j,print_data,next_tetris,score,hold_piece_type);
    input clk,reset;
    input left_move_button,right_move_button,spin_button,direct_down_button,hold_button;
    input [4:0] print_i,print_j;    // the coordinate for print
    output [2:0] print_data;
    output [2:0] next_tetris;
    output reg [29:0] score;
    output reg [2:0] hold_piece_type;
    
    
    reg [29:0] next_score;
    
    reg [4:0] pos_i,next_pos_i;
    reg [4:0] pos_j,next_pos_j;
    reg write_enable,next_write_enable;
    reg [2:0] write_data,next_write_data;
    wire [2:0] read_data;
    reg [4:0] next_print_i,next_print_j;
    wire [0:`BOARD_HEIGHT-1] line_full;
    board_controller BC(.clk(clk),.reset(reset),.pos_i(pos_i),.pos_j(pos_j),.write_enable(write_enable),.write_data(write_data),
        .output_data(read_data),.print_i(print_i),.print_j(print_j),.print_data(print_data),.line_full(line_full));
    
    reg [4:0] falling_piece_i,next_falling_piece_i;
    reg [4:0] falling_piece_j,next_falling_piece_j;
    reg [2:0] falling_piece_type,next_falling_piece_type;
    reg [1:0] falling_piece_angle,next_falling_piece_angle;
    
    reg [2:0] op_type,next_op_type;
    
    wire [4:0] FPU_pos_i,FPU_pos_j;
    wire check_done,valid;
    wire update_done;
    wire FPU_write_enable;
    wire [2:0] FPU_new_piece_type;
    reg FPU_reset,next_FPU_reset;
    falling_piece_update FPU(.clk(clk),.reset(FPU_reset),.falling_piece_i(falling_piece_i),.falling_piece_j(falling_piece_j),.falling_piece_type(falling_piece_type),
        .falling_piece_angle(falling_piece_angle),.op_type(op_type),.pos_i(FPU_pos_i),.pos_j(FPU_pos_j),
        .piece_type(read_data),.check_done(check_done),.valid(valid),.write_enable(FPU_write_enable),.new_piece_type(FPU_new_piece_type),.update_done(update_done));
    
    reg [4:0] state,next_state;
    
    parameter START_STATE = 5'd0;
    
    parameter CHECK_GAME_OVER_STATE = 5'd9;
    
    parameter GENERATE_PIECE_STATE = 5'd1;
    wire GP_enable,GP_done;
    wire [4:0] GP_pos_i,GP_pos_j;
    wire [2:0] GP_piece_type;
    reg [2:0] GP_hold_piece_type,next_GP_hold_piece_type;
    reg real_generate,next_real_generate;
    assign GP_enable = ( (state == GENERATE_PIECE_STATE) || (state == CHECK_GAME_OVER_STATE) ) ? 1'b1 : 1'b0;
    generate_piece_TRAN gpTRAN(.clk(clk),.reset(reset),.enable(GP_enable),.hold_piece_type(GP_hold_piece_type),.real_generate(real_generate),
        .pos_i(GP_pos_i),.pos_j(GP_pos_j),.piece_type(GP_piece_type),.next_tetris(next_tetris),.done(GP_done));
    
    parameter DROP_OR_PLAYER_OP_STATE = 5'd2;
    reg [31:0] drop_cnt,next_drop_cnt;
    
    parameter DROP_STATE = 5'd3;
    
    parameter GET_INPUT_STATE = 5'd4;
    wire [2:0] GI_next_op_type;
    wire GI_reset;
    assign GI_reset = (state == START_STATE) ? 1'b1 : 1'b0;
    wire op_executed;
    reg hold_valid,next_hold_valid;
    get_input_TRAN giTRAN(.clk(clk),.reset(GI_reset),.left_move_button(left_move_button),.right_move_button(right_move_button),
        .spin_button(spin_button),.direct_down_button(direct_down_button),.hold_button(hold_button),
        .op_executed(op_executed),.hold_valid(hold_valid),.next_op_type(GI_next_op_type));    
    
    parameter PLAYER_OP_STATE = 5'd5;
    
    parameter HOLD_STATE = 5'd10;
    assign op_executed = ( (state == PLAYER_OP_STATE) || (state == HOLD_STATE) ) ? 1'b1 : 1'b0;        
    wire H_enable;
    wire [4:0] H_pos_i,H_pos_j;
    wire H_done;
    hold_TRAN hTRAN(.clk(clk),.enable(H_enable),.falling_piece_i(falling_piece_i),.falling_piece_j(falling_piece_j),.falling_piece_type(falling_piece_type),
        .falling_piece_angle(falling_piece_angle),.pos_i(H_pos_i),.pos_j(H_pos_j),.done(H_done));
    assign H_enable = (state == HOLD_STATE) ? 1'b1 : 1'b0;
    reg [2:0] next_hold_piece_type;
    
    parameter CHECK_BOTTOM_STATE = 5'd6;
    
    parameter CHECK_CLEAR_STATE = 5'd7;
    
    parameter CLEAR_LINE_STATE = 5'd8;
    wire clear_line_enable;
    assign clear_line_enable = (state == CLEAR_LINE_STATE) ? 1'b1 : 1'b0;
    wire clear_line_done;
    wire clear_line_read;
    wire [4:0] CL_pos_i,CL_pos_j;
    wire [2:0] CL_piece_type;
    clear_line_TRAN clTRAN(.clk(clk),.reset(reset),.enable(clear_line_enable),.line_full(line_full),.piece_type(read_data),
        .pos_i(CL_pos_i),.pos_j(CL_pos_j),.clear_line_done(clear_line_done),.read(clear_line_read),.write_data(CL_piece_type));
    
    reg game_over,next_game_over;
    
    parameter GAME_OVER_STATE = 5'd11;
    
    reg [31:0] drop_cd,next_drop_cd;
    
    always@(posedge clk) begin
        if(reset == 1'b1) begin
            score <= 30'd0;
            state <= START_STATE;
            
            pos_i <= 5'd0;
            pos_j <= 5'd0;
            write_enable <= 1'b0;
            write_data <= `NULL_PIECE;
            
            falling_piece_i <= 5'd0;
            falling_piece_j <= 5'd0;
            falling_piece_type <= `NULL_PIECE;
            falling_piece_angle <= 2'd0;
            
            FPU_reset <= 1'b1;
            
            op_type <= `NULL_OP;
            
            GP_hold_piece_type <= `NULL_PIECE;
            hold_piece_type <= `NULL_PIECE;
            hold_valid <= 1'b1;
            real_generate <= 1'b0;
            
            drop_cnt <= 32'd0;
            
            game_over <= 1'b0;
            
            drop_cd <= 32'd10000000;
        end
        else begin
            score <= next_score;
            state <= next_state;
            
            pos_i <= next_pos_i;
            pos_j <= next_pos_j;
            write_enable <= next_write_enable;
            write_data <= next_write_data;
            
            falling_piece_i <= next_falling_piece_i;
            falling_piece_j <= next_falling_piece_j;
            falling_piece_type <= next_falling_piece_type;
            falling_piece_angle <= next_falling_piece_angle;
            
            FPU_reset <= next_FPU_reset;
            
            op_type <= next_op_type;
            
            GP_hold_piece_type <= next_GP_hold_piece_type;
            hold_piece_type <= next_hold_piece_type;
            hold_valid <= next_hold_valid;
            real_generate <= next_real_generate;
            
            drop_cnt <= next_drop_cnt;
            
            game_over <= next_game_over;
            
            drop_cd <= next_drop_cd;
        end
    end
    
    always@(*) begin
        next_score = score;
        next_state = state;
        next_pos_i = pos_i;
        next_pos_j = pos_j;
        next_write_enable = write_enable;
        next_write_data = write_data;
        next_falling_piece_i = falling_piece_i;
        next_falling_piece_j = falling_piece_j;
        next_falling_piece_type = falling_piece_type;
        next_falling_piece_angle = falling_piece_angle;
        next_FPU_reset = 1'b0;
        next_op_type = op_type;
        next_GP_hold_piece_type = GP_hold_piece_type;
        next_hold_piece_type = hold_piece_type;
        next_hold_valid = hold_valid;
        next_real_generate = real_generate;
        next_game_over = game_over;
        case(state)
            START_STATE: begin
                next_state = GENERATE_PIECE_STATE;
            end
            GENERATE_PIECE_STATE: begin
                next_state = (GP_done == 1'b1) ? DROP_OR_PLAYER_OP_STATE : GENERATE_PIECE_STATE;
                next_pos_i = GP_pos_i;
                next_pos_j = GP_pos_j;
                next_write_enable = (GP_done == 1'b1) ? 1'b0 : 1'b1;
                next_write_data = GP_piece_type;
                next_falling_piece_i = 5'd0;
                next_falling_piece_j = 5'd3;
                next_falling_piece_type = GP_piece_type;
                next_falling_piece_angle = 4'd0;
                next_GP_hold_piece_type = (GP_done == 1'b1) ? `NULL_PIECE : GP_hold_piece_type;
                next_real_generate = (GP_done == 1'b1) ? 1'b0 : real_generate;
            end
            DROP_OR_PLAYER_OP_STATE: begin
                next_state = (drop_cnt >= drop_cd) ? DROP_STATE : GET_INPUT_STATE;
                next_op_type = (drop_cnt >= drop_cd) ? `DOWN_MOVE_OP : `NULL_OP;
                next_FPU_reset = 1'b1;
            end
            DROP_STATE: begin
                next_pos_i = FPU_pos_i;
                next_pos_j = FPU_pos_j;
                next_write_enable = FPU_write_enable;
                next_write_data = FPU_new_piece_type;
                
                if(check_done == 1'b1) begin        // 判斷操作合法性
                    if(valid == 1'b1) begin
                        next_state = state;
                    end
                    else begin      // 不合法，忽略
                        next_state = DROP_OR_PLAYER_OP_STATE;
                    end
                end
                else begin
                    next_state = state;
                end
                
                if(write_enable == 1'b1 && update_done == 1'b1) begin       // 更新完畢
                    next_state = CHECK_BOTTOM_STATE;
                    next_write_enable = 1'b0;
                    next_op_type = `DOWN_MOVE_OP;    // for CHECK_BOTTOM_STATE（模擬方塊掉落）
                    next_falling_piece_i = falling_piece_i + 1'b1;
                end
            end
            GET_INPUT_STATE: begin
                next_state = (GI_next_op_type != `NULL_OP) ? ( (GI_next_op_type == `HOLD_OP) ? HOLD_STATE : PLAYER_OP_STATE) : DROP_OR_PLAYER_OP_STATE;
                next_op_type = GI_next_op_type;
            end
            PLAYER_OP_STATE: begin
                next_pos_i = FPU_pos_i;
                next_pos_j = FPU_pos_j;
                next_write_enable = FPU_write_enable;
                next_write_data = FPU_new_piece_type;
                
                if(check_done == 1'b1) begin        // 判斷操作合法性
                    if(valid == 1'b1) begin
                        next_state = state;
                    end
                    else begin
                        next_state = CHECK_BOTTOM_STATE;    // if use direct down , then it will terminate here
                        next_op_type = `DOWN_MOVE_OP;   // for CHECK_BOTTOM_STATE
                    end
                end
                else begin
                    next_state = state;
                end
                
                if(write_enable == 1'b1 && update_done == 1'b1) begin       // 更新完畢
                    if(op_type != `DOWN_MOVE_OP) begin
                        next_state = CHECK_BOTTOM_STATE;
                        next_write_enable = 1'b0;
                        next_op_type = `DOWN_MOVE_OP;   // for CHECK_BOTTOM_STATE
                    end
                    
                    case(op_type)
                        `LEFT_MOVE_OP:
                            next_falling_piece_j = falling_piece_j - 1'b1;
                        `RIGHT_MOVE_OP:
                            next_falling_piece_j = falling_piece_j + 1'b1;
                        `SPIN_OP:
                            next_falling_piece_angle = falling_piece_angle + 1'b1;
                        `DOWN_MOVE_OP:      // direct down
                            next_falling_piece_i = falling_piece_i + 1'b1;
                    endcase
                end
            end
            HOLD_STATE: begin
                next_state = (H_done == 1'b1) ? GENERATE_PIECE_STATE : state;
                next_pos_i = H_pos_i;
                next_pos_j = H_pos_j;
                next_write_enable = (H_done == 1'b1) ? 1'b0 : 1'b1;
                next_write_data = `NULL_PIECE;
                if(H_done == 1'b1) begin
                    next_GP_hold_piece_type = hold_piece_type;
                    next_hold_piece_type = falling_piece_type;
                end
                next_hold_valid = 1'b0;
                next_real_generate = 1'b1;
            end
            CHECK_BOTTOM_STATE: begin
                next_pos_i = FPU_pos_i;
                next_pos_j = FPU_pos_j;
                
                if(check_done == 1'b1) begin
                    if(valid == 1'b1) begin
                        next_state = DROP_OR_PLAYER_OP_STATE;
                    end
                    else begin
                        next_state = CHECK_CLEAR_STATE;
                    end
                    next_op_type = `NULL_OP;
                end
                else begin
                    next_state = state;
                end
            end
            CHECK_CLEAR_STATE: begin
                next_state = (line_full == 20'd0) ? CHECK_GAME_OVER_STATE : CLEAR_LINE_STATE;
                next_score = (line_full == 20'd0) ? score : score+line_full[0]+line_full[1]+line_full[2]+line_full[3]+line_full[4]+line_full[5]+line_full[6]+line_full[7]+line_full[8]+line_full[9]+line_full[10]+line_full[11]+line_full[12]+line_full[13]+line_full[14]+line_full[15]+line_full[16]+line_full[17]+line_full[18]+line_full[19];
                next_hold_valid = 1'b1;
                next_pos_i = 5'd31;
                next_pos_j = 5'd31;
            end
            CLEAR_LINE_STATE: begin
                next_state = (clear_line_done == 1'b1) ? CHECK_GAME_OVER_STATE : state;
                next_pos_i = (clear_line_done == 1'b1) ? 5'd31 : CL_pos_i;
                next_pos_j = (clear_line_done == 1'b1) ? 5'd31 : CL_pos_j;
                next_write_enable = ( (clear_line_done == 1'b1) || (clear_line_read == 1'b1) ) ? 1'b0 : 1'b1;
                next_write_data = CL_piece_type;
            end
            CHECK_GAME_OVER_STATE: begin
                next_game_over = game_over | (read_data != `NULL_PIECE);
                next_pos_i = GP_pos_i; 
                next_pos_j = GP_pos_j;
                if(GP_done == 1'b1) begin
                    next_state = (next_game_over == 1'b1) ? GAME_OVER_STATE : GENERATE_PIECE_STATE;
                    next_real_generate = (next_game_over == 1'b1) ? 1'b0 : 1'b1;
                end
                else begin
                    next_state = state;
                end
            end
            default: begin
            end
        endcase
    end
    
    always@(*) begin        // 自然掉落計時器更新
        if(drop_cnt >= drop_cd)
            next_drop_cnt = (state == DROP_STATE) ? 32'd0 : drop_cnt;
        else
            next_drop_cnt = drop_cnt + 1'b1;
    end
    
    always@(*) begin        // 調整掉落速度
        next_drop_cd = drop_cd;
        if(score >= 2)
            next_drop_cd = 32'd5000000;
        if(score >= 4)
            next_drop_cd = 32'd3333333;
        if(score >= 6)
            next_drop_cd = 32'd2500000;
        if(score >= 8)
            next_drop_cd = 32'd2000000;
    end
endmodule
