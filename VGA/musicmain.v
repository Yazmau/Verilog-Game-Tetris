// *******************************
// lab_SPEAKER_TOP
//
// ********************************

module musicmain (
	input clk,
	input reset,
	input [1:0] mode,
	input [8:0] score1,
	input [8:0] score2,
	output pmod_1,
	output pmod_2,
	output pmod_4
);
reg [31:0] BEAT_FREQ;	//one beat=0.125sec
wire [8:0] score;
assign score = (score1 >= score2) ? score1 : score2;//2P用
always@(*)begin//根據消除行數決定節奏
    case(mode)
        2'b00:begin//start scene
            BEAT_FREQ = 32'd6;
        end
        2'b01:begin//1P
            if(score1 < 30'd3)begin
                BEAT_FREQ = 32'd6;
            end
            else if(score1 < 30'd6)begin
                BEAT_FREQ = 32'd8;
            end
            else if(score1 < 30'd9)begin
                BEAT_FREQ = 32'd10;
            end
            else if(score1 < 30'd12)begin
                BEAT_FREQ = 32'd12;
            end
            else if(score1 < 30'd15)begin
                BEAT_FREQ = 32'd14;
            end
            else if(score1 >= 30'd15)begin
                BEAT_FREQ = 32'd16;
            end
            else begin
                BEAT_FREQ = 32'd6;
            end
        end
        2'b10:begin//2P
            if(score < 30'd3)begin
                BEAT_FREQ = 32'd6;
            end
            else if(score < 30'd6)begin
                BEAT_FREQ = 32'd8;
            end
            else if(score < 30'd9)begin
                BEAT_FREQ = 32'd10;
            end
            else if(score < 30'd12)begin
                BEAT_FREQ = 32'd12;
            end
            else if(score < 30'd15)begin
                BEAT_FREQ = 32'd14;
            end
            else if(score >= 30'd15)begin
                BEAT_FREQ = 32'd16;
            end
            else begin
                BEAT_FREQ = 32'd6;
            end
        end
        default:begin
            BEAT_FREQ = 32'd8;
        end
    endcase
end
parameter DUTY_BEST = 10'd512;	//duty cycle=50%

wire [31:0] freq;
wire [7:0] ibeatNum;
wire beatFreq;

assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on

//Generate beat speed
PWM_gen btSpeedGen ( .clk(clk), 
					 .reset(reset),
					 .freq(BEAT_FREQ),
					 .duty(DUTY_BEST), 
					 .PWM(beatFreq)
);
	
//manipulate beat
PlayerCtrl playerCtrl_00 ( .clk(beatFreq),
						   .reset(reset),
						   .ibeat(ibeatNum)
);	
	
//Generate variant freq. of tones
Music music00 ( .ibeatNum(ibeatNum),
				.tone(freq)
);

// Generate particular freq. signal
PWM_gen toneGen ( .clk(clk), 
				  .reset(reset), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);
endmodule
