`timescale 1ns / 1ps
module cal_digit(score, clk_25MHz, score_width, score_height, h_cnt, v_cnt, pixel_score);
    input [8:0] score;
    input clk_25MHz;
    input [9:0] score_width, score_height;
    input [9:0] h_cnt, v_cnt;
    output reg [11:0] pixel_score;
    reg [16:0] pixel_addr_score;
    wire [11:0] out;
    wire [11:0] data__;
    //number.coe
    blk_mem_gen_6 scorenumber(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_score),
      .dina(data__[11:0]),
      .douta(out)
    ); 
    always@(*)begin//以二進位顯示，總共8個bits
        if((h_cnt < score_width + 15) && (h_cnt >= score_width) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[7] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 30) && (h_cnt >= score_width + 15) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[6] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 45) && (h_cnt >= score_width + 30) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[5] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 45) && (h_cnt >= score_width + 30) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[4] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 60) && (h_cnt >= score_width + 45) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[3] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 75) && (h_cnt >= score_width + 60) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[2] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 90) && (h_cnt >= score_width + 75) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[2] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 105) && (h_cnt >= score_width + 90) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[1] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else if((h_cnt < score_width + 120) && (h_cnt >= score_width + 105) && (v_cnt < score_height +30) && (v_cnt >= score_height))begin
            if(score[0] == 1'b0)begin
                 pixel_addr_score = (h_cnt - score_width) % 15 + 0 + (v_cnt - score_height) % 30 * 150;
            end
            else begin
                pixel_addr_score = (h_cnt - score_width) % 15 + 15 + (v_cnt - score_height) % 30 * 150;
            end
            pixel_score = out;
        end
        else begin
            pixel_addr_score = 0;
            pixel_score = out;
        end
    end
endmodule

