module uart_core (
	clk_i,
	rst_ni,
	reg2hw,
	hw2reg,
	rx,
	tx,
	intr_tx_watermark_o,
	intr_rx_watermark_o,
	intr_tx_overflow_o,
	intr_rx_overflow_o,
	intr_rx_frame_err_o,
	intr_rx_break_err_o,
	intr_rx_timeout_o,
	intr_rx_parity_err_o
);
	localparam [0:0] BRK_CHK = 0;
	localparam [0:0] BRK_WAIT = 1;
	input clk_i;
	input rst_ni;
	input wire [124:0] reg2hw;
	output wire [64:0] hw2reg;
	input rx;
	output wire tx;
	output wire intr_tx_watermark_o;
	output wire intr_rx_watermark_o;
	output wire intr_tx_overflow_o;
	output wire intr_rx_overflow_o;
	output wire intr_rx_frame_err_o;
	output wire intr_rx_break_err_o;
	output wire intr_rx_timeout_o;
	output wire intr_rx_parity_err_o;
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
	reg [15:0] rx_val_q;
	wire [7:0] uart_rdata;
	wire tick_baud_x16;
	wire rx_tick_baud;
	wire [5:0] tx_fifo_depth;
	wire [5:0] rx_fifo_depth;
	reg [5:0] rx_fifo_depth_prev_q;
	wire [23:0] rx_timeout_count_d;
	reg [23:0] rx_timeout_count_q;
	wire [23:0] uart_rxto_val;
	wire rx_fifo_depth_changed;
	wire uart_rxto_en;
	wire tx_enable;
	wire rx_enable;
	wire sys_loopback;
	wire line_loopback;
	wire rxnf_enable;
	wire uart_fifo_rxrst;
	wire uart_fifo_txrst;
	wire [2:0] uart_fifo_rxilvl;
	wire [1:0] uart_fifo_txilvl;
	wire ovrd_tx_en;
	wire ovrd_tx_val;
	wire [7:0] tx_fifo_data;
	wire tx_fifo_rready;
	wire tx_fifo_rvalid;
	wire tx_fifo_wready;
	wire tx_uart_idle;
	wire tx_out;
	reg tx_out_q;
	wire [7:0] rx_fifo_data;
	wire rx_valid;
	wire rx_fifo_wvalid;
	wire rx_fifo_rvalid;
	wire rx_fifo_wready;
	wire rx_uart_idle;
	wire rx_sync;
	wire rx_in;
	reg break_err;
	wire [4:0] allzero_cnt_d;
	reg [4:0] allzero_cnt_q;
	wire allzero_err;
	wire not_allzero_char;
	reg event_tx_watermark;
	reg event_rx_watermark;
	wire event_tx_overflow;
	wire event_rx_overflow;
	wire event_rx_frame_err;
	wire event_rx_break_err;
	wire event_rx_timeout;
	wire event_rx_parity_err;
	assign tx_enable = reg2hw[92:92];
	assign rx_enable = reg2hw[91:91];
	assign rxnf_enable = reg2hw[90:90];
	assign sys_loopback = reg2hw[89:89];
	assign line_loopback = reg2hw[88:88];
	assign uart_fifo_rxrst = (reg2hw[37:37] & reg2hw[36:36]);
	assign uart_fifo_txrst = (reg2hw[35:35] & reg2hw[34:34]);
	assign uart_fifo_rxilvl = reg2hw[33:31];
	assign uart_fifo_txilvl = reg2hw[29:28];
	assign ovrd_tx_en = reg2hw[26:26];
	assign ovrd_tx_val = reg2hw[25:25];
	reg [0:0] break_st_q;
	assign not_allzero_char = (rx_valid & (~event_rx_frame_err | (rx_fifo_data != 8'h0)));
	assign allzero_err = (event_rx_frame_err & (rx_fifo_data == 8'h0));
	assign allzero_cnt_d = (((break_st_q == BRK_WAIT) || not_allzero_char) ? 5'h0 : (allzero_err ? (allzero_cnt_q + 5'd1) : allzero_cnt_q));
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			allzero_cnt_q <= 1'sb0;
		else if (rx_enable)
			allzero_cnt_q <= allzero_cnt_d;
	always @(*)
		case (reg2hw[85:84])
			2'h0: break_err = (allzero_cnt_d >= 5'd2);
			2'h1: break_err = (allzero_cnt_d >= 5'd4);
			2'h2: break_err = (allzero_cnt_d >= 5'd8);
			default: break_err = (allzero_cnt_d >= 5'd16);
		endcase
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			break_st_q <= BRK_CHK;
		else
			case (break_st_q)
				BRK_CHK:
					if (event_rx_break_err)
						break_st_q <= BRK_WAIT;
				BRK_WAIT:
					if (rx_in)
						break_st_q <= BRK_CHK;
				default: break_st_q <= BRK_CHK;
			endcase
	assign hw2reg[15:0] = rx_val_q;
	assign hw2reg[42:35] = uart_rdata;
	assign hw2reg[43:43] = ~rx_fifo_rvalid;
	assign hw2reg[44:44] = rx_uart_idle;
	assign hw2reg[45:45] = (tx_uart_idle & ~tx_fifo_rvalid);
	assign hw2reg[46:46] = ~tx_fifo_rvalid;
	assign hw2reg[47:47] = ~rx_fifo_wready;
	assign hw2reg[48:48] = ~tx_fifo_wready;
	assign hw2reg[27:22] = tx_fifo_depth;
	assign hw2reg[21:16] = rx_fifo_depth;
	assign hw2reg[31:31] = 1'b0;
	assign hw2reg[34:32] = 3'h0;
	assign hw2reg[28:28] = 1'b0;
	assign hw2reg[30:29] = 2'h0;
	reg [16:0] nco_sum_q;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			nco_sum_q <= 17'h0;
		else if ((tx_enable || rx_enable))
			nco_sum_q <= ({1'b0, nco_sum_q[15:0]} + {1'b0, reg2hw[83:68]});
	assign tick_baud_x16 = nco_sum_q[16];
	assign tx_fifo_rready = ((tx_uart_idle & tx_fifo_rvalid) & tx_enable);
	prim_fifo_sync #(
		.Width(8),
		.Pass(1'b0),
		.Depth(32)
	) u_uart_txfifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.clr_i(uart_fifo_txrst),
		.wvalid(reg2hw[38:38]),
		.wready(tx_fifo_wready),
		.wdata(reg2hw[46:39]),
		.depth(tx_fifo_depth),
		.rvalid(tx_fifo_rvalid),
		.rready(tx_fifo_rready),
		.rdata(tx_fifo_data)
	);
	uart_tx uart_tx(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.tx_enable(tx_enable),
		.tick_baud_x16(tick_baud_x16),
		.parity_enable(reg2hw[87:87]),
		.wr(tx_fifo_rready),
		.wr_parity((^tx_fifo_data ^ reg2hw[86:86])),
		.wr_data(tx_fifo_data),
		.idle(tx_uart_idle),
		.tx(tx_out)
	);
	assign tx = (line_loopback ? rx : tx_out_q);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			tx_out_q <= 1'b1;
		else if (ovrd_tx_en)
			tx_out_q <= ovrd_tx_val;
		else if (sys_loopback)
			tx_out_q <= 1'b1;
		else
			tx_out_q <= tx_out;
	prim_flop_2sync #(
		.Width(1),
		.ResetValue(1)
	) sync_rx(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.d(rx),
		.q(rx_sync)
	);
	reg rx_sync_q1;
	reg rx_sync_q2;
	wire rx_in_mx;
	wire rx_in_maj;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			rx_sync_q1 <= 1'b1;
			rx_sync_q2 <= 1'b1;
		end
		else begin
			rx_sync_q1 <= rx_sync;
			rx_sync_q2 <= rx_sync_q1;
		end
	assign rx_in_maj = (((rx_sync & rx_sync_q1) | (rx_sync & rx_sync_q2)) | (rx_sync_q1 & rx_sync_q2));
	assign rx_in_mx = (rxnf_enable ? rx_in_maj : rx_sync);
	assign rx_in = (sys_loopback ? tx_out : (line_loopback ? 1'b1 : rx_in_mx));
	uart_rx uart_rx(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.rx_enable(rx_enable),
		.tick_baud_x16(tick_baud_x16),
		.parity_enable(reg2hw[87:87]),
		.parity_odd(reg2hw[86:86]),
		.tick_baud(rx_tick_baud),
		.rx_valid(rx_valid),
		.rx_data(rx_fifo_data),
		.idle(rx_uart_idle),
		.frame_err(event_rx_frame_err),
		.rx(rx_in),
		.rx_parity_err(event_rx_parity_err)
	);
	assign rx_fifo_wvalid = ((rx_valid & ~event_rx_frame_err) & ~event_rx_parity_err);
	prim_fifo_sync #(
		.Width(8),
		.Pass(1'b0),
		.Depth(32)
	) u_uart_rxfifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.clr_i(uart_fifo_rxrst),
		.wvalid(rx_fifo_wvalid),
		.wready(rx_fifo_wready),
		.wdata(rx_fifo_data),
		.depth(rx_fifo_depth),
		.rvalid(rx_fifo_rvalid),
		.rready(reg2hw[47:47]),
		.rdata(uart_rdata)
	);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			rx_val_q <= 16'h0;
		else if (tick_baud_x16)
			rx_val_q <= {rx_val_q[14:0], rx_in};
	always @(*)
		case (uart_fifo_txilvl)
			2'h0: event_tx_watermark = (tx_fifo_depth >= 6'd1);
			2'h1: event_tx_watermark = (tx_fifo_depth >= 6'd4);
			2'h2: event_tx_watermark = (tx_fifo_depth >= 6'd8);
			default: event_tx_watermark = (tx_fifo_depth >= 6'd16);
		endcase
	always @(*)
		case (uart_fifo_rxilvl)
			3'h0: event_rx_watermark = (rx_fifo_depth >= 6'd1);
			3'h1: event_rx_watermark = (rx_fifo_depth >= 6'd4);
			3'h2: event_rx_watermark = (rx_fifo_depth >= 6'd8);
			3'h3: event_rx_watermark = (rx_fifo_depth >= 6'd16);
			3'h4: event_rx_watermark = (rx_fifo_depth >= 6'd30);
			default: event_rx_watermark = 1'b0;
		endcase
	assign uart_rxto_en = reg2hw[0:0];
	assign uart_rxto_val = reg2hw[24:1];
	assign rx_fifo_depth_changed = (rx_fifo_depth != rx_fifo_depth_prev_q);
	assign rx_timeout_count_d = ((uart_rxto_en == 1'b0) ? 24'd0 : (event_rx_timeout ? 24'd0 : (rx_fifo_depth_changed ? 24'd0 : ((rx_fifo_depth == 5'd0) ? 24'd0 : (rx_tick_baud ? (rx_timeout_count_q + 24'd1) : rx_timeout_count_q)))));
	assign event_rx_timeout = ((rx_timeout_count_q == uart_rxto_val) & uart_rxto_en);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			rx_timeout_count_q <= 24'd0;
			rx_fifo_depth_prev_q <= 6'd0;
		end
		else begin
			rx_timeout_count_q <= rx_timeout_count_d;
			rx_fifo_depth_prev_q <= rx_fifo_depth;
		end
	assign event_rx_overflow = (rx_fifo_wvalid & ~rx_fifo_wready);
	assign event_tx_overflow = (reg2hw[38:38] & ~tx_fifo_wready);
	assign event_rx_break_err = (break_err & (break_st_q == BRK_CHK));
	prim_intr_hw #(.Width(1)) intr_hw_tx_watermark(
		.event_intr_i(event_tx_watermark),
		.reg2hw_intr_enable_q_i(reg2hw[116:116]),
		.reg2hw_intr_test_q_i(reg2hw[108:108]),
		.reg2hw_intr_test_qe_i(reg2hw[107:107]),
		.reg2hw_intr_state_q_i(reg2hw[124:124]),
		.hw2reg_intr_state_de_o(hw2reg[63:63]),
		.hw2reg_intr_state_d_o(hw2reg[64:64]),
		.intr_o(intr_tx_watermark_o)
	);
	prim_intr_hw #(.Width(1)) intr_hw_rx_watermark(
		.event_intr_i(event_rx_watermark),
		.reg2hw_intr_enable_q_i(reg2hw[115:115]),
		.reg2hw_intr_test_q_i(reg2hw[106:106]),
		.reg2hw_intr_test_qe_i(reg2hw[105:105]),
		.reg2hw_intr_state_q_i(reg2hw[123:123]),
		.hw2reg_intr_state_de_o(hw2reg[61:61]),
		.hw2reg_intr_state_d_o(hw2reg[62:62]),
		.intr_o(intr_rx_watermark_o)
	);
	prim_intr_hw #(.Width(1)) intr_hw_tx_overflow(
		.event_intr_i(event_tx_overflow),
		.reg2hw_intr_enable_q_i(reg2hw[114:114]),
		.reg2hw_intr_test_q_i(reg2hw[104:104]),
		.reg2hw_intr_test_qe_i(reg2hw[103:103]),
		.reg2hw_intr_state_q_i(reg2hw[122:122]),
		.hw2reg_intr_state_de_o(hw2reg[59:59]),
		.hw2reg_intr_state_d_o(hw2reg[60:60]),
		.intr_o(intr_tx_overflow_o)
	);
	prim_intr_hw #(.Width(1)) intr_hw_rx_overflow(
		.event_intr_i(event_rx_overflow),
		.reg2hw_intr_enable_q_i(reg2hw[113:113]),
		.reg2hw_intr_test_q_i(reg2hw[102:102]),
		.reg2hw_intr_test_qe_i(reg2hw[101:101]),
		.reg2hw_intr_state_q_i(reg2hw[121:121]),
		.hw2reg_intr_state_de_o(hw2reg[57:57]),
		.hw2reg_intr_state_d_o(hw2reg[58:58]),
		.intr_o(intr_rx_overflow_o)
	);
	prim_intr_hw #(.Width(1)) intr_hw_rx_frame_err(
		.event_intr_i(event_rx_frame_err),
		.reg2hw_intr_enable_q_i(reg2hw[112:112]),
		.reg2hw_intr_test_q_i(reg2hw[100:100]),
		.reg2hw_intr_test_qe_i(reg2hw[99:99]),
		.reg2hw_intr_state_q_i(reg2hw[120:120]),
		.hw2reg_intr_state_de_o(hw2reg[55:55]),
		.hw2reg_intr_state_d_o(hw2reg[56:56]),
		.intr_o(intr_rx_frame_err_o)
	);
	prim_intr_hw #(.Width(1)) intr_hw_rx_break_err(
		.event_intr_i(event_rx_break_err),
		.reg2hw_intr_enable_q_i(reg2hw[111:111]),
		.reg2hw_intr_test_q_i(reg2hw[98:98]),
		.reg2hw_intr_test_qe_i(reg2hw[97:97]),
		.reg2hw_intr_state_q_i(reg2hw[119:119]),
		.hw2reg_intr_state_de_o(hw2reg[53:53]),
		.hw2reg_intr_state_d_o(hw2reg[54:54]),
		.intr_o(intr_rx_break_err_o)
	);
	prim_intr_hw #(.Width(1)) intr_hw_rx_timeout(
		.event_intr_i(event_rx_timeout),
		.reg2hw_intr_enable_q_i(reg2hw[110:110]),
		.reg2hw_intr_test_q_i(reg2hw[96:96]),
		.reg2hw_intr_test_qe_i(reg2hw[95:95]),
		.reg2hw_intr_state_q_i(reg2hw[118:118]),
		.hw2reg_intr_state_de_o(hw2reg[51:51]),
		.hw2reg_intr_state_d_o(hw2reg[52:52]),
		.intr_o(intr_rx_timeout_o)
	);
	prim_intr_hw #(.Width(1)) intr_hw_rx_parity_err(
		.event_intr_i(event_rx_parity_err),
		.reg2hw_intr_enable_q_i(reg2hw[109:109]),
		.reg2hw_intr_test_q_i(reg2hw[94:94]),
		.reg2hw_intr_test_qe_i(reg2hw[93:93]),
		.reg2hw_intr_state_q_i(reg2hw[117:117]),
		.hw2reg_intr_state_de_o(hw2reg[49:49]),
		.hw2reg_intr_state_d_o(hw2reg[50:50]),
		.intr_o(intr_rx_parity_err_o)
	);
endmodule
