`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
//
// Revision Date: 03/27/2019 11:08 AM
// Module Name: Digital_Clock
// Project Name: Digital Clock
// Target Devices: Basys 3
// Description: Digital Clock for the Basys 3 FPGA
//
// Dependencies:
//      Basys3_Master_Customized.xdc
//      7segVerilog.v
//
// Revision: 1.1
// Additional Comments: Push center button to swap between running mode and set mode. 
//                      When in set time mode
//                         - Push left/right buttons to swap between setting minutes and hours.
//                         - Push up/down buttons to increment and decrement time, respectively 
//
//////////////////////////////////////////////////////////////////////////////////


module Digital_Clock(
    input clk, // FPGA clock signal, 100 MHz
    input IO_BTN_C,IO_BTN_U, IO_BTN_L, IO_BTN_R, IO_BTN_D, // FPGA IO pushbuttons
    output [6:0] IO_SSEG, output [3:0] IO_SSEG_SEL, // FPGA 7-Segment Display
    output [0:0] IO_LED //LED 0 is AM/PM LED
    );
    
    /* Timing parameters */
    reg [31:0] counter = 0;
    //parameter max_counter = 100000; // 100 MHz / 100000 = 1 kHz
    parameter max_counter = 100000000; // 100 MHz / 100000000 = 1 Hz => 1 second per second
    
    /* Data registers */
    reg [5:0] Hours, Minutes, Seconds = 0;
    wire [3:0] Digit_0,Digit_1, Digit_2, Digit_3; 
    reg [0:0] current_bit = 0;      // Currently only minutes and hours
    
    reg AM_PM, Should_Toggle_Time = 0;  // AM = 0/off , PM = 1/on
    assign IO_LED[0] = AM_PM;
    
    /* Seven Segment Display */
    sevseg display(.clk(clk),       // Initialize 7-segment display module
        .binary_input_0(Digit_0),
        .binary_input_1(Digit_1),
        .binary_input_2(Digit_2),
        .binary_input_3(Digit_3),
        .IO_SSEG_SEL(IO_SSEG_SEL),
        .IO_SSEG(IO_SSEG));
    assign Digit_0 = Minutes % 10;  // 1's of minutes
    assign Digit_1 = Minutes / 10;  // 10's of minutes
    assign Digit_2 = Hours % 10;    // 1's of hours
    assign Digit_3 = Hours / 10;    // 10's of hours
    
    /* Modes */
    parameter Hours_And_Minutes = 1'b0; // Clock mode - 12:00AM to 11:59PM
    parameter Set_Clock = 1'b1;         // Set time mode
    reg [0:0] Current_Mode = Set_Clock; //Start in set time mode by default
    
    always @(posedge clk) begin
        case(Current_Mode)
            Hours_And_Minutes: begin // Clock mode - 12:00AM to 11:59PM
                if (IO_BTN_C) begin
                    Current_Mode <= Set_Clock; // Swap modes when you push the center button 
                    // Reset variables to prepare for set time mode 
                    counter <= 0;
                    current_bit <= 0;
                    Seconds <= 0; //currently just sets seconds to 0. I'll work on this after I get setting minutes and hours working.
                end
                
                if (counter < max_counter) begin // time
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    Seconds <= Seconds + 1;
                end                
            end //Hours_And_Minutes
            Set_Clock: begin
                if (IO_BTN_C) begin //Push center button to commit time set and return to Military clock mode
                    Current_Mode <= Hours_And_Minutes;
                end
                //if (counter < max_counter) begin 
                if (counter < (25000000)) begin // Because of insanely high clock speed in debug mode,
                                                      // much slower clock when setting - 4 Hz
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    case (current_bit)
                        1'b0: begin //minutes
                            if (IO_BTN_U) begin // Increment minutes when you push up
                                Minutes <= Minutes + 1;
                            end
                            if (IO_BTN_D) begin // Decrement minutes when you push down
                                if (Minutes > 0) begin
                                    Minutes <= Minutes - 1;
                                end else if (Hours > 1) begin
                                    Hours <= Hours - 1;
                                    Minutes <= 59;
                                end else if (Hours == 1) begin
                                    Hours <= 12;
                                    Minutes <= 59;
                                    //AM_PM <= ~AM_PM;
                                end
                            end
                            if (IO_BTN_L || IO_BTN_R) begin // Push left/right button to swap between hours/minutes
                                current_bit <= 1;
                            end
                        end // end 1'b0
                        1'b1: begin //hours
                            if (IO_BTN_U) begin // Increment hours when you push up
                                Hours <= Hours + 1;
                            end
                            if (IO_BTN_D) begin // Decrement minutes when you push down
                                if (Hours > 1) begin
                                    Hours <= Hours - 1;
                                end else if (Hours == 1) begin
                                    Hours <= 12;
                                    //AM_PM <= ~AM_PM;
                                end
                            end
                            if (IO_BTN_R || IO_BTN_L) begin // Push left/right button to swap between hours/minutes
                                current_bit <= 0;
                            end
                        end // end 1'b1                       
                endcase   // end case (current_bit)            
                end                    
            end // end Set_Clock
        endcase // end case(Current_Mode)
        
        /* AM PM Time Clock Stuff */
        if (Seconds >= 60) begin // After 60 seconds, increment minutes
                Seconds <= 0;
                Minutes <= Minutes + 1;
        end
        if (Minutes >= 60) begin // After 60 minutes, increment hours
                Minutes <= 0;
                Hours <= Hours + 1;
        end
        if (Hours >= 12) begin // After 12 hours, swap between AM and PM
            //if ((Minutes == 0)&&(Seconds == 0))
            if (Hours == 12)
                Should_Toggle_Time <= 1;
            if (Hours >= 13) // 12:59 AM -> 1:00 PM
                Hours <= 1;
        end
        
        if (Should_Toggle_Time) begin
             AM_PM = ~AM_PM;
             Should_Toggle_Time <= 0;
         end
    end //end always @(posedge clk)
endmodule
