// Función: Unifica los decodificadores y la lógica de saltos del procesador.
module ControlUnit(
	input [6:0] op,
	input [2:0] funct3,
	input funct7, Zero,
	output [2:0] AluControl,
	output PCSrc, MemWrite, AluSrc, RegWrite,
	output [1:0] ImmSrc, ResultSrc
);

wire [1:0] AluOp;
wire Branch;
wire Jump;

Main_Decoder MainDecoder(
	.op(op),
	.RegWrite(RegWrite), 
	.ALUSrc(AluSrc), 
	.MemWrite(MemWrite), 
	.Branch(Branch), 
	.Jump(Jump),
	.ImmSrc(ImmSrc),
	.ResultSrc(ResultSrc), 
	.AluOp(AluOp)
);

Alu_Decoder AluDecoder(
	.AluOp(AluOp),
	.funct3(funct3),
	.funct7(funct7), 
	.Op(op[5]),
	.Instruction(AluControl)
);

BranchComparator BRANCH(
	.Branch(Branch), 
	.Zero(Zero), 
	.Jump(Jump),
	.PCSrc(PCSrc)
);

endmodule
	