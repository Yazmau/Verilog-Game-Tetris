module top(
   input clk,
   input rst,
   input up,
   input down,
   input left,
   input right,
   inout wire PS2_DATA,
   inout wire PS2_CLK,
   output pmod_1,
   output pmod_2,
   output pmod_4,
   output [3:0] vgaRed,
   output [3:0] vgaGreen,
   output [3:0] vgaBlue,
   output hsync,
   output vsync
    );
    wire clk_25MHz, clk_22;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );
    //state of scene
    wire [1:0] state_scene;
    wire btn1, btn2;
    wire [2:0] data1, data2, nextdata;
    wire [2:0] next_tetris1, next_tetris2;
    wire [8:0] score1, score2;
    wire [2:0] hold1, hold2;
    scene s1(.clk(clk), .rst(rst), .start1(down), .start2(up), .state(state_scene), .btn1(btn1), .btn2(btn2));
    //state of scene
   pixel_gen pixel_gen_inst(
       .h_cnt(h_cnt),
       .valid(valid),
       .v_cnt(v_cnt),
       .data1(data1),
       .data2(data2),
       .state_scene(state_scene),
       .clk(clk),
       .clk_25MHz(clk_25MHz),
       .rst(rst),
       .btn1(btn1),
       .btn2(btn2),
       .next_tetris1(next_tetris1),
       .hold1(hold1),
       .next_tetris2(next_tetris2),
       .hold2(hold2),
       .score1(score1),
       .score2(score2),
       .vgaRed(vgaRed),
       .vgaGreen(vgaGreen),
       .vgaBlue(vgaBlue)
    );
    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
    //keyboard for player
    wire up_1p, down_1p, right_1p, left_1p, space_1p, hold_1p;
    assign up_1p = key_down[9'b0_0100_0011];
    assign down_1p = key_down[9'b0_0100_0010];
    assign left_1p = key_down[9'b0_0011_1011];
    assign right_1p = key_down[9'b0_0100_1011];
    assign space_1p = key_down[9'b0_0011_0100];
    assign hold_1p = key_down[9'b0_0011_0011];
    wire up_2p, down_2p, right_2p, left_2p, space_2p, hold_2p;
    assign up_2p = key_down[9'b0_0111_0011];
    assign down_2p = key_down[9'b0_0111_0010];
    assign left_2p = key_down[9'b0_0110_1001];
    assign right_2p = key_down[9'b0_0111_1010];
    assign space_2p = key_down[9'b0_0111_0000];
    assign hold_2p = key_down[9'b0_0111_0100];
    //keyboard for player
    reg [9:0] squarwidth1, squarheight1, squarwidth2, squarheight2;
    GameEngine g1(.clk(clk_25MHz), .reset(down || up), .left_move_button(left_1p), .right_move_button(right_1p), .spin_button(up_1p), .direct_down_button(space_1p), .hold_button(hold_1p), .print_i((v_cnt - squarheight1) / 15), .print_j((h_cnt - squarwidth1) / 15), .print_data(data1), .next_tetris(next_tetris1), .score(score1), .hold_piece_type(hold1));
    GameEngine g2(.clk(clk_25MHz), .reset(up), .left_move_button(left_2p), .right_move_button(right_2p), .spin_button(up_2p), .direct_down_button(space_2p), .hold_button(hold_2p), .print_i((v_cnt - squarheight2) / 15), .print_j((h_cnt - squarwidth2) / 15), .print_data(data2), .next_tetris(next_tetris2), .score(score2), .hold_piece_type(hold2));
    //1P OR 2P
    always@(*)begin
        if(state_scene == 2'b01)begin
            squarwidth1 = 10'd240;
            squarheight1 = 10'd120;
        end
        else if(state_scene == 2'b10)begin
            squarwidth1 = 10'd90;
            squarheight1 = 10'd120;
            squarwidth2 = 10'd405;
            squarheight2 = 10'd120;
        end
    end
    //1P OR 2P
    musicmain music1(
 .clk(clk),
 .reset(rst),
 .mode(state_scene), .score1(score1), .score2(score2), .pmod_1(pmod_1),
 .pmod_2(pmod_2),
 .pmod_4(pmod_4)
);
endmodule
module scene(clk, rst, start1, start2, state, btn1, btn2);
    input clk, rst, start1, start2;
    output reg [1:0] state;
    output reg btn1, btn2;
    reg [1:0] nextstate;
    reg [29:0] cnt, nextcnt;
    reg nextbtn1;
    reg nextbtn2;
    always@(posedge clk)begin
        if(rst)begin
            state <= 2'b00;
            cnt <= 30'd0;
            btn1 <= 0;
            btn2 <= 0;
        end
        else begin
            state <= nextstate;
            cnt <= nextcnt;
            btn1 <= nextbtn1;
            btn2 <= nextbtn2;
        end
    end
    always@(*)begin
        if(start1 == 1'b1)begin
            nextcnt = 30'd0;
            nextstate = state;
            nextbtn1 = 1'b1;
            nextbtn2 = btn2;
        end
        else if(start2 == 1'b1)begin
            nextcnt = 30'd0;
            nextstate = state;
            nextbtn1 = btn1;
            nextbtn2 = 1'b1;
        end
        else begin
            if((cnt >= 30'd100000000) && (btn1 == 1'b1))begin
                nextstate = 2'b01;
                nextcnt = 30'd0;
                nextbtn1 = 1'b0;
                nextbtn2 = btn2;
            end
            else if((cnt >= 30'd100000000) && (btn2 == 1'b1))begin
                nextstate = 2'b10;
                nextcnt = 30'd0;
                nextbtn2 = 1'b0;
                nextbtn1 = btn1;
            end
            else begin
                nextstate = state;
                nextcnt = cnt + 1;
                nextbtn1 = btn1;
                nextbtn2 = btn2;
            end
        end
    end
endmodule
