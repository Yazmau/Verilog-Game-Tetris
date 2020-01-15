module pixel_gen(
   input [9:0] h_cnt,
   input valid,
   input [9:0] v_cnt,
   input [0:2] data1,
   input [0:2] data2,
   input [1:0] state_scene,
   input clk,
   input clk_25MHz,
   input rst,
   input btn1,
   input btn2,
   input [0:2] next_tetris1,
   input [0:2] next_tetris2,
   input [0:2] hold1,
   input [0:2] hold2,
   input [8:0] score1,
   input [8:0] score2,
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue
   );
    //for one player
    parameter hold_next_height = 120;
    parameter score_height = 30;
    parameter score_width = 290;
    parameter square_width = 240;
    parameter hold_width = 165;
    parameter next_width = 405;
    parameter number_width = 255;
    parameter number_height = 75;
    //for two player
    //1P
    parameter hold_next_height_2p = 150;
    parameter score1_height_1p = 30;
    parameter score1_width_1p = 135;
    parameter number1_height_1p = 75;
    parameter number1_width_1p = 105;
    parameter square1_width_1p = 90;
    parameter hold1_width_1p = 15;
    parameter next1_width_1p = 255;
    //2p
    parameter score2_height_2p = 30;
    parameter score2_width_2p = 450;
    parameter number2_height_2p = 75;
    parameter number2_width_2p = 420;
    parameter square2_width_2p = 405;
    parameter hold2_width_2p = 330;
    parameter next2_width_2p = 570;
    //variable for blk_mem_gen
    wire [11:0] data__;
    reg [16:0] pixel_addr_square, pixel_addr_arrow, pixel_addr_tetris, pixel_addr_back, pixel_addr_next, pixel_addr_hold, pixel_addr_score, pixel_addr_win1, pixel_addr_win2;
    wire [11:0] pixel_square, pixel_arrow, pixel_tetris, pixel_back, pixel_next, pixel_hold, pixel_score, pixel_win1, pixel_win2;
    //hold.coe
    blk_mem_gen_hold hold(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_hold),
      .dina(data__[11:0]),
      .douta(pixel_hold)
    ); 
    //next.coe
    blk_mem_gen_4 next(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_next),
      .dina(data__[11:0]),
      .douta(pixel_next)
    ); 
    //tetris2.coe
    blk_mem_gen_0 tetris(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_tetris),
      .dina(data__[11:0]),
      .douta(pixel_tetris)
    ); 
    //line.coe
    blk_mem_gen_5 score(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_score),
      .dina(data__[11:0]),
      .douta(pixel_score)
    ); 
    //back.coe
    blk_mem_gen_1 back(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_back),
      .dina(data__[11:0]),
      .douta(pixel_back)
    ); 
    //start3.coe
    blk_mem_gen_3 arrow(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_arrow),
      .dina(data__[11:0]),
      .douta(pixel_arrow)
    ); 
    //square.coe
    blk_mem_gen_2 square(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_square),
      .dina(data__[11:0]),
      .douta(pixel_square)
    ); 
    //state for start scene
    wire [1:0] start_state;
    changestartscene c1(.clk(clk), .rst(rst), .h_cnt(h_cnt), .v_cnt(v_cnt), .state(start_state));
    //rgb for line number image
    wire [11:0] number_1p, number1_1p, number2_2p;
    cal_digit  cal1(.score(score1), .clk_25MHz(clk_25MHz), .score_width(number1_width_1p), .score_height(number1_height_1p), .h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_score(number1_1p));
    cal_digit  cal2(.score(score2), .clk_25MHz(clk_25MHz), .score_width(number2_width_2p), .score_height(number2_height_2p), .h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_score(number2_2p));
    always@(*)begin
        if(!valid)begin
            pixel_addr_back = 17'd800;
            pixel_addr_square = 105;
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        end
        else if(state_scene == 2'b00)begin//startscene
            case(start_state)
                2'b00:begin
                    if((h_cnt >= 135) && (h_cnt < 150) && (v_cnt >= 75) && (v_cnt < 90))begin//1
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 135) && (h_cnt < 180) && (v_cnt >= 90) && (v_cnt < 105))begin
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 135) && (h_cnt < 165) && (v_cnt >= 210) && (v_cnt < 225))begin//2
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 150) && (h_cnt < 180) && (v_cnt >= 225) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 120) && (h_cnt < 180) && (v_cnt >= 300) && (v_cnt < 315))begin//3
                        pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 510) && (v_cnt >= 300) && (v_cnt < 330))begin//4
                        pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 255) && (v_cnt < 270))begin//5
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 300) && (h_cnt < 345) && (v_cnt >= 270) && (v_cnt < 285))begin
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 495) && (h_cnt < 510) && (v_cnt >= 75) && (v_cnt < 90))begin//6
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 465) && (h_cnt < 510) && (v_cnt >= 90) && (v_cnt < 105))begin
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 510) && (v_cnt >= 210) && (v_cnt < 225))begin//7
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 465) && (h_cnt < 495) && (v_cnt >= 225) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 210) && ( h_cnt < 435) && (v_cnt >= 45) && (v_cnt < 180))begin//Tetris image
                        pixel_addr_square = 105;
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = (((h_cnt-210) % 225) + 0) + (((v_cnt-45) % 135) * 225);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_tetris;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 330) && (v_cnt < 345))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn2 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 420) && (v_cnt < 435))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn1 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 270) && (h_cnt < 285) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 360) && (h_cnt < 375) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end 
                    else begin//黑色方格
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = 0;
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                end
                2'b01:begin
                    if((h_cnt >= 165) && (h_cnt < 180) && (v_cnt >= 75) && (v_cnt < 90))begin//1
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 150) && (h_cnt < 165) && (v_cnt >= 75) && (v_cnt < 120))begin
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 165) && (h_cnt < 180) && (v_cnt >= 195) && (v_cnt < 225))begin//2
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 150) && (h_cnt < 165) && (v_cnt >= 210) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 120) && (h_cnt < 180) && (v_cnt >= 300) && (v_cnt < 315))begin//3
                        pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 510) && (v_cnt >= 300) && (v_cnt < 330))begin//4
                        pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 255) && (v_cnt < 300))begin//5
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 330) && (h_cnt < 345) && (v_cnt >= 270) && (v_cnt < 285))begin
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 465) && (h_cnt < 480) && (v_cnt >= 75) && (v_cnt < 90))begin//6
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 495) && (v_cnt >= 75) && (v_cnt < 120))begin
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 495) && (v_cnt >= 195) && (v_cnt < 225))begin//7
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 495) && (h_cnt < 510) && (v_cnt >= 210) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 210) && (h_cnt < 302) && (v_cnt >= 405) && (v_cnt < 450))begin//start arrow image
                        pixel_addr_square = 105;
                        pixel_addr_arrow = (((h_cnt-210) % 90) + 0) + (((v_cnt-405) % 45) * 90);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_arrow;
                    end
                    else if((h_cnt >= 210) && ( h_cnt < 435) && (v_cnt >= 45) && (v_cnt < 180))begin//tetris image
                        pixel_addr_square = 105;
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = (((h_cnt-210) % 225) + 0) + (((v_cnt-45) % 135) * 225);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_tetris;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 330) && (v_cnt < 345))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn2 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 420) && (v_cnt < 435))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn1 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 270) && (h_cnt < 285) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 360) && (h_cnt < 375) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end 
                    else begin//黑色方格
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = 0;
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                end
                2'b10:begin
                    if((h_cnt >= 135) && (h_cnt < 180) && (v_cnt >= 75) && (v_cnt < 90))begin//1
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 165) && (h_cnt < 180) && (v_cnt >= 90) && (v_cnt < 105))begin
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 135) && (h_cnt < 165) && (v_cnt >= 210) && (v_cnt < 225))begin//2
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 150) && (h_cnt < 180) && (v_cnt >= 225) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 120) && (h_cnt < 180) && (v_cnt >= 300) && (v_cnt < 315))begin//3
                        pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 510) && (v_cnt >= 300) && (v_cnt < 330))begin//4
                        pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 285) && (v_cnt < 300))begin//5
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 300) && (h_cnt < 345) && (v_cnt >= 270) && (v_cnt < 285))begin
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 465) && (h_cnt < 510) && (v_cnt >= 75) && (v_cnt < 90))begin//6
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 465) && (h_cnt < 480) && (v_cnt >= 90) && (v_cnt < 105))begin
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 510) && (v_cnt >= 210) && (v_cnt < 225))begin//7
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 465) && (h_cnt < 495) && (v_cnt >= 225) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 210) && (h_cnt < 302) && (v_cnt >= 405) && (v_cnt < 450))begin//start arrow image
                        pixel_addr_square = 105;
                        pixel_addr_arrow = (((h_cnt-210) % 90) + 0) + (((v_cnt-405) % 45) * 90);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_arrow;
                    end
                    else if((h_cnt >= 210) && ( h_cnt < 435) && (v_cnt >= 45) && (v_cnt < 180))begin//tetris image
                        pixel_addr_square = 105;
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = (((h_cnt-210) % 225) + 0) + (((v_cnt-45) % 135) * 225);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_tetris;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 330) && (v_cnt < 345))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn2 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 420) && (v_cnt < 435))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn1 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 270) && (h_cnt < 285) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 360) && (h_cnt < 375) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end 
                    else begin//黑色方格
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = 0;
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                end
                2'b11:begin
                    if((h_cnt >= 150) && (h_cnt < 165) && (v_cnt >= 105) && (v_cnt < 120))begin//1
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 165) && (h_cnt < 180) && (v_cnt >= 75) && (v_cnt < 120))begin
                            pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                            {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 165) && (h_cnt < 180) && (v_cnt >= 195) && (v_cnt < 225))begin//2
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 150) && (h_cnt < 165) && (v_cnt >= 210) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 120) && (h_cnt < 180) && (v_cnt >= 300) && (v_cnt < 315))begin//3
                        pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 510) && (v_cnt >= 300) && (v_cnt < 330))begin//4
                        pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 255) && (v_cnt < 300))begin//5
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 300) && (h_cnt < 315) && (v_cnt >= 270) && (v_cnt < 285))begin
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 495) && (v_cnt >= 105) && (v_cnt < 120))begin//6
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 465) && (h_cnt < 480) && (v_cnt >= 75) && (v_cnt < 120))begin
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 480) && (h_cnt < 495) && (v_cnt >= 195) && (v_cnt < 225))begin//7
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 495) && (h_cnt < 510) && (v_cnt >= 210) && (v_cnt < 240))begin
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                    else if((h_cnt >= 210) && (h_cnt < 302) && (v_cnt >= 405) && (v_cnt < 450))begin//start arrow image
                        pixel_addr_square = 105;
                        pixel_addr_arrow = (((h_cnt-210) % 90) + 0) + (((v_cnt-405) % 45) * 90);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_arrow;
                    end
                    else if((h_cnt >= 210) && ( h_cnt < 435) && (v_cnt >= 45) && (v_cnt < 180))begin//tetris image
                        pixel_addr_square = 105;
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = (((h_cnt-210) % 225) + 0) + (((v_cnt-45) % 135) * 225);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_tetris;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 330) && (v_cnt < 345))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn2 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 315) && (h_cnt < 330) && (v_cnt >= 420) && (v_cnt < 435))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        if(btn1 == 1'b1)begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;
                        end
                        else begin
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        end
                    end
                    else if((h_cnt >= 270) && (h_cnt < 285) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                    else if((h_cnt >= 360) && (h_cnt < 375) && (v_cnt >= 375) && (v_cnt < 390))begin//button
                        pixel_addr_arrow = 0;
                        pixel_addr_square = 105;
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end 
                    else begin//喝色方格
                        pixel_addr_arrow = 0;
                        pixel_addr_tetris = 0;
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        {vgaRed, vgaGreen, vgaBlue} = pixel_square;
                    end
                end
            endcase
        end
        else if(state_scene == 2'b01)begin//1P
            if((h_cnt < square_width + 152) && (h_cnt >= square_width) && (v_cnt < 300 + hold_next_height) && (v_cnt >= hold_next_height))begin//遊戲版面
                case({data1[0], data1[1], data1[2]})//方塊種類
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                    end
                    3'd2:begin
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                    end
                    3'd3:begin
                        pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                    end
                    3'd4:begin
                        pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                    end
                    3'd5:begin
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                    end
                    3'd6:begin
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                    end
                    3'd7:begin
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else if((h_cnt < score_width + 60) && (h_cnt >= score_width) && (v_cnt < score_height + 30) && (v_cnt >= score_height))begin//line標誌
                pixel_addr_score = ((h_cnt - score_width) % 60) + ((v_cnt - score_height) % 30) * 60;
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_square = 0;
                {vgaRed, vgaGreen, vgaBlue} = pixel_score;
            end
            else if((h_cnt < number_width + 123) && (h_cnt >= number_width) && (v_cnt < number_height + 30) && (v_cnt >= number_height))begin//line number
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_square = 0;
                {vgaRed, vgaGreen, vgaBlue} = number_1p;;
            end
            else if((h_cnt < hold_width + 63) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 30) && (v_cnt >= hold_next_height))begin//hold 標誌
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_square = 105;
                pixel_addr_score = 0;
                pixel_addr_hold = (h_cnt - hold_width) % 60 + ((v_cnt - hold_next_height) % 30) * 60;
                {vgaRed, vgaGreen, vgaBlue} = pixel_hold;
            end
            else if((h_cnt < next_width + 63) && (h_cnt >= next_width) && (v_cnt < hold_next_height +30) && (v_cnt >= hold_next_height))begin//next 標誌
                pixel_addr_back = 800;
                pixel_addr_hold = 0;
                pixel_addr_square = 105;
                pixel_addr_score = 0;
                pixel_addr_next = (h_cnt - next_width) % 60 + ((v_cnt - hold_next_height) % 30) * 60;
                {vgaRed, vgaGreen, vgaBlue} = pixel_next;
            end
            else if((h_cnt < hold_width + 63) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 30))begin//hold's tetris
                case(hold1)//方塊種類
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        if((h_cnt < hold_width + 45) && (h_cnt >= hold_width + 15))begin
                            if((v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 30))begin
                                pixel_addr_square = ((h_cnt % 15) + 0) + ((v_cnt % 15) * 120);
                            end
                            else begin
                                pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                            end
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd2:begin
                        if((h_cnt < hold_width + 45) && (h_cnt >= hold_width + 15) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold_width + 30) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd3:begin
                        if((h_cnt < hold_width + 45) && (h_cnt >= hold_width + 15) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold_width + 30) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd4:begin
                        if((h_cnt < hold_width + 30) && (h_cnt >= hold_width + 15) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold_width + 45) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd5:begin
                        if((h_cnt < hold_width + 45) && (h_cnt >= hold_width + 30) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold_width + 45) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd6:begin
                        if((h_cnt < hold_width + 15) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold_width + 45) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd7:begin
                        if((h_cnt < hold_width + 60) && (h_cnt >= hold_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_score = 0;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else if((h_cnt < next_width + 63) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 60) && (v_cnt >=hold_next_height + 30))begin//next tetris
                case(next_tetris1)
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        if((h_cnt < next_width + 45) && (h_cnt >= next_width + 15))begin
                            if((v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 30))begin
                                pixel_addr_square = ((h_cnt % 15) + 0) + ((v_cnt % 15) * 120);
                            end
                            else begin
                                pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                            end
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd2:begin
                        if((h_cnt < next_width + 45) && (h_cnt >= next_width + 15) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next_width + 30) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd3:begin
                        if((h_cnt < next_width + 45) && (h_cnt >= next_width + 15) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next_width + 30) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd4:begin
                        if((h_cnt < next_width + 30) && (h_cnt >= next_width + 15) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next_width + 45) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd5:begin
                        if((h_cnt < next_width + 45) && (h_cnt >= next_width + 30) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next_width + 45) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd6:begin
                        if((h_cnt < next_width + 15) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 45) && (v_cnt >= hold_next_height + 30))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next_width + 45) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd7:begin
                        if((h_cnt < next_width + 60) && (h_cnt >= next_width) && (v_cnt < hold_next_height + 60) && (v_cnt >= hold_next_height + 45))begin
                            pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_score = 0;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else begin//背景
                pixel_addr_square = 105;
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = (h_cnt/2 + v_cnt/2 * 320) % 76800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_back;
            end
        end
        else if(state_scene == 2'b10)begin//2P
            if((h_cnt < square1_width_1p + 152) && (h_cnt >= square1_width_1p) && (v_cnt < hold_next_height_2p + 300 - 30) && (v_cnt >= hold_next_height_2p - 30))begin//1P版面
                case({data1[0], data1[1], data1[2]})
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                    end
                    3'd2:begin
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                    end
                    3'd3:begin
                        pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                    end
                    3'd4:begin
                        pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                    end
                    3'd5:begin
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                    end
                    3'd6:begin
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                    end
                    3'd7:begin
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else if((h_cnt < score1_width_1p + 60) && (h_cnt >= score1_width_1p) && (v_cnt < score1_height_1p + 30) && (v_cnt >= score1_height_1p))begin
                pixel_addr_score = ((h_cnt - score1_width_1p) % 60) + ((v_cnt - score1_height_1p) % 30) * 60;
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_square = 0;
                {vgaRed, vgaGreen, vgaBlue} = pixel_score;
            end
            else if((h_cnt < number1_width_1p + 123) && (h_cnt >= number1_width_1p) && (v_cnt < number1_height_1p + 30) && (v_cnt >= number1_height_1p))begin
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_square = 0;
                {vgaRed, vgaGreen, vgaBlue} = number1_1p;;
            end
            else if((h_cnt < hold1_width_1p + 63) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 30 - 30) && (v_cnt >= hold_next_height_2p - 30))begin
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_square = 105;
                pixel_addr_score = 0;
                pixel_addr_hold = (h_cnt - hold1_width_1p) % 60 + ((v_cnt + 30 - hold_next_height_2p) % 30) * 60;
                {vgaRed, vgaGreen, vgaBlue} = pixel_hold;
            end
            else if((h_cnt < next1_width_1p + 63) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 30 - 30) && (v_cnt >= hold_next_height_2p - 30))begin
                pixel_addr_back = 800;
                pixel_addr_hold = 0;
                pixel_addr_square = 105;
                pixel_addr_score = 0;
                pixel_addr_next = (h_cnt - next1_width_1p) % 60 + ((v_cnt + 30 - hold_next_height_2p) % 30) * 60;
                {vgaRed, vgaGreen, vgaBlue} = pixel_next;
            end
            else if((h_cnt < hold1_width_1p + 63) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                case(hold1)
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        if((h_cnt < hold1_width_1p + 45) && (h_cnt >= hold1_width_1p + 15))begin
                            if((v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                                pixel_addr_square = ((h_cnt % 15) + 0) + ((v_cnt % 15) * 120);
                            end
                            else begin
                                pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                            end
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd2:begin
                        if((h_cnt < hold1_width_1p + 45) && (h_cnt >= hold1_width_1p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold1_width_1p + 30) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd3:begin
                        if((h_cnt < hold1_width_1p + 45) && (h_cnt >= hold1_width_1p + 15) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold1_width_1p + 30) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd4:begin
                        if((h_cnt < hold1_width_1p + 30) && (h_cnt >= hold1_width_1p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold1_width_1p + 45) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd5:begin
                        if((h_cnt < hold1_width_1p + 45) && (h_cnt >= hold1_width_1p + 30) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold1_width_1p + 45) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd6:begin
                        if((h_cnt < hold1_width_1p + 15) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold1_width_1p + 45) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd7:begin
                        if((h_cnt < hold1_width_1p + 60) && (h_cnt >= hold1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else if((h_cnt < next1_width_1p + 63) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                case(next_tetris1)
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        if((h_cnt < next1_width_1p + 45) && (h_cnt >= next1_width_1p + 15))begin
                            if((v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                                pixel_addr_square = ((h_cnt % 15) + 0) + ((v_cnt % 15) * 120);
                            end
                            else begin
                                pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                            end
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd2:begin
                        if((h_cnt < next1_width_1p + 45) && (h_cnt >= next1_width_1p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next1_width_1p + 30) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd3:begin
                        if((h_cnt < next1_width_1p + 45) && (h_cnt >= next1_width_1p + 15) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next1_width_1p + 30) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd4:begin
                        if((h_cnt < next1_width_1p + 30) && (h_cnt >= next1_width_1p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next1_width_1p + 45) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd5:begin
                        if((h_cnt < next1_width_1p + 45) && (h_cnt >= next1_width_1p + 30) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next1_width_1p + 45) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd6:begin
                        if((h_cnt < next1_width_1p + 15) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next1_width_1p + 45) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd7:begin
                        if((h_cnt < next1_width_1p + 60) && (h_cnt >= next1_width_1p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else if((h_cnt < square2_width_2p + 152) && (h_cnt >= square2_width_2p) && (v_cnt < hold_next_height_2p + 300 - 30) && (v_cnt >= hold_next_height_2p - 30))begin//2P版面
                case({data2[0], data2[1], data2[2]})
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        pixel_addr_square = (h_cnt % 15) + ((v_cnt % 15) * 120);
                    end
                    3'd2:begin
                        pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                    end
                    3'd3:begin
                        pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                    end
                    3'd4:begin
                        pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                    end
                    3'd5:begin
                        pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                    end
                    3'd6:begin
                        pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                    end
                    3'd7:begin
                        pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else if((h_cnt < score2_width_2p + 60) && (h_cnt >= score2_width_2p) && (v_cnt < score2_height_2p + 30) && (v_cnt >= score2_height_2p))begin
                pixel_addr_score = ((h_cnt - score2_width_2p) % 60) + ((v_cnt - score2_height_2p) % 30) * 60;
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_square = 0;
                {vgaRed, vgaGreen, vgaBlue} = pixel_score;
            end
            else if((h_cnt < number2_width_2p + 123) && (h_cnt >= number2_width_2p) && (v_cnt < number2_height_2p + 30) && (v_cnt >= number2_height_2p))begin
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_hold = 0;
                pixel_addr_square = 0;
                {vgaRed, vgaGreen, vgaBlue} = number2_2p;;
            end
            else if((h_cnt < hold2_width_2p + 63) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 30 - 30) && (v_cnt >= hold_next_height_2p - 30))begin
                pixel_addr_back = 800;
                pixel_addr_next = 0;
                pixel_addr_square = 105;
                pixel_addr_score = 0;
                pixel_addr_hold = (h_cnt - hold2_width_2p) % 60 + ((v_cnt + 30 - hold_next_height_2p) % 30) * 60;
                {vgaRed, vgaGreen, vgaBlue} = pixel_hold;
            end
            else if((h_cnt < next2_width_2p + 63) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 30 - 30) && (v_cnt >= hold_next_height_2p - 30))begin
                pixel_addr_back = 800;
                pixel_addr_hold = 0;
                pixel_addr_square = 105;
                pixel_addr_score = 0;
                pixel_addr_next = (h_cnt - next2_width_2p) % 60 + ((v_cnt + 30 - hold_next_height_2p) % 30) * 60;
                {vgaRed, vgaGreen, vgaBlue} = pixel_next;
            end
            else if((h_cnt < hold2_width_2p + 63) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                case(hold2)
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        if((h_cnt < hold2_width_2p + 45) && (h_cnt >= hold2_width_2p + 15))begin
                            if((v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                                pixel_addr_square = ((h_cnt % 15) + 0) + ((v_cnt % 15) * 120);
                            end
                            else begin
                                pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                            end
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd2:begin
                        if((h_cnt < hold2_width_2p + 45) && (h_cnt >= hold2_width_2p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold2_width_2p + 30) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd3:begin
                        if((h_cnt < hold2_width_2p + 45) && (h_cnt >= hold2_width_2p + 15) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold2_width_2p + 30) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd4:begin
                        if((h_cnt < hold2_width_2p + 30) && (h_cnt >= hold2_width_2p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold2_width_2p + 45) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd5:begin
                        if((h_cnt < hold2_width_2p + 45) && (h_cnt >= hold2_width_2p + 30) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold2_width_2p + 45) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd6:begin
                        if((h_cnt < hold2_width_2p + 15) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < hold2_width_2p + 45) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd7:begin
                        if((h_cnt < hold2_width_2p + 60) && (h_cnt >= hold2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else if((h_cnt < next2_width_2p + 63) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                case(next_tetris2)
                    3'd0:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                    3'd1:begin
                        if((h_cnt < next2_width_2p + 45) && (h_cnt >= next2_width_2p + 15))begin
                            if((v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p))begin
                                pixel_addr_square = ((h_cnt % 15) + 0) + ((v_cnt % 15) * 120);
                            end
                            else begin
                                pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                            end
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd2:begin
                        if((h_cnt < next2_width_2p + 45) && (h_cnt >= next2_width_2p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next2_width_2p + 30) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 15) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd3:begin
                        if((h_cnt < next2_width_2p + 45) && (h_cnt >= next2_width_2p + 15) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next2_width_2p + 30) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 30) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd4:begin
                        if((h_cnt < next2_width_2p + 30) && (h_cnt >= next2_width_2p + 15) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next2_width_2p + 45) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 45) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd5:begin
                        if((h_cnt < next2_width_2p + 45) && (h_cnt >= next2_width_2p + 30) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next2_width_2p + 45) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 60) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd6:begin
                        if((h_cnt < next2_width_2p + 15) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 15) && (v_cnt >= hold_next_height_2p))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else if((h_cnt < next2_width_2p + 45) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 75) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    3'd7:begin
                        if((h_cnt < next2_width_2p + 60) && (h_cnt >= next2_width_2p) && (v_cnt < hold_next_height_2p + 30) && (v_cnt >= hold_next_height_2p + 15))begin
                            pixel_addr_square = ((h_cnt % 15) + 90) + ((v_cnt % 15) * 120);
                        end
                        else begin
                            pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                        end
                    end
                    default:begin
                        pixel_addr_square = ((h_cnt % 15) + 105) + ((v_cnt % 15) * 120);
                    end
                endcase
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = 800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_square;
            end
            else begin
                pixel_addr_square = 105;
                pixel_addr_hold = 0;
                pixel_addr_next = 0;
                pixel_addr_score = 0;
                pixel_addr_back = (h_cnt/2 + v_cnt/2 * 320) % 76800;
                {vgaRed, vgaGreen, vgaBlue} = pixel_back;
            end
        end
        else begin
            pixel_addr_square = 0;
            {vgaRed, vgaGreen, vgaBlue} = 12'h000;
        end
    end
endmodule

