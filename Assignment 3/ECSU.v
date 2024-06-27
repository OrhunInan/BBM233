`timescale 1us / 1ps

module ECSU(
    input CLK,
    input RST,
    input thunderstorm,
    input [5:0] wind,
    input [1:0] visibility,
    input signed [7:0] temperature,
    output reg severe_weather,
    output reg emergency_landing_alert,
    output reg [1:0] ECSU_state
);

initial begin
    
    ECSU_state <= 2'b00;
    severe_weather <= 1'b0;
    emergency_landing_alert <= 1'b0;
end

always @(posedge CLK) begin
        
    if (RST == 1'b1) begin 
        
        ECSU_state <= 2'b00;
        severe_weather <= 1'b0;
        emergency_landing_alert <= 1'b0;
    end
    else begin
        
            if (ECSU_state == 2'b00) begin 

                if ( (wind > 10 && wind <= 15) || visibility == 2'b01) begin 

                    ECSU_state <= 2'b01;
                end

                if (thunderstorm == 1'b1 || (wind > 15) || visibility == 2'b11 || temperature > 35 || temperature < -35) begin 

                    ECSU_state <= 2'b10;
                end
            end
            if (ECSU_state == 2'b01) begin 
                
                if (wind <= 10 && visibility == 2'b00) ECSU_state <= 2'b00;

                if (thunderstorm == 1'b1 || (wind > 15) || visibility == 2'b11 || temperature > 35 || temperature < -35) begin 

                    ECSU_state <= 2'b10;
                end
            end
            if (ECSU_state == 2'b10) begin 
                
                if (thunderstorm == 1'b0 && wind <= 10 && visibility == 2'b01 && temperature <= 35 && temperature >= -35) begin 

                    ECSU_state <= 2'b01;
                end

                if (temperature > 40 || temperature <-40 || wind > 20) begin 

                    ECSU_state <= 2'b11;
                end
            end
    end
end

always @(*) begin 

    if (thunderstorm == 1'b1 || wind > 15 || temperature < -35 || temperature > 35 || visibility == 2'b11)
        severe_weather <= 1'b1;
    else if (thunderstorm == 1'b0 && wind <= 10 && visibility == 2'b01 && temperature <= 35 && temperature >= -35) severe_weather <= 1'b0;

    if (temperature > 40 || temperature < -40 || wind > 20) emergency_landing_alert <= 1'b1;
end

endmodule