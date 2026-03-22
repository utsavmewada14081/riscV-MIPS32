module tb;
    reg clk1, clk2;
    integer k;

    pipe_MIPS dut(clk1, clk2);

    initial begin
        clk1 = 0; 
        clk2 = 0;
    end

    always #5 clk1 = ~clk1;
    always #5 clk2 = ~clk2;

    initial begin
        for(k = 0; k < 31; k++) begin
            dut.Reg[k] = k;
        end

        dut.Mem[0] = 32'h2801000a; //ADDI R1, R0, 10
        dut.Mem[1] = 32'h28020014; //ADDI R2, R0, 20
        dut.Mem[2] = 32'h28030019; //ADDI R3, R0, 25
        dut.Mem[3] = 32'h0ce77800; //OR R7, R7, R7 
        dut.Mem[4] = 32'h0ce77800; //OR R7, R7, R7
        dut.Mem[5] = 32'h00222000; //ADD R4, R1, R2
        dut.Mem[6] = 32'h0ce77800; //OR R7, R7, R7
        dut.Mem[7] = 32'h00832800; //ADD R5, R4, R3
        dut.Mem[8] = 32'hfc000000; //HLT
        dut.HALTED = 0;
        dut.PC = 0;
        dut.TAKEN_BRANCH = 0;
        #280;
        for(k=0; k<6; k++) begin
            $display("R%1d - %2d", k, dut.Reg[k]);
        end
    end

    initial begin
        $dumpfile("mips.vcd");
        $dumpvars(0, tb);
        #300;
        $finish;
    end
endmodule