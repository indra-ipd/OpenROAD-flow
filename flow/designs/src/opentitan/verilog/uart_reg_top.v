module uart_reg_top (
	clk_i,
	rst_ni,
	tl_i,
	tl_o,
	reg2hw,
	hw2reg,
	devmode_i
);
	localparam top_pkg_TL_AW = 32;
	localparam top_pkg_TL_DW = 32;
	localparam top_pkg_TL_AIW = 8;
	localparam top_pkg_TL_DIW = 1;
	localparam top_pkg_TL_DUW = 16;
	localparam top_pkg_TL_DBW = (top_pkg_TL_DW >> 3);
	localparam top_pkg_TL_SZW = $clog2(($clog2((32 >> 3)) + 1));
	input clk_i;
	input rst_ni;
	input wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_AW) + (((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW))) + top_pkg_TL_DW) + 17) - 1):0] tl_i;
	output wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_DIW) + top_pkg_TL_DW) + top_pkg_TL_DUW) + 2) - 1):0] tl_o;
	output wire [124:0] reg2hw;
	input wire [64:0] hw2reg;
	input devmode_i;
	parameter UART_INTR_STATE_OFFSET = 6'h 0;
	parameter UART_INTR_ENABLE_OFFSET = 6'h 4;
	parameter UART_INTR_TEST_OFFSET = 6'h 8;
	parameter UART_CTRL_OFFSET = 6'h c;
	parameter UART_STATUS_OFFSET = 6'h 10;
	parameter UART_RDATA_OFFSET = 6'h 14;
	parameter UART_WDATA_OFFSET = 6'h 18;
	parameter UART_FIFO_CTRL_OFFSET = 6'h 1c;
	parameter UART_FIFO_STATUS_OFFSET = 6'h 20;
	parameter UART_OVRD_OFFSET = 6'h 24;
	parameter UART_VAL_OFFSET = 6'h 28;
	parameter UART_TIMEOUT_CTRL_OFFSET = 6'h 2c;
	localparam [47:0] UART_PERMIT = {4'b 0001, 4'b 0001, 4'b 0001, 4'b 1111, 4'b 0001, 4'b 0001, 4'b 0001, 4'b 0001, 4'b 0111, 4'b 0001, 4'b 0011, 4'b 1111};
	localparam UART_INTR_STATE = 0;
	localparam UART_INTR_ENABLE = 1;
	localparam UART_VAL = 10;
	localparam UART_TIMEOUT_CTRL = 11;
	localparam UART_INTR_TEST = 2;
	localparam UART_CTRL = 3;
	localparam UART_STATUS = 4;
	localparam UART_RDATA = 5;
	localparam UART_WDATA = 6;
	localparam UART_FIFO_CTRL = 7;
	localparam UART_FIFO_STATUS = 8;
	localparam UART_OVRD = 9;
	localparam AW = 6;
	localparam DW = 32;
	localparam DBW = (DW / 8);
	wire reg_we;
	wire reg_re;
	wire [(AW - 1):0] reg_addr;
	wire [(DW - 1):0] reg_wdata;
	wire [(DBW - 1):0] reg_be;
	wire [(DW - 1):0] reg_rdata;
	wire reg_error;
	wire addrmiss;
	reg wr_err;
	reg [(DW - 1):0] reg_rdata_next;
	wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_AW) + (((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW))) + top_pkg_TL_DW) + 17) - 1):0] tl_reg_h2d;
	wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_DIW) + top_pkg_TL_DW) + top_pkg_TL_DUW) + 2) - 1):0] tl_reg_d2h;
	assign tl_reg_h2d = tl_i;
	assign tl_o = tl_reg_d2h;
	tlul_adapter_reg #(
		.RegAw(AW),
		.RegDw(DW)
	) u_reg_if(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.tl_i(tl_reg_h2d),
		.tl_o(tl_reg_d2h),
		.we_o(reg_we),
		.re_o(reg_re),
		.addr_o(reg_addr),
		.wdata_o(reg_wdata),
		.be_o(reg_be),
		.rdata_i(reg_rdata),
		.error_i(reg_error)
	);
	assign reg_rdata = reg_rdata_next;
	assign reg_error = ((devmode_i & addrmiss) | wr_err);
	wire intr_state_tx_watermark_qs;
	wire intr_state_tx_watermark_wd;
	wire intr_state_tx_watermark_we;
	wire intr_state_rx_watermark_qs;
	wire intr_state_rx_watermark_wd;
	wire intr_state_rx_watermark_we;
	wire intr_state_tx_overflow_qs;
	wire intr_state_tx_overflow_wd;
	wire intr_state_tx_overflow_we;
	wire intr_state_rx_overflow_qs;
	wire intr_state_rx_overflow_wd;
	wire intr_state_rx_overflow_we;
	wire intr_state_rx_frame_err_qs;
	wire intr_state_rx_frame_err_wd;
	wire intr_state_rx_frame_err_we;
	wire intr_state_rx_break_err_qs;
	wire intr_state_rx_break_err_wd;
	wire intr_state_rx_break_err_we;
	wire intr_state_rx_timeout_qs;
	wire intr_state_rx_timeout_wd;
	wire intr_state_rx_timeout_we;
	wire intr_state_rx_parity_err_qs;
	wire intr_state_rx_parity_err_wd;
	wire intr_state_rx_parity_err_we;
	wire intr_enable_tx_watermark_qs;
	wire intr_enable_tx_watermark_wd;
	wire intr_enable_tx_watermark_we;
	wire intr_enable_rx_watermark_qs;
	wire intr_enable_rx_watermark_wd;
	wire intr_enable_rx_watermark_we;
	wire intr_enable_tx_overflow_qs;
	wire intr_enable_tx_overflow_wd;
	wire intr_enable_tx_overflow_we;
	wire intr_enable_rx_overflow_qs;
	wire intr_enable_rx_overflow_wd;
	wire intr_enable_rx_overflow_we;
	wire intr_enable_rx_frame_err_qs;
	wire intr_enable_rx_frame_err_wd;
	wire intr_enable_rx_frame_err_we;
	wire intr_enable_rx_break_err_qs;
	wire intr_enable_rx_break_err_wd;
	wire intr_enable_rx_break_err_we;
	wire intr_enable_rx_timeout_qs;
	wire intr_enable_rx_timeout_wd;
	wire intr_enable_rx_timeout_we;
	wire intr_enable_rx_parity_err_qs;
	wire intr_enable_rx_parity_err_wd;
	wire intr_enable_rx_parity_err_we;
	wire intr_test_tx_watermark_wd;
	wire intr_test_tx_watermark_we;
	wire intr_test_rx_watermark_wd;
	wire intr_test_rx_watermark_we;
	wire intr_test_tx_overflow_wd;
	wire intr_test_tx_overflow_we;
	wire intr_test_rx_overflow_wd;
	wire intr_test_rx_overflow_we;
	wire intr_test_rx_frame_err_wd;
	wire intr_test_rx_frame_err_we;
	wire intr_test_rx_break_err_wd;
	wire intr_test_rx_break_err_we;
	wire intr_test_rx_timeout_wd;
	wire intr_test_rx_timeout_we;
	wire intr_test_rx_parity_err_wd;
	wire intr_test_rx_parity_err_we;
	wire ctrl_tx_qs;
	wire ctrl_tx_wd;
	wire ctrl_tx_we;
	wire ctrl_rx_qs;
	wire ctrl_rx_wd;
	wire ctrl_rx_we;
	wire ctrl_nf_qs;
	wire ctrl_nf_wd;
	wire ctrl_nf_we;
	wire ctrl_slpbk_qs;
	wire ctrl_slpbk_wd;
	wire ctrl_slpbk_we;
	wire ctrl_llpbk_qs;
	wire ctrl_llpbk_wd;
	wire ctrl_llpbk_we;
	wire ctrl_parity_en_qs;
	wire ctrl_parity_en_wd;
	wire ctrl_parity_en_we;
	wire ctrl_parity_odd_qs;
	wire ctrl_parity_odd_wd;
	wire ctrl_parity_odd_we;
	wire [1:0] ctrl_rxblvl_qs;
	wire [1:0] ctrl_rxblvl_wd;
	wire ctrl_rxblvl_we;
	wire [15:0] ctrl_nco_qs;
	wire [15:0] ctrl_nco_wd;
	wire ctrl_nco_we;
	wire status_txfull_qs;
	wire status_txfull_re;
	wire status_rxfull_qs;
	wire status_rxfull_re;
	wire status_txempty_qs;
	wire status_txempty_re;
	wire status_txidle_qs;
	wire status_txidle_re;
	wire status_rxidle_qs;
	wire status_rxidle_re;
	wire status_rxempty_qs;
	wire status_rxempty_re;
	wire [7:0] rdata_qs;
	wire rdata_re;
	wire [7:0] wdata_wd;
	wire wdata_we;
	wire fifo_ctrl_rxrst_wd;
	wire fifo_ctrl_rxrst_we;
	wire fifo_ctrl_txrst_wd;
	wire fifo_ctrl_txrst_we;
	wire [2:0] fifo_ctrl_rxilvl_qs;
	wire [2:0] fifo_ctrl_rxilvl_wd;
	wire fifo_ctrl_rxilvl_we;
	wire [1:0] fifo_ctrl_txilvl_qs;
	wire [1:0] fifo_ctrl_txilvl_wd;
	wire fifo_ctrl_txilvl_we;
	wire [5:0] fifo_status_txlvl_qs;
	wire fifo_status_txlvl_re;
	wire [5:0] fifo_status_rxlvl_qs;
	wire fifo_status_rxlvl_re;
	wire ovrd_txen_qs;
	wire ovrd_txen_wd;
	wire ovrd_txen_we;
	wire ovrd_txval_qs;
	wire ovrd_txval_wd;
	wire ovrd_txval_we;
	wire [15:0] val_qs;
	wire val_re;
	wire [23:0] timeout_ctrl_val_qs;
	wire [23:0] timeout_ctrl_val_wd;
	wire timeout_ctrl_val_we;
	wire timeout_ctrl_en_qs;
	wire timeout_ctrl_en_wd;
	wire timeout_ctrl_en_we;
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_tx_watermark(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_tx_watermark_we),
		.wd(intr_state_tx_watermark_wd),
		.de(hw2reg[63:63]),
		.d(hw2reg[64:64]),
		.qe(),
		.q(reg2hw[124:124]),
		.qs(intr_state_tx_watermark_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_rx_watermark(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_rx_watermark_we),
		.wd(intr_state_rx_watermark_wd),
		.de(hw2reg[61:61]),
		.d(hw2reg[62:62]),
		.qe(),
		.q(reg2hw[123:123]),
		.qs(intr_state_rx_watermark_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_tx_overflow(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_tx_overflow_we),
		.wd(intr_state_tx_overflow_wd),
		.de(hw2reg[59:59]),
		.d(hw2reg[60:60]),
		.qe(),
		.q(reg2hw[122:122]),
		.qs(intr_state_tx_overflow_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_rx_overflow(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_rx_overflow_we),
		.wd(intr_state_rx_overflow_wd),
		.de(hw2reg[57:57]),
		.d(hw2reg[58:58]),
		.qe(),
		.q(reg2hw[121:121]),
		.qs(intr_state_rx_overflow_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_rx_frame_err(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_rx_frame_err_we),
		.wd(intr_state_rx_frame_err_wd),
		.de(hw2reg[55:55]),
		.d(hw2reg[56:56]),
		.qe(),
		.q(reg2hw[120:120]),
		.qs(intr_state_rx_frame_err_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_rx_break_err(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_rx_break_err_we),
		.wd(intr_state_rx_break_err_wd),
		.de(hw2reg[53:53]),
		.d(hw2reg[54:54]),
		.qe(),
		.q(reg2hw[119:119]),
		.qs(intr_state_rx_break_err_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_rx_timeout(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_rx_timeout_we),
		.wd(intr_state_rx_timeout_wd),
		.de(hw2reg[51:51]),
		.d(hw2reg[52:52]),
		.qe(),
		.q(reg2hw[118:118]),
		.qs(intr_state_rx_timeout_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("W1C"),
		.RESVAL(1'h0)
	) u_intr_state_rx_parity_err(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_state_rx_parity_err_we),
		.wd(intr_state_rx_parity_err_wd),
		.de(hw2reg[49:49]),
		.d(hw2reg[50:50]),
		.qe(),
		.q(reg2hw[117:117]),
		.qs(intr_state_rx_parity_err_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_tx_watermark(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_tx_watermark_we),
		.wd(intr_enable_tx_watermark_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[116:116]),
		.qs(intr_enable_tx_watermark_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_rx_watermark(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_rx_watermark_we),
		.wd(intr_enable_rx_watermark_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[115:115]),
		.qs(intr_enable_rx_watermark_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_tx_overflow(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_tx_overflow_we),
		.wd(intr_enable_tx_overflow_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[114:114]),
		.qs(intr_enable_tx_overflow_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_rx_overflow(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_rx_overflow_we),
		.wd(intr_enable_rx_overflow_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[113:113]),
		.qs(intr_enable_rx_overflow_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_rx_frame_err(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_rx_frame_err_we),
		.wd(intr_enable_rx_frame_err_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[112:112]),
		.qs(intr_enable_rx_frame_err_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_rx_break_err(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_rx_break_err_we),
		.wd(intr_enable_rx_break_err_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[111:111]),
		.qs(intr_enable_rx_break_err_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_rx_timeout(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_rx_timeout_we),
		.wd(intr_enable_rx_timeout_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[110:110]),
		.qs(intr_enable_rx_timeout_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_intr_enable_rx_parity_err(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(intr_enable_rx_parity_err_we),
		.wd(intr_enable_rx_parity_err_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[109:109]),
		.qs(intr_enable_rx_parity_err_qs)
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_tx_watermark(
		.re(1'b0),
		.we(intr_test_tx_watermark_we),
		.wd(intr_test_tx_watermark_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[107:107]),
		.q(reg2hw[108:108]),
		.qs()
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_rx_watermark(
		.re(1'b0),
		.we(intr_test_rx_watermark_we),
		.wd(intr_test_rx_watermark_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[105:105]),
		.q(reg2hw[106:106]),
		.qs()
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_tx_overflow(
		.re(1'b0),
		.we(intr_test_tx_overflow_we),
		.wd(intr_test_tx_overflow_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[103:103]),
		.q(reg2hw[104:104]),
		.qs()
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_rx_overflow(
		.re(1'b0),
		.we(intr_test_rx_overflow_we),
		.wd(intr_test_rx_overflow_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[101:101]),
		.q(reg2hw[102:102]),
		.qs()
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_rx_frame_err(
		.re(1'b0),
		.we(intr_test_rx_frame_err_we),
		.wd(intr_test_rx_frame_err_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[99:99]),
		.q(reg2hw[100:100]),
		.qs()
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_rx_break_err(
		.re(1'b0),
		.we(intr_test_rx_break_err_we),
		.wd(intr_test_rx_break_err_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[97:97]),
		.q(reg2hw[98:98]),
		.qs()
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_rx_timeout(
		.re(1'b0),
		.we(intr_test_rx_timeout_we),
		.wd(intr_test_rx_timeout_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[95:95]),
		.q(reg2hw[96:96]),
		.qs()
	);
	prim_subreg_ext #(.DW(1)) u_intr_test_rx_parity_err(
		.re(1'b0),
		.we(intr_test_rx_parity_err_we),
		.wd(intr_test_rx_parity_err_wd),
		.d(1'sb0),
		.qre(),
		.qe(reg2hw[93:93]),
		.q(reg2hw[94:94]),
		.qs()
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ctrl_tx(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_tx_we),
		.wd(ctrl_tx_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[92:92]),
		.qs(ctrl_tx_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ctrl_rx(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_rx_we),
		.wd(ctrl_rx_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[91:91]),
		.qs(ctrl_rx_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ctrl_nf(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_nf_we),
		.wd(ctrl_nf_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[90:90]),
		.qs(ctrl_nf_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ctrl_slpbk(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_slpbk_we),
		.wd(ctrl_slpbk_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[89:89]),
		.qs(ctrl_slpbk_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ctrl_llpbk(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_llpbk_we),
		.wd(ctrl_llpbk_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[88:88]),
		.qs(ctrl_llpbk_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ctrl_parity_en(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_parity_en_we),
		.wd(ctrl_parity_en_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[87:87]),
		.qs(ctrl_parity_en_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ctrl_parity_odd(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_parity_odd_we),
		.wd(ctrl_parity_odd_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[86:86]),
		.qs(ctrl_parity_odd_qs)
	);
	prim_subreg #(
		.DW(2),
		.SWACCESS("RW"),
		.RESVAL(2'h0)
	) u_ctrl_rxblvl(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_rxblvl_we),
		.wd(ctrl_rxblvl_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[85:84]),
		.qs(ctrl_rxblvl_qs)
	);
	prim_subreg #(
		.DW(16),
		.SWACCESS("RW"),
		.RESVAL(16'h0)
	) u_ctrl_nco(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ctrl_nco_we),
		.wd(ctrl_nco_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[83:68]),
		.qs(ctrl_nco_qs)
	);
	prim_subreg_ext #(.DW(1)) u_status_txfull(
		.re(status_txfull_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[48:48]),
		.qre(reg2hw[66:66]),
		.qe(),
		.q(reg2hw[67:67]),
		.qs(status_txfull_qs)
	);
	prim_subreg_ext #(.DW(1)) u_status_rxfull(
		.re(status_rxfull_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[47:47]),
		.qre(reg2hw[64:64]),
		.qe(),
		.q(reg2hw[65:65]),
		.qs(status_rxfull_qs)
	);
	prim_subreg_ext #(.DW(1)) u_status_txempty(
		.re(status_txempty_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[46:46]),
		.qre(reg2hw[62:62]),
		.qe(),
		.q(reg2hw[63:63]),
		.qs(status_txempty_qs)
	);
	prim_subreg_ext #(.DW(1)) u_status_txidle(
		.re(status_txidle_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[45:45]),
		.qre(reg2hw[60:60]),
		.qe(),
		.q(reg2hw[61:61]),
		.qs(status_txidle_qs)
	);
	prim_subreg_ext #(.DW(1)) u_status_rxidle(
		.re(status_rxidle_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[44:44]),
		.qre(reg2hw[58:58]),
		.qe(),
		.q(reg2hw[59:59]),
		.qs(status_rxidle_qs)
	);
	prim_subreg_ext #(.DW(1)) u_status_rxempty(
		.re(status_rxempty_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[43:43]),
		.qre(reg2hw[56:56]),
		.qe(),
		.q(reg2hw[57:57]),
		.qs(status_rxempty_qs)
	);
	prim_subreg_ext #(.DW(8)) u_rdata(
		.re(rdata_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[42:35]),
		.qre(reg2hw[47:47]),
		.qe(),
		.q(reg2hw[55:48]),
		.qs(rdata_qs)
	);
	prim_subreg #(
		.DW(8),
		.SWACCESS("WO"),
		.RESVAL(8'h0)
	) u_wdata(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(wdata_we),
		.wd(wdata_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(reg2hw[38:38]),
		.q(reg2hw[46:39]),
		.qs()
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("WO"),
		.RESVAL(1'h0)
	) u_fifo_ctrl_rxrst(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(fifo_ctrl_rxrst_we),
		.wd(fifo_ctrl_rxrst_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(reg2hw[36:36]),
		.q(reg2hw[37:37]),
		.qs()
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("WO"),
		.RESVAL(1'h0)
	) u_fifo_ctrl_txrst(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(fifo_ctrl_txrst_we),
		.wd(fifo_ctrl_txrst_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(reg2hw[34:34]),
		.q(reg2hw[35:35]),
		.qs()
	);
	prim_subreg #(
		.DW(3),
		.SWACCESS("RW"),
		.RESVAL(3'h0)
	) u_fifo_ctrl_rxilvl(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(fifo_ctrl_rxilvl_we),
		.wd(fifo_ctrl_rxilvl_wd),
		.de(hw2reg[31:31]),
		.d(hw2reg[34:32]),
		.qe(reg2hw[30:30]),
		.q(reg2hw[33:31]),
		.qs(fifo_ctrl_rxilvl_qs)
	);
	prim_subreg #(
		.DW(2),
		.SWACCESS("RW"),
		.RESVAL(2'h0)
	) u_fifo_ctrl_txilvl(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(fifo_ctrl_txilvl_we),
		.wd(fifo_ctrl_txilvl_wd),
		.de(hw2reg[28:28]),
		.d(hw2reg[30:29]),
		.qe(reg2hw[27:27]),
		.q(reg2hw[29:28]),
		.qs(fifo_ctrl_txilvl_qs)
	);
	prim_subreg_ext #(.DW(6)) u_fifo_status_txlvl(
		.re(fifo_status_txlvl_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[27:22]),
		.qre(),
		.qe(),
		.q(),
		.qs(fifo_status_txlvl_qs)
	);
	prim_subreg_ext #(.DW(6)) u_fifo_status_rxlvl(
		.re(fifo_status_rxlvl_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[21:16]),
		.qre(),
		.qe(),
		.q(),
		.qs(fifo_status_rxlvl_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ovrd_txen(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ovrd_txen_we),
		.wd(ovrd_txen_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[26:26]),
		.qs(ovrd_txen_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_ovrd_txval(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(ovrd_txval_we),
		.wd(ovrd_txval_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[25:25]),
		.qs(ovrd_txval_qs)
	);
	prim_subreg_ext #(.DW(16)) u_val(
		.re(val_re),
		.we(1'b0),
		.wd(1'sb0),
		.d(hw2reg[15:0]),
		.qre(),
		.qe(),
		.q(),
		.qs(val_qs)
	);
	prim_subreg #(
		.DW(24),
		.SWACCESS("RW"),
		.RESVAL(24'h0)
	) u_timeout_ctrl_val(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(timeout_ctrl_val_we),
		.wd(timeout_ctrl_val_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[24:1]),
		.qs(timeout_ctrl_val_qs)
	);
	prim_subreg #(
		.DW(1),
		.SWACCESS("RW"),
		.RESVAL(1'h0)
	) u_timeout_ctrl_en(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.we(timeout_ctrl_en_we),
		.wd(timeout_ctrl_en_wd),
		.de(1'b0),
		.d(1'sb0),
		.qe(),
		.q(reg2hw[0:0]),
		.qs(timeout_ctrl_en_qs)
	);
	reg [11:0] addr_hit;
	always @(*) begin
		addr_hit = 1'sb0;
		addr_hit[0] = (reg_addr == UART_INTR_STATE_OFFSET);
		addr_hit[1] = (reg_addr == UART_INTR_ENABLE_OFFSET);
		addr_hit[2] = (reg_addr == UART_INTR_TEST_OFFSET);
		addr_hit[3] = (reg_addr == UART_CTRL_OFFSET);
		addr_hit[4] = (reg_addr == UART_STATUS_OFFSET);
		addr_hit[5] = (reg_addr == UART_RDATA_OFFSET);
		addr_hit[6] = (reg_addr == UART_WDATA_OFFSET);
		addr_hit[7] = (reg_addr == UART_FIFO_CTRL_OFFSET);
		addr_hit[8] = (reg_addr == UART_FIFO_STATUS_OFFSET);
		addr_hit[9] = (reg_addr == UART_OVRD_OFFSET);
		addr_hit[10] = (reg_addr == UART_VAL_OFFSET);
		addr_hit[11] = (reg_addr == UART_TIMEOUT_CTRL_OFFSET);
	end
	assign addrmiss = ((reg_re || reg_we) ? ~|addr_hit : 1'b0);
	always @(*) begin
		wr_err = 1'b0;
		if (((addr_hit[0] && reg_we) && (UART_PERMIT[44+:4] != (UART_PERMIT[44+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[1] && reg_we) && (UART_PERMIT[40+:4] != (UART_PERMIT[40+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[2] && reg_we) && (UART_PERMIT[36+:4] != (UART_PERMIT[36+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[3] && reg_we) && (UART_PERMIT[32+:4] != (UART_PERMIT[32+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[4] && reg_we) && (UART_PERMIT[28+:4] != (UART_PERMIT[28+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[5] && reg_we) && (UART_PERMIT[24+:4] != (UART_PERMIT[24+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[6] && reg_we) && (UART_PERMIT[20+:4] != (UART_PERMIT[20+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[7] && reg_we) && (UART_PERMIT[16+:4] != (UART_PERMIT[16+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[8] && reg_we) && (UART_PERMIT[12+:4] != (UART_PERMIT[12+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[9] && reg_we) && (UART_PERMIT[8+:4] != (UART_PERMIT[8+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[10] && reg_we) && (UART_PERMIT[4+:4] != (UART_PERMIT[4+:4] & reg_be))))
			wr_err = 1'b1;
		if (((addr_hit[11] && reg_we) && (UART_PERMIT[0+:4] != (UART_PERMIT[0+:4] & reg_be))))
			wr_err = 1'b1;
	end
	assign intr_state_tx_watermark_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_tx_watermark_wd = reg_wdata[0];
	assign intr_state_rx_watermark_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_rx_watermark_wd = reg_wdata[1];
	assign intr_state_tx_overflow_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_tx_overflow_wd = reg_wdata[2];
	assign intr_state_rx_overflow_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_rx_overflow_wd = reg_wdata[3];
	assign intr_state_rx_frame_err_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_rx_frame_err_wd = reg_wdata[4];
	assign intr_state_rx_break_err_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_rx_break_err_wd = reg_wdata[5];
	assign intr_state_rx_timeout_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_rx_timeout_wd = reg_wdata[6];
	assign intr_state_rx_parity_err_we = ((addr_hit[0] & reg_we) & ~wr_err);
	assign intr_state_rx_parity_err_wd = reg_wdata[7];
	assign intr_enable_tx_watermark_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_tx_watermark_wd = reg_wdata[0];
	assign intr_enable_rx_watermark_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_rx_watermark_wd = reg_wdata[1];
	assign intr_enable_tx_overflow_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_tx_overflow_wd = reg_wdata[2];
	assign intr_enable_rx_overflow_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_rx_overflow_wd = reg_wdata[3];
	assign intr_enable_rx_frame_err_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_rx_frame_err_wd = reg_wdata[4];
	assign intr_enable_rx_break_err_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_rx_break_err_wd = reg_wdata[5];
	assign intr_enable_rx_timeout_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_rx_timeout_wd = reg_wdata[6];
	assign intr_enable_rx_parity_err_we = ((addr_hit[1] & reg_we) & ~wr_err);
	assign intr_enable_rx_parity_err_wd = reg_wdata[7];
	assign intr_test_tx_watermark_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_tx_watermark_wd = reg_wdata[0];
	assign intr_test_rx_watermark_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_rx_watermark_wd = reg_wdata[1];
	assign intr_test_tx_overflow_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_tx_overflow_wd = reg_wdata[2];
	assign intr_test_rx_overflow_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_rx_overflow_wd = reg_wdata[3];
	assign intr_test_rx_frame_err_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_rx_frame_err_wd = reg_wdata[4];
	assign intr_test_rx_break_err_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_rx_break_err_wd = reg_wdata[5];
	assign intr_test_rx_timeout_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_rx_timeout_wd = reg_wdata[6];
	assign intr_test_rx_parity_err_we = ((addr_hit[2] & reg_we) & ~wr_err);
	assign intr_test_rx_parity_err_wd = reg_wdata[7];
	assign ctrl_tx_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_tx_wd = reg_wdata[0];
	assign ctrl_rx_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_rx_wd = reg_wdata[1];
	assign ctrl_nf_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_nf_wd = reg_wdata[2];
	assign ctrl_slpbk_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_slpbk_wd = reg_wdata[4];
	assign ctrl_llpbk_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_llpbk_wd = reg_wdata[5];
	assign ctrl_parity_en_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_parity_en_wd = reg_wdata[6];
	assign ctrl_parity_odd_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_parity_odd_wd = reg_wdata[7];
	assign ctrl_rxblvl_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_rxblvl_wd = reg_wdata[9:8];
	assign ctrl_nco_we = ((addr_hit[3] & reg_we) & ~wr_err);
	assign ctrl_nco_wd = reg_wdata[31:16];
	assign status_txfull_re = (addr_hit[4] && reg_re);
	assign status_rxfull_re = (addr_hit[4] && reg_re);
	assign status_txempty_re = (addr_hit[4] && reg_re);
	assign status_txidle_re = (addr_hit[4] && reg_re);
	assign status_rxidle_re = (addr_hit[4] && reg_re);
	assign status_rxempty_re = (addr_hit[4] && reg_re);
	assign rdata_re = (addr_hit[5] && reg_re);
	assign wdata_we = ((addr_hit[6] & reg_we) & ~wr_err);
	assign wdata_wd = reg_wdata[7:0];
	assign fifo_ctrl_rxrst_we = ((addr_hit[7] & reg_we) & ~wr_err);
	assign fifo_ctrl_rxrst_wd = reg_wdata[0];
	assign fifo_ctrl_txrst_we = ((addr_hit[7] & reg_we) & ~wr_err);
	assign fifo_ctrl_txrst_wd = reg_wdata[1];
	assign fifo_ctrl_rxilvl_we = ((addr_hit[7] & reg_we) & ~wr_err);
	assign fifo_ctrl_rxilvl_wd = reg_wdata[4:2];
	assign fifo_ctrl_txilvl_we = ((addr_hit[7] & reg_we) & ~wr_err);
	assign fifo_ctrl_txilvl_wd = reg_wdata[6:5];
	assign fifo_status_txlvl_re = (addr_hit[8] && reg_re);
	assign fifo_status_rxlvl_re = (addr_hit[8] && reg_re);
	assign ovrd_txen_we = ((addr_hit[9] & reg_we) & ~wr_err);
	assign ovrd_txen_wd = reg_wdata[0];
	assign ovrd_txval_we = ((addr_hit[9] & reg_we) & ~wr_err);
	assign ovrd_txval_wd = reg_wdata[1];
	assign val_re = (addr_hit[10] && reg_re);
	assign timeout_ctrl_val_we = ((addr_hit[11] & reg_we) & ~wr_err);
	assign timeout_ctrl_val_wd = reg_wdata[23:0];
	assign timeout_ctrl_en_we = ((addr_hit[11] & reg_we) & ~wr_err);
	assign timeout_ctrl_en_wd = reg_wdata[31];
	always @(*) begin
		reg_rdata_next = 1'sb0;
		case (1'b1)
			addr_hit[0]: begin
				reg_rdata_next[0] = intr_state_tx_watermark_qs;
				reg_rdata_next[1] = intr_state_rx_watermark_qs;
				reg_rdata_next[2] = intr_state_tx_overflow_qs;
				reg_rdata_next[3] = intr_state_rx_overflow_qs;
				reg_rdata_next[4] = intr_state_rx_frame_err_qs;
				reg_rdata_next[5] = intr_state_rx_break_err_qs;
				reg_rdata_next[6] = intr_state_rx_timeout_qs;
				reg_rdata_next[7] = intr_state_rx_parity_err_qs;
			end
			addr_hit[1]: begin
				reg_rdata_next[0] = intr_enable_tx_watermark_qs;
				reg_rdata_next[1] = intr_enable_rx_watermark_qs;
				reg_rdata_next[2] = intr_enable_tx_overflow_qs;
				reg_rdata_next[3] = intr_enable_rx_overflow_qs;
				reg_rdata_next[4] = intr_enable_rx_frame_err_qs;
				reg_rdata_next[5] = intr_enable_rx_break_err_qs;
				reg_rdata_next[6] = intr_enable_rx_timeout_qs;
				reg_rdata_next[7] = intr_enable_rx_parity_err_qs;
			end
			addr_hit[2]: begin
				reg_rdata_next[0] = 1'sb0;
				reg_rdata_next[1] = 1'sb0;
				reg_rdata_next[2] = 1'sb0;
				reg_rdata_next[3] = 1'sb0;
				reg_rdata_next[4] = 1'sb0;
				reg_rdata_next[5] = 1'sb0;
				reg_rdata_next[6] = 1'sb0;
				reg_rdata_next[7] = 1'sb0;
			end
			addr_hit[3]: begin
				reg_rdata_next[0] = ctrl_tx_qs;
				reg_rdata_next[1] = ctrl_rx_qs;
				reg_rdata_next[2] = ctrl_nf_qs;
				reg_rdata_next[4] = ctrl_slpbk_qs;
				reg_rdata_next[5] = ctrl_llpbk_qs;
				reg_rdata_next[6] = ctrl_parity_en_qs;
				reg_rdata_next[7] = ctrl_parity_odd_qs;
				reg_rdata_next[9:8] = ctrl_rxblvl_qs;
				reg_rdata_next[31:16] = ctrl_nco_qs;
			end
			addr_hit[4]: begin
				reg_rdata_next[0] = status_txfull_qs;
				reg_rdata_next[1] = status_rxfull_qs;
				reg_rdata_next[2] = status_txempty_qs;
				reg_rdata_next[3] = status_txidle_qs;
				reg_rdata_next[4] = status_rxidle_qs;
				reg_rdata_next[5] = status_rxempty_qs;
			end
			addr_hit[5]: reg_rdata_next[7:0] = rdata_qs;
			addr_hit[6]: reg_rdata_next[7:0] = 1'sb0;
			addr_hit[7]: begin
				reg_rdata_next[0] = 1'sb0;
				reg_rdata_next[1] = 1'sb0;
				reg_rdata_next[4:2] = fifo_ctrl_rxilvl_qs;
				reg_rdata_next[6:5] = fifo_ctrl_txilvl_qs;
			end
			addr_hit[8]: begin
				reg_rdata_next[5:0] = fifo_status_txlvl_qs;
				reg_rdata_next[21:16] = fifo_status_rxlvl_qs;
			end
			addr_hit[9]: begin
				reg_rdata_next[0] = ovrd_txen_qs;
				reg_rdata_next[1] = ovrd_txval_qs;
			end
			addr_hit[10]: reg_rdata_next[15:0] = val_qs;
			addr_hit[11]: begin
				reg_rdata_next[23:0] = timeout_ctrl_val_qs;
				reg_rdata_next[31] = timeout_ctrl_en_qs;
			end
			default: reg_rdata_next = 1'sb1;
		endcase
	end
endmodule
