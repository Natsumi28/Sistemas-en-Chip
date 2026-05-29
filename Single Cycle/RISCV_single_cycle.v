// Función: Módulo top que conecta todos los móodulos para formar el procesador RISC-V de single cycle.
module RISCV_single_cycle(
	input clk, rst
);

wire [31:0] PCNext;
wire [31:0] PC;
wire [31:0] RD;
wire [31:0] PCPlus4;
wire [31:0] PCTarget;
wire [31:0] RD1;
wire [31:0] RD2;
wire [2:0] AluControl;
wire PCSrc;
wire MemWrite; 
wire AluSrc;
wire RegWrite;
wire [1:0] ImmSrc;
wire [1:0] ResultSrc;
wire [31:0] ImmExt;
wire [31:0] SrcB;
wire [31:0] Alu_result;
wire Zero;
wire [31:0] ReadData;
wire [31:0] Result;

ProgramCounter Program(
	.clk(clk),
	.rst(rst),
	.PCNext(PCNext),
	.PC(PC)
);

InstructionMemory Instruccion(
	.A(PC),
	.RD(RD)
);

Adder PC_Plus4(
	.PC(PC),
	.variable(32'd4),
	.AdderOut(PCPlus4)
);

Adder PC_Target(
	.PC(PC),
	.variable(ImmExt),
	.AdderOut(PCTarget)
);

Register_File Files(
		.A1(RD[19:15]), 
		.A2(RD[24:20]), 
		.A3(RD[11:7]),
		.WD3(Result),
		.WE3(RegWrite),
		.clk(clk),
		.rst(rst),
		.RD1(RD1), 
		.RD2(RD2)
);

ControlUnit Unit(
	.op(RD[6:0]),
	.funct3(RD[14:12]),
	.funct7(RD[30]), 
	.Zero(Zero),
	.AluControl(AluControl),
	.PCSrc(PCSrc), 
	.MemWrite(MemWrite), 
	.AluSrc(AluSrc), 
	.RegWrite(RegWrite),
	.ImmSrc(ImmSrc), 
	.ResultSrc(ResultSrc)
);

Imm_Extend Extender(
	.ImmSrc(ImmSrc),
	.Instr(RD),
	.ImmExt(ImmExt)
);

Mux PC_Next(
	.A(PCPlus4), 
	.B(PCTarget), 
	.C(32'd0), 
	.D(32'd0),
	.control({1'b0, PCSrc}),
	.OutMux(PCNext)
);

Mux Src_B(
	.A(RD2), 
	.B(ImmExt), 
	.C(32'd0), 
	.D(32'd0),
	.control({1'b0, AluSrc}),
	.OutMux(SrcB)
);

Alu ALU(
	.An(RD1), 
	.Bn(SrcB), 
	.AluControl(AluControl),
	.Alu_result(Alu_result),
	.Zero(Zero)
);

DataMemory Memoria(
	.Alu_result(Alu_result), 
	.WriteData(RD2),
	.MemWrite(MemWrite), 
	.clk(clk),
	.rst(rst),
	.ReadData(ReadData)
);

Mux Res(
	.A(Alu_result), 
	.B(ReadData), 
	.C(PCPlus4), 
	.D(32'd0),
	.control(ResultSrc),
	.OutMux(Result)
);

endmodule