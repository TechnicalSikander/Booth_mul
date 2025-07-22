`timescale 1ns / 1ps

module booth_mul_tb;

    // Inputs
    reg [7:0] a, b;

    // Output
    wire [15:0] m;

    // Instantiate the Unit Under Test (UUT)
    booth_mul uut (
        .a(a),
        .b(b),
        .m(m)
    );

    // Helper task to print signed/unsigned values
    task display_result;
        input [7:0] a_in, b_in;
        input [15:0] m_out;
        begin
            $display("Time=%0t | a=%0d (%b), b=%0d (%b), Product=%0d (%b)", 
                      $time, $signed(a_in), a_in, $signed(b_in), b_in, $signed(m_out), m_out);
        end
    endtask

    initial begin
        // Initialize
        $display("Booth 8x8 Multiplier Test");
        $monitor("Time=%0t | a=%0d, b=%0d, m=%0d", $time, $signed(a), $signed(b), $signed(m));
        
        // Test vectors
        a = -8'd73; b = -8'd115; #10; display_result(a, b, m);
        a = 8'd1; b = 8'd1; #10; display_result(a, b, m);
        a = 8'd3; b = 8'd2; #10; display_result(a, b, m);
        a = -8'd3; b = 8'd2; #10; display_result(a, b, m);
        a = 8'd3; b = -8'd2; #10; display_result(a, b, m);
        a = -8'd3; b = -8'd2; #10; display_result(a, b, m);
        a = 8'd127; b = 8'd1; #10; display_result(a, b, m);
        a = 8'd127; b = -8'd1; #10; display_result(a, b, m);
        a = -8'd128; b = 8'd1; #10; display_result(a, b, m);
        a = 8'd12; b = 8'd10; #10; display_result(a, b, m);
        a = -8'd12; b = 8'd10; #10; display_result(a, b, m);
        a = 8'd12; b = -8'd10; #10; display_result(a, b, m);
        a = -8'd12; b = -8'd10; #10; display_result(a, b, m);

        $finish;
    end

endmodule
