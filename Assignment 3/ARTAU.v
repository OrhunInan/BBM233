/*`timescale 1us / 1ps

module ARTAU(
    input radar_echo,
    input scan_for_target,
    input [31:0] jet_speed,
    input [31:0] max_safe_distance,
    input RST,
    input CLK,
    output reg radar_pulse_trigger,
    output reg [31:0] distance_to_target,
    output reg threat_detected,
    output reg [1:0] ARTAU_state
);

    integer next_state, assess_cooldown, timer_start, pulse_count, prev_distance;

    always @(posedge CLK) begin
        if (RST) begin

            radar_pulse_trigger <= 0;
            distance_to_target <= 0;
            threat_detected <= 0;
            pulse_count <= 0;
            prev_distance <= 0;
            timer_start <= 0;
            assess_cooldown <= 0;
            ARTAU_state <= 2'b00;
        end 
        
        else begin

            if (next_state >= 0) begin
                ARTAU_state = next_state;
                next_state = -1;
            end

            if (ARTAU_state == 2'b00) begin
                radar_pulse_trigger <= 0;
                distance_to_target <= 0;
                threat_detected <= 0;
                pulse_count <= 0;
                prev_distance <= 0;
                timer_start <= 0;
                assess_cooldown <= 0;
            end 

            if (ARTAU_state == 2'b01) begin end
            
             if (ARTAU_state == 2'b10) begin
                
                if ($time - timer_start > 2000) begin
                    timer_start = 0;
                    ARTAU_state <= 0;
                end
            end 
            
            if (ARTAU_state == 2'b11) begin

                if ($time - assess_cooldown >= 3000) begin

                    assess_cooldown = 0;
                    radar_pulse_trigger <= 0;
                    distance_to_target = 0;
                    threat_detected <= 0;
                    pulse_count <= 0;
                    prev_distance <= 0;
                    timer_start <= 0;
                    assess_cooldown <= 0;
                    ARTAU_state <= 2'b00;
                end
            end
        end
    end

    always @(posedge scan_for_target) begin

        next_state <= 1;
        radar_pulse_trigger <= 1;
        #300;
        radar_pulse_trigger <= 0;
        timer_start = $time;
        next_state <= 2;
    end

    always @(posedge radar_echo) begin

        if ($time - timer_start > 2000) timer_start = 0;
        else begin

            prev_distance <= distance_to_target;
            distance_to_target <= ($time - timer_start) * 150;
            pulse_count = pulse_count + 1;
        end

        if (pulse_count == 2) begin

            if ((distance_to_target + jet_speed * ($time - timer_start)) - prev_distance > 0 && distance_to_target < max_safe_distance)
                threat_detected <= 1;

            next_state = 3;
            assess_cooldown = $time;
        end 
        else if (pulse_count == 1) begin

            next_state <= 1;
            radar_pulse_trigger <= 1;
            #300;
            radar_pulse_trigger <= 0;
            timer_start = $time;
            next_state <= 2;
        end
    end

endmodule*/


`timescale 1us / 1ps

module ARTAU(
    input radar_echo,
    input scan_for_target,
    input [31:0] jet_speed,
    input [31:0] max_safe_distance,
    input RST,
    input CLK,
    output reg radar_pulse_trigger,
    output reg [31:0] distance_to_target,
    output reg threat_detected,
    output reg [1:0] ARTAU_state
);

integer radar_timer_start, last_update_time, pulse_count, prev_distance;

initial begin 

    radar_pulse_trigger <= 1'b0;
    distance_to_target <= 1'b0;
    threat_detected <= 1'b0;
    ARTAU_state <= 2'b00;
    pulse_count <= 0;
    radar_timer_start <= 0;
    prev_distance <= 0;
end

always @(posedge CLK or posedge scan_for_target or posedge radar_echo or posedge RST) begin

    if (RST == 1'b1) begin 
        
        radar_pulse_trigger <= 1'b0;
        distance_to_target <= 1'b0;
        threat_detected <= 1'b0;
        ARTAU_state <= 2'b00;
        pulse_count <= 0;
        radar_timer_start <= 0;
        prev_distance <= 0;
    end
    else begin
        
        if (ARTAU_state == 2'b00) begin
            
            radar_pulse_trigger <= 1'b0;
            distance_to_target <= 1'b0;
            threat_detected <= 1'b0;
            ARTAU_state <= 2'b00;
            pulse_count <= 0;
            radar_timer_start <= 0;
            prev_distance <= 0;

            if(scan_for_target) ARTAU_state <= 2'b01;
        end

        if (ARTAU_state == 2'b01) begin

            radar_pulse_trigger <= 1;
            #300;
            radar_pulse_trigger <= 0;
            ARTAU_state <= 2'b10;
            radar_timer_start <= $time;
        end
        
        if (ARTAU_state == 2'b10) begin
            
            if(($time - radar_timer_start) >= 2000) begin
                pulse_count <= 0;
                ARTAU_state <= 2'b00;
            end
        end
        if (ARTAU_state == 2'b11) begin

            if ($time - last_update_time > 3000) begin 

                radar_pulse_trigger <= 1'b0;
                distance_to_target <= 1'b0;
                threat_detected <= 1'b0;
                ARTAU_state <= 2'b00;
                pulse_count <= 0;
                radar_timer_start <= 0;
                prev_distance <= 0;
            end
        end
    end
end

always @(posedge radar_echo) begin 

    distance_to_target <= ($time - radar_timer_start) * 150;
                
    if (pulse_count == 0) begin

        ARTAU_state <= 2'b01;
        prev_distance <= distance_to_target;
    end
    else begin

        
        if ((distance_to_target + jet_speed * ($time - radar_timer_start)) - prev_distance > 0 && distance_to_target < max_safe_distance) 
            threat_detected <= 1'b1;
        else threat_detected <= 1'b0;

        ARTAU_state <= 2'b11;
        last_update_time <= $time;
    end

    pulse_count <= pulse_count + 1;
end

endmodule
