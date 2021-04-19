`timescale 1ns / 1ps
//==================================================================================================
//  Filename      : fsm_s3.v
//  Created On    : 2021-04-19
//  Version       : V 1.0
//  Author        : Rongye
//  Description   : Three-stage mealy FSM
//  Modification  :
//
//==================================================================================================

module FSM_S3(
    // INPUTS
        Clk,        // posedge active
        rst_n,      // negedge active
        FSM_in,     // posedge active
    // OUTPUTS        
        FSM_out    // status cycle flag
    );
    
    // Number of states = 5,one-hot code with zero idle
    parameter Idle    = 4'b0000; 
    parameter State_1 = 4'b0001; 
    parameter State_2 = 4'b0010; 
    parameter State_3 = 4'b0100; 
    parameter State_4 = 4'b1000; 

    input              Clk;
    input              rst_n;
    input              FSM_in;
    
    output             FSM_out;

    reg                FSM_out;
    reg     [3:0]      State_current;
    reg     [3:0]      State_next;
    // Synchronous timing always module, describing state transition
    always@(posedge Clk or negedge rst_n)
    begin
        if(!rst_n)
            State_current <= Idle;
        else
            State_current <= State_next;
    end
    
    // Combinational logic always module, judging state transition
    always@(State_current or FSM_in)
    begin
        case(State_current)
            Idle:
            begin
                if(FSM_in)// Keep the state unchanged until the input is valid
                    State_next = State_1;
                else
                    State_next = State_current;
            end
            State_1:
            begin
                if(FSM_in)
                    State_next = State_2;
                else
                    State_next = State_current;
            end
            State_2:
            begin
                if(FSM_in)
                    State_next = State_3;
                else
                    State_next = State_current;
            end
            State_3:
            begin
                if(FSM_in)
                    State_next = State_4;
                else
                    State_next = State_current;
            end
            State_4:
            begin
                if(FSM_in)
                    State_next = Idle;
                else
                    State_next = State_current;
            end
            default:State_next = Idle;
        endcase
    end
    
    // next_state output
    always@(posedge Clk or negedge rst_n)
    begin
        if(!rst_n)
            FSM_out <= 1'b0; // reset
        else begin
            case(State_next)
                Idle:
                    if(FSM_in)
                        FSM_out <= 1'b1;// completing a cycle
                    else
                        FSM_out <= 1'b0;                        
                State_1:
                    FSM_out <= 1'b0;   
                State_2:
                    FSM_out <= 1'b0;    
                State_3:
                    FSM_out <= 1'b0;                
                State_4:
                    FSM_out <= 1'b0;                    
                default:
                    FSM_out <= 1'b0;
            endcase
        end
    end
endmodule
