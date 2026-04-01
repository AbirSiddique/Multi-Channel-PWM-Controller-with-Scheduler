`timescale 1ns / 1ps
 
module topmodule(
    input wire CLK100MHZ,     
    input wire CPU_RESETN, 
    output wire [3:0] LED      
);

    wire [7:0] vio_duty0;
    wire [7:0] vio_duty1;
    wire [7:0] vio_duty2;
    wire [7:0] vio_duty3;

    vio_0 u_vio (
        .clk(CLK100MHZ),
        .probe_out0(vio_duty0),
        .probe_out1(vio_duty1),
        .probe_out2(vio_duty2),
        .probe_out3(vio_duty3)
    );

    pwmcontroller u_pwm (
        .clk(CLK100MHZ),
        .reset(CPU_RESETN),
        .DUTY0(vio_duty0),
        .DUTY1(vio_duty1),
        .DUTY2(vio_duty2),
        .DUTY3(vio_duty3),
        .led0(LED[0]),
        .led1(LED[1]),
        .led2(LED[2]),
        .led3(LED[3])
    );
 
endmodule