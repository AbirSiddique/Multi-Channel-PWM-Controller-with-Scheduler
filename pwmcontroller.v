`timescale 1ns / 1ps
module pwmcontroller (
    input  wire        clk,       
    input  wire        reset,   
    input  wire [7:0]  DUTY0,
    input  wire [7:0]  DUTY1,
    input  wire [7:0]  DUTY2,
    input  wire [7:0]  DUTY3,
    output reg         led0,
    output reg         led1,
    output reg         led2,
    output reg         led3
);
    localparam integer CLK_FREQ   = 100_000_000;
    localparam integer ON_TIME_MS = 3000;
    localparam integer DEAD_MS    = 3000;
    localparam integer ON_CNT   = (CLK_FREQ/1000) * ON_TIME_MS;
    localparam integer DEAD_CNT = (CLK_FREQ/1000) * DEAD_MS;

    reg [7:0] pwm_ramp;
    always @(posedge clk) begin
        if (reset)
            pwm_ramp <= 8'd0;
        else
            pwm_ramp <= pwm_ramp + 1'b1;
    end

    localparam [2:0]
        S_LED0  = 3'd0,
        S_DEAD0 = 3'd1,
        S_LED1  = 3'd2,
        S_DEAD1 = 3'd3,
        S_LED2  = 3'd4,
        S_DEAD2 = 3'd5,
        S_LED3  = 3'd6,
        S_DEAD3 = 3'd7;
 
    reg [2:0] state;
    reg [31:0] slot_cnt;
    always @(posedge clk) begin
        if (reset) begin
            state    <= S_LED0;
            slot_cnt <= 32'd0;
        end else begin
            slot_cnt <= slot_cnt + 1'b1;
            case (state)
                S_LED0, S_LED1, S_LED2, S_LED3: begin
                    if (slot_cnt >= ON_CNT-1) begin
                        state    <= state + 1'b1;
                        slot_cnt <= 32'd0;
                    end
                end
                S_DEAD0, S_DEAD1, S_DEAD2, S_DEAD3: begin
                    if (slot_cnt >= DEAD_CNT-1) begin
                        if (state == S_DEAD3)
                            state <= S_LED0;
                        else
                            state <= state + 1'b1;
                        slot_cnt <= 32'd0;
                    end
                end
                default: begin
                    state    <= S_LED0;
                    slot_cnt <= 32'd0;
                end
            endcase
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            led0 <= 1'b0;
            led1 <= 1'b0;
            led2 <= 1'b0;
            led3 <= 1'b0;
        end 
        else begin
            led0 <= 1'b0;
            led1 <= 1'b0;
            led2 <= 1'b0;
            led3 <= 1'b0;
            case (state)
                S_LED0: led0 <= (pwm_ramp < DUTY0);
                S_LED1: led1 <= (pwm_ramp < DUTY1);
                S_LED2: led2 <= (pwm_ramp < DUTY2);
                S_LED3: led3 <= (pwm_ramp < DUTY3);
                default: ; 
            endcase
        end
    end
endmodule