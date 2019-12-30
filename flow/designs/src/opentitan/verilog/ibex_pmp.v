module ibex_pmp (
	clk_i,
	rst_ni,
	csr_pmp_cfg_i,
	csr_pmp_addr_i,
	priv_mode_i,
	pmp_req_addr_i,
	pmp_req_type_i,
	pmp_req_err_o
);
	parameter [31:0] PMPGranularity = 0;
	parameter [31:0] PMPNumChan = 2;
	parameter [31:0] PMPNumRegions = 4;
	input wire clk_i;
	input wire rst_ni;
	input wire [((0 >= (PMPNumRegions - 1)) ? ((((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions) * 6) + (((PMPNumRegions - 1) * 6) - 1)) : (((((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions)) * 6) + -1)):((0 >= (PMPNumRegions - 1)) ? ((PMPNumRegions - 1) * 6) : 0)] csr_pmp_cfg_i;
	input wire [((0 >= (PMPNumRegions - 1)) ? ((((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions) * 34) + (((PMPNumRegions - 1) * 34) - 1)) : (((((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions)) * 34) + -1)):((0 >= (PMPNumRegions - 1)) ? ((PMPNumRegions - 1) * 34) : 0)] csr_pmp_addr_i;
	input wire [((0 >= (PMPNumChan - 1)) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * 2) + (((PMPNumChan - 1) * 2) - 1)) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * 2) + -1)):((0 >= (PMPNumChan - 1)) ? ((PMPNumChan - 1) * 2) : 0)] priv_mode_i;
	input wire [((0 >= (PMPNumChan - 1)) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * 34) + (((PMPNumChan - 1) * 34) - 1)) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * 34) + -1)):((0 >= (PMPNumChan - 1)) ? ((PMPNumChan - 1) * 34) : 0)] pmp_req_addr_i;
	input wire [((0 >= (PMPNumChan - 1)) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * 2) + (((PMPNumChan - 1) * 2) - 1)) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * 2) + -1)):((0 >= (PMPNumChan - 1)) ? ((PMPNumChan - 1) * 2) : 0)] pmp_req_type_i;
	output wire [0:(PMPNumChan - 1)] pmp_req_err_o;
	parameter [31:0] PMP_MAX_REGIONS = 16;
	parameter [31:0] PMP_CFG_W = 8;
	parameter [31:0] PMP_I = 0;
	parameter [31:0] PMP_D = 1;
	parameter [11:0] CSR_OFF_PMP_CFG = 12'h3A0;
	parameter [11:0] CSR_OFF_PMP_ADDR = 12'h3B0;
	parameter [11:0] CSR_OFF_MCOUNTER_SETUP = 12'h320;
	parameter [11:0] CSR_OFF_MCOUNTER = 12'hB00;
	parameter [11:0] CSR_OFF_MCOUNTERH = 12'hB80;
	parameter [11:0] CSR_MASK_MCOUNTER = 12'hFE0;
	parameter [31:0] CSR_MSTATUS_MIE_BIT = 3;
	parameter [31:0] CSR_MSTATUS_MPIE_BIT = 7;
	parameter [31:0] CSR_MSTATUS_MPP_BIT_LOW = 11;
	parameter [31:0] CSR_MSTATUS_MPP_BIT_HIGH = 12;
	parameter [31:0] CSR_MSTATUS_MPRV_BIT = 17;
	parameter [31:0] CSR_MSTATUS_TW_BIT = 21;
	parameter [31:0] CSR_MSIX_BIT = 3;
	parameter [31:0] CSR_MTIX_BIT = 7;
	parameter [31:0] CSR_MEIX_BIT = 11;
	parameter [31:0] CSR_MFIX_BIT_LOW = 16;
	parameter [31:0] CSR_MFIX_BIT_HIGH = 30;
	localparam [0:0] IMM_A_Z = 0;
	localparam [0:0] OP_B_REG_B = 0;
	localparam [1:0] CSR_OP_READ = 0;
	localparam [1:0] EXC_PC_EXC = 0;
	localparam [1:0] MD_OP_MULL = 0;
	localparam [1:0] OP_A_REG_A = 0;
	localparam [1:0] RF_WD_LSU = 0;
	localparam [2:0] IMM_B_I = 0;
	localparam [2:0] PC_BOOT = 0;
	localparam [4:0] ALU_ADD = 0;
	localparam [0:0] IMM_A_ZERO = 1;
	localparam [0:0] OP_B_IMM = 1;
	localparam [1:0] CSR_OP_WRITE = 1;
	localparam [1:0] EXC_PC_IRQ = 1;
	localparam [1:0] MD_OP_MULH = 1;
	localparam [1:0] OP_A_FWD = 1;
	localparam [1:0] RF_WD_EX = 1;
	localparam [2:0] IMM_B_S = 1;
	localparam [2:0] PC_JUMP = 1;
	localparam [4:0] ALU_SUB = 1;
	localparam [4:0] ALU_LE = 10;
	localparam [4:0] ALU_LEU = 11;
	localparam [4:0] ALU_GT = 12;
	localparam [11:0] CSR_MSTATUS = 12'h300;
	localparam [11:0] CSR_MISA = 12'h301;
	localparam [11:0] CSR_MIE = 12'h304;
	localparam [11:0] CSR_MTVEC = 12'h305;
	localparam [11:0] CSR_MCOUNTINHIBIT = 12'h320;
	localparam [11:0] CSR_MSCRATCH = 12'h340;
	localparam [11:0] CSR_MEPC = 12'h341;
	localparam [11:0] CSR_MCAUSE = 12'h342;
	localparam [11:0] CSR_MTVAL = 12'h343;
	localparam [11:0] CSR_MIP = 12'h344;
	localparam [11:0] CSR_PMPCFG0 = 12'h3A0;
	localparam [11:0] CSR_PMPCFG1 = 12'h3A1;
	localparam [11:0] CSR_PMPCFG2 = 12'h3A2;
	localparam [11:0] CSR_PMPCFG3 = 12'h3A3;
	localparam [11:0] CSR_PMPADDR0 = 12'h3B0;
	localparam [11:0] CSR_PMPADDR1 = 12'h3B1;
	localparam [11:0] CSR_PMPADDR2 = 12'h3B2;
	localparam [11:0] CSR_PMPADDR3 = 12'h3B3;
	localparam [11:0] CSR_PMPADDR4 = 12'h3B4;
	localparam [11:0] CSR_PMPADDR5 = 12'h3B5;
	localparam [11:0] CSR_PMPADDR6 = 12'h3B6;
	localparam [11:0] CSR_PMPADDR7 = 12'h3B7;
	localparam [11:0] CSR_PMPADDR8 = 12'h3B8;
	localparam [11:0] CSR_PMPADDR9 = 12'h3B9;
	localparam [11:0] CSR_PMPADDR10 = 12'h3BA;
	localparam [11:0] CSR_PMPADDR11 = 12'h3BB;
	localparam [11:0] CSR_PMPADDR12 = 12'h3BC;
	localparam [11:0] CSR_PMPADDR13 = 12'h3BD;
	localparam [11:0] CSR_PMPADDR14 = 12'h3BE;
	localparam [11:0] CSR_PMPADDR15 = 12'h3BF;
	localparam [11:0] CSR_DCSR = 12'h7b0;
	localparam [11:0] CSR_DPC = 12'h7b1;
	localparam [11:0] CSR_DSCRATCH0 = 12'h7b2;
	localparam [11:0] CSR_DSCRATCH1 = 12'h7b3;
	localparam [11:0] CSR_MCYCLE = 12'hB00;
	localparam [11:0] CSR_MINSTRET = 12'hB02;
	localparam [11:0] CSR_MCYCLEH = 12'hB80;
	localparam [11:0] CSR_MINSTRETH = 12'hB82;
	localparam [11:0] CSR_MHARTID = 12'hF14;
	localparam [4:0] ALU_GTU = 13;
	localparam [4:0] ALU_GE = 14;
	localparam [4:0] ALU_GEU = 15;
	localparam [4:0] ALU_EQ = 16;
	localparam [4:0] ALU_NE = 17;
	localparam [4:0] ALU_SLT = 18;
	localparam [4:0] ALU_SLTU = 19;
	localparam [1:0] CSR_OP_SET = 2;
	localparam [1:0] EXC_PC_DBD = 2;
	localparam [1:0] MD_OP_DIV = 2;
	localparam [1:0] OP_A_CURRPC = 2;
	localparam [1:0] RF_WD_CSR = 2;
	localparam [2:0] IMM_B_B = 2;
	localparam [2:0] PC_EXC = 2;
	localparam [4:0] ALU_XOR = 2;
	localparam [1:0] PMP_ACC_EXEC = 2'b00;
	localparam [1:0] PMP_MODE_OFF = 2'b00;
	localparam [1:0] PRIV_LVL_U = 2'b00;
	localparam [1:0] PMP_ACC_WRITE = 2'b01;
	localparam [1:0] PMP_MODE_TOR = 2'b01;
	localparam [1:0] PRIV_LVL_S = 2'b01;
	localparam [1:0] PMP_ACC_READ = 2'b10;
	localparam [1:0] PMP_MODE_NA4 = 2'b10;
	localparam [1:0] PRIV_LVL_H = 2'b10;
	localparam [1:0] PMP_MODE_NAPOT = 2'b11;
	localparam [1:0] PRIV_LVL_M = 2'b11;
	localparam [4:0] ALU_SLET = 20;
	localparam [4:0] ALU_SLETU = 21;
	localparam [1:0] CSR_OP_CLEAR = 3;
	localparam [1:0] EXC_PC_DBG_EXC = 3;
	localparam [1:0] MD_OP_REM = 3;
	localparam [1:0] OP_A_IMM = 3;
	localparam [2:0] IMM_B_U = 3;
	localparam [2:0] PC_ERET = 3;
	localparam [4:0] ALU_OR = 3;
	localparam [2:0] DBG_CAUSE_NONE = 3'h0;
	localparam [2:0] DBG_CAUSE_EBREAK = 3'h1;
	localparam [2:0] DBG_CAUSE_TRIGGER = 3'h2;
	localparam [2:0] DBG_CAUSE_HALTREQ = 3'h3;
	localparam [2:0] DBG_CAUSE_STEP = 3'h4;
	localparam [2:0] IMM_B_J = 4;
	localparam [2:0] PC_DRET = 4;
	localparam [4:0] ALU_AND = 4;
	localparam [3:0] XDEBUGVER_NO = 4'd0;
	localparam [3:0] XDEBUGVER_NONSTD = 4'd15;
	localparam [3:0] XDEBUGVER_STD = 4'd4;
	localparam [2:0] IMM_B_INCR_PC = 5;
	localparam [4:0] ALU_SRA = 5;
	localparam [2:0] IMM_B_INCR_ADDR = 6;
	localparam [4:0] ALU_SRL = 6;
	localparam [4:0] ALU_SLL = 7;
	localparam [6:0] OPCODE_LOAD = 7'h03;
	localparam [6:0] OPCODE_MISC_MEM = 7'h0f;
	localparam [6:0] OPCODE_OP_IMM = 7'h13;
	localparam [6:0] OPCODE_AUIPC = 7'h17;
	localparam [6:0] OPCODE_STORE = 7'h23;
	localparam [6:0] OPCODE_OP = 7'h33;
	localparam [6:0] OPCODE_LUI = 7'h37;
	localparam [6:0] OPCODE_BRANCH = 7'h63;
	localparam [6:0] OPCODE_JALR = 7'h67;
	localparam [6:0] OPCODE_JAL = 7'h6f;
	localparam [6:0] OPCODE_SYSTEM = 7'h73;
	localparam [4:0] ALU_LT = 8;
	localparam [4:0] ALU_LTU = 9;
	localparam [5:0] EXC_CAUSE_INSN_ADDR_MISA = {1'b0, 5'd00};
	localparam [5:0] EXC_CAUSE_INSTR_ACCESS_FAULT = {1'b0, 5'd01};
	localparam [5:0] EXC_CAUSE_ILLEGAL_INSN = {1'b0, 5'd02};
	localparam [5:0] EXC_CAUSE_BREAKPOINT = {1'b0, 5'd03};
	localparam [5:0] EXC_CAUSE_LOAD_ACCESS_FAULT = {1'b0, 5'd05};
	localparam [5:0] EXC_CAUSE_STORE_ACCESS_FAULT = {1'b0, 5'd07};
	localparam [5:0] EXC_CAUSE_ECALL_UMODE = {1'b0, 5'd08};
	localparam [5:0] EXC_CAUSE_ECALL_MMODE = {1'b0, 5'd11};
	localparam [5:0] EXC_CAUSE_IRQ_SOFTWARE_M = {1'b1, 5'd03};
	localparam [5:0] EXC_CAUSE_IRQ_TIMER_M = {1'b1, 5'd07};
	localparam [5:0] EXC_CAUSE_IRQ_EXTERNAL_M = {1'b1, 5'd11};
	localparam [5:0] EXC_CAUSE_IRQ_NM = {1'b1, 5'd31};
	wire [33:0] region_start_addr [0:(PMPNumRegions - 1)];
	wire [33:(PMPGranularity + 2)] region_addr_mask [0:(PMPNumRegions - 1)];
	wire [(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + -1) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + ((PMPNumRegions - 1) - 1))) : (((PMPNumRegions - 1) >= 0) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) - 1)) : ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + (((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions))) - 1)))):(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) : (((PMPNumRegions - 1) >= 0) ? ((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) : ((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)))))] region_match_high;
	wire [(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + -1) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + ((PMPNumRegions - 1) - 1))) : (((PMPNumRegions - 1) >= 0) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) - 1)) : ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + (((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions))) - 1)))):(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) : (((PMPNumRegions - 1) >= 0) ? ((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) : ((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)))))] region_match_low;
	wire [(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + -1) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + ((PMPNumRegions - 1) - 1))) : (((PMPNumRegions - 1) >= 0) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) - 1)) : ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + (((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions))) - 1)))):(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) : (((PMPNumRegions - 1) >= 0) ? ((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) : ((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)))))] region_match_both;
	wire [(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + -1) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + ((PMPNumRegions - 1) - 1))) : (((PMPNumRegions - 1) >= 0) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) - 1)) : ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + (((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions))) - 1)))):(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) : (((PMPNumRegions - 1) >= 0) ? ((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) : ((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)))))] region_perm_check;
	wire [(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + -1) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + ((PMPNumRegions - 1) - 1))) : (((PMPNumRegions - 1) >= 0) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) - 1)) : ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + (((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions))) - 1)))):(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) : (((PMPNumRegions - 1) >= 0) ? ((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) : ((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)))))] machine_access_fault;
	wire [(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + -1) : (((((PMPNumChan - 1) >= 0) ? PMPNumChan : (2 - PMPNumChan)) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + ((PMPNumRegions - 1) - 1))) : (((PMPNumRegions - 1) >= 0) ? ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) - 1)) : ((((0 >= (PMPNumChan - 1)) ? (2 - PMPNumChan) : PMPNumChan) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)) + (((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions))) - 1)))):(((PMPNumChan - 1) >= 0) ? (((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) : (((PMPNumRegions - 1) >= 0) ? ((PMPNumChan - 1) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) : ((PMPNumRegions - 1) + ((PMPNumChan - 1) * ((0 >= (PMPNumRegions - 1)) ? (2 - PMPNumRegions) : PMPNumRegions)))))] user_access_allowed;
	wire [(PMPNumChan - 1):0] access_fault;
	generate
		genvar g_addr_exp_r;
		for (g_addr_exp_r = 0; (g_addr_exp_r < PMPNumRegions); g_addr_exp_r = (g_addr_exp_r + 1)) begin : g_addr_exp
			if ((g_addr_exp_r == 0)) begin : g_entry0
				assign region_start_addr[g_addr_exp_r] = ((csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_addr_exp_r : ((PMPNumRegions - 1) - g_addr_exp_r)) * 6) + 3)+:2] == PMP_MODE_TOR) ? 34'h000000000 : csr_pmp_addr_i[(((0 >= (PMPNumRegions - 1)) ? g_addr_exp_r : ((PMPNumRegions - 1) - g_addr_exp_r)) * 34)+:34]);
			end
			else begin : g_oth
				assign region_start_addr[g_addr_exp_r] = ((csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_addr_exp_r : ((PMPNumRegions - 1) - g_addr_exp_r)) * 6) + 3)+:2] == PMP_MODE_TOR) ? csr_pmp_addr_i[(((0 >= (PMPNumRegions - 1)) ? (g_addr_exp_r - 1) : ((PMPNumRegions - 1) - (g_addr_exp_r - 1))) * 34)+:34] : csr_pmp_addr_i[(((0 >= (PMPNumRegions - 1)) ? g_addr_exp_r : ((PMPNumRegions - 1) - g_addr_exp_r)) * 34)+:34]);
			end
			genvar g_bitmask_b;
			for (g_bitmask_b = (PMPGranularity + 2); (g_bitmask_b < 34); g_bitmask_b = (g_bitmask_b + 1)) begin : g_bitmask
				if ((g_bitmask_b == (PMPGranularity + 2))) begin : g_bit0
					assign region_addr_mask[g_addr_exp_r][g_bitmask_b] = (csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_addr_exp_r : ((PMPNumRegions - 1) - g_addr_exp_r)) * 6) + 3)+:2] != PMP_MODE_NAPOT);
				end
				else begin : g_others
					assign region_addr_mask[g_addr_exp_r][g_bitmask_b] = ((csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_addr_exp_r : ((PMPNumRegions - 1) - g_addr_exp_r)) * 6) + 3)+:2] != PMP_MODE_NAPOT) | ~&csr_pmp_addr_i[((((0 >= (PMPNumRegions - 1)) ? g_addr_exp_r : ((PMPNumRegions - 1) - g_addr_exp_r)) * 34) + (PMPGranularity + 2))+:(((g_bitmask_b - 1) >= (PMPGranularity + 2)) ? (((g_bitmask_b - 1) - (PMPGranularity + 2)) + 1) : (((PMPGranularity + 2) - (g_bitmask_b - 1)) + 1))]);
				end
			end
		end
	endgenerate
	generate
		genvar g_access_check_c;
		for (g_access_check_c = 0; (g_access_check_c < PMPNumChan); g_access_check_c = (g_access_check_c + 1)) begin : g_access_check
			genvar g_regions_r;
			for (g_regions_r = 0; (g_regions_r < PMPNumRegions); g_regions_r = (g_regions_r + 1)) begin : g_regions
				assign region_match_low[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] = (pmp_req_addr_i[((((0 >= (PMPNumChan - 1)) ? g_access_check_c : ((PMPNumChan - 1) - g_access_check_c)) * 34) + (PMPGranularity + 2))+:((33 >= (PMPGranularity + 2)) ? (34 - (PMPGranularity + 2)) : (((PMPGranularity + 2) - 33) + 1))] >= (region_start_addr[g_regions_r][33:(PMPGranularity + 2)] & region_addr_mask[g_regions_r]));
				assign region_match_high[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] = (pmp_req_addr_i[((((0 >= (PMPNumChan - 1)) ? g_access_check_c : ((PMPNumChan - 1) - g_access_check_c)) * 34) + (PMPGranularity + 2))+:((33 >= (PMPGranularity + 2)) ? (34 - (PMPGranularity + 2)) : (((PMPGranularity + 2) - 33) + 1))] <= csr_pmp_addr_i[((((0 >= (PMPNumRegions - 1)) ? g_regions_r : ((PMPNumRegions - 1) - g_regions_r)) * 34) + (PMPGranularity + 2))+:((33 >= (PMPGranularity + 2)) ? (34 - (PMPGranularity + 2)) : (((PMPGranularity + 2) - 33) + 1))]);
				assign region_match_both[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] = ((region_match_low[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] & region_match_high[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))]) & (csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_regions_r : ((PMPNumRegions - 1) - g_regions_r)) * 6) + 3)+:2] != PMP_MODE_OFF));
				assign region_perm_check[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] = ((((pmp_req_type_i[(((0 >= (PMPNumChan - 1)) ? g_access_check_c : ((PMPNumChan - 1) - g_access_check_c)) * 2)+:2] == PMP_ACC_EXEC) & csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_regions_r : ((PMPNumRegions - 1) - g_regions_r)) * 6) + 2)+:1]) | ((pmp_req_type_i[(((0 >= (PMPNumChan - 1)) ? g_access_check_c : ((PMPNumChan - 1) - g_access_check_c)) * 2)+:2] == PMP_ACC_WRITE) & csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_regions_r : ((PMPNumRegions - 1) - g_regions_r)) * 6) + 1)+:1])) | ((pmp_req_type_i[(((0 >= (PMPNumChan - 1)) ? g_access_check_c : ((PMPNumChan - 1) - g_access_check_c)) * 2)+:2] == PMP_ACC_READ) & csr_pmp_cfg_i[(((0 >= (PMPNumRegions - 1)) ? g_regions_r : ((PMPNumRegions - 1) - g_regions_r)) * 6)+:1]));
				assign machine_access_fault[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] = ((region_match_both[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] & csr_pmp_cfg_i[((((0 >= (PMPNumRegions - 1)) ? g_regions_r : ((PMPNumRegions - 1) - g_regions_r)) * 6) + 5)+:1]) & ~region_perm_check[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))]);
				assign user_access_allowed[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] = (region_match_both[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))] & region_perm_check[(((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))) + (((PMPNumRegions - 1) >= 0) ? g_regions_r : (0 - (g_regions_r - (PMPNumRegions - 1)))))]);
			end
			assign access_fault[g_access_check_c] = ((priv_mode_i[(((0 >= (PMPNumChan - 1)) ? g_access_check_c : ((PMPNumChan - 1) - g_access_check_c)) * 2)+:2] == PRIV_LVL_M) ? |machine_access_fault[((((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) + ((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))))+:(((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))] : ~|user_access_allowed[((((PMPNumRegions - 1) >= 0) ? 0 : (PMPNumRegions - 1)) + ((((PMPNumChan - 1) >= 0) ? g_access_check_c : (0 - (g_access_check_c - (PMPNumChan - 1)))) * (((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))))+:(((PMPNumRegions - 1) >= 0) ? PMPNumRegions : (2 - PMPNumRegions))]);
			assign pmp_req_err_o[g_access_check_c] = access_fault[g_access_check_c];
		end
	endgenerate
endmodule
