`timescale 1ns/1ps

// Simple single-cycle RISC-V processor.
// Supported instructions:
// R-type: add, sub, and, or
// I-type: addi, lw
// S-type: sw
// B-type: beq

module processor(
    input clk,
    input reset
);
    reg [31:0] pc;
    reg [31:0] instr_mem [0:63];
    reg [31:0] data_mem  [0:63];
    reg [31:0] regs      [0:31];

    wire [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;

    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] alu_op;
    wire mem_write;
    wire alu_src;
    wire reg_write;

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] imm;
    wire [3:0] alu_control_signal;
    wire [31:0] alu_input2;
    wire [31:0] alu_result;
    wire zero;
    wire [31:0] mem_read_data;
    wire [31:0] write_data;

    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire pc_src;
    wire [31:0] next_pc;

    integer i;

    assign instruction = instr_mem[pc[7:2]];

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    control_unit control(
        .opcode(opcode),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    imm_gen immediate_generator(
        .instruction(instruction),
        .imm(imm)
    );

    alu_control alu_ctrl(
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control_signal(alu_control_signal)
    );

    assign read_data1 = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign read_data2 = (rs2 == 0) ? 32'b0 : regs[rs2];

    assign alu_input2 = alu_src ? imm : read_data2;

    alu main_alu(
        .a(read_data1),
        .b(alu_input2),
        .alu_control_signal(alu_control_signal),
        .result(alu_result),
        .zero(zero)
    );

    assign mem_read_data = data_mem[alu_result[7:2]];
    assign write_data = mem_to_reg ? mem_read_data : alu_result;

    assign pc_plus_4 = pc + 4;
    assign branch_target = pc + imm;
    assign pc_src = branch & zero;
    assign next_pc = pc_src ? branch_target : pc_plus_4;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 0;
            for (i = 0; i < 64; i = i + 1)
                data_mem[i] <= 0;
        end else begin
            pc <= next_pc;

            if (mem_write)
                data_mem[alu_result[7:2]] <= read_data2;

            if (reg_write && rd != 0)
                regs[rd] <= write_data;
        end
    end
endmodule

module control_unit(
    input [6:0] opcode,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write
);
    always @(*) begin
        branch = 0;
        mem_read = 0;
        mem_to_reg = 0;
        alu_op = 2'b00;
        mem_write = 0;
        alu_src = 0;
        reg_write = 0;

        case (opcode)
            7'b0110011: begin // R-type
                alu_op = 2'b10;
                reg_write = 1;
            end
            7'b0010011: begin // addi
                alu_op = 2'b00;
                alu_src = 1;
                reg_write = 1;
            end
            7'b0000011: begin // lw
                mem_read = 1;
                mem_to_reg = 1;
                alu_src = 1;
                reg_write = 1;
            end
            7'b0100011: begin // sw
                alu_src = 1;
                mem_write = 1;
            end
            7'b1100011: begin // beq
                branch = 1;
                alu_op = 2'b01;
            end
        endcase
    end
endmodule

module imm_gen(
    input [31:0] instruction,
    output reg [31:0] imm
);
    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0010011,
            7'b0000011:
                imm = {{20{instruction[31]}}, instruction[31:20]};

            7'b0100011:
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            7'b1100011:
                imm = {{19{instruction[31]}}, instruction[31], instruction[7],
                       instruction[30:25], instruction[11:8], 1'b0};

            default:
                imm = 32'b0;
        endcase
    end
endmodule

module alu_control(
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_control_signal
);
    always @(*) begin
        case (alu_op)
            2'b00:
                alu_control_signal = 4'b0010; // add for lw, sw, addi
            2'b01:
                alu_control_signal = 4'b0110; // subtract for beq
            2'b10: begin
                case ({funct7, funct3})
                    10'b0000000_000: alu_control_signal = 4'b0010; // add
                    10'b0100000_000: alu_control_signal = 4'b0110; // sub
                    10'b0000000_111: alu_control_signal = 4'b0000; // and
                    10'b0000000_110: alu_control_signal = 4'b0001; // or
                    default:         alu_control_signal = 4'b0010;
                endcase
            end
            default:
                alu_control_signal = 4'b0010;
        endcase
    end
endmodule

module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_control_signal,
    output reg [31:0] result,
    output zero
);
    always @(*) begin
        case (alu_control_signal)
            4'b0000: result = a & b;
            4'b0001: result = a | b;
            4'b0010: result = a + b;
            4'b0110: result = a - b;
            default: result = 0;
        endcase
    end

    assign zero = (result == 0);
endmodule
