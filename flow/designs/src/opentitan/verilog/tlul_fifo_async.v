module tlul_fifo_async (
	clk_h_i,
	rst_h_ni,
	clk_d_i,
	rst_d_ni,
	tl_h_i,
	tl_h_o,
	tl_d_o,
	tl_d_i
);
	localparam top_pkg_TL_AW = 32;
	localparam top_pkg_TL_DW = 32;
	localparam top_pkg_TL_AIW = 8;
	localparam top_pkg_TL_DIW = 1;
	localparam top_pkg_TL_DUW = 16;
	localparam top_pkg_TL_DBW = (top_pkg_TL_DW >> 3);
	localparam top_pkg_TL_SZW = $clog2(($clog2((32 >> 3)) + 1));
	parameter ReqDepth = 3;
	parameter RspDepth = 3;
	input clk_h_i;
	input rst_h_ni;
	input clk_d_i;
	input rst_d_ni;
	input wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_AW) + (((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW))) + top_pkg_TL_DW) + 17) - 1):0] tl_h_i;
	output wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_DIW) + top_pkg_TL_DW) + top_pkg_TL_DUW) + 2) - 1):0] tl_h_o;
	output wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_AW) + (((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW))) + top_pkg_TL_DW) + 17) - 1):0] tl_d_o;
	input wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_DIW) + top_pkg_TL_DW) + top_pkg_TL_DUW) + 2) - 1):0] tl_d_i;
	localparam REQFIFO_WIDTH = ((((((((7 + ((($clog2(($clog2((32 >> 3)) + 1)) - 1) >= 0) ? $clog2(($clog2((32 >> 3)) + 1)) : (2 - $clog2(($clog2((32 >> 3)) + 1))))) + 40) + ((((32 >> 3) - 1) >= 0) ? (32 >> 3) : (2 - (32 >> 3)))) + 49) - 1) >= 0) ? ((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_AW) + (((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW))) + top_pkg_TL_DW) + 17) : (2 - ((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_AW) + (((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW))) + top_pkg_TL_DW) + 17))) - 2);
	prim_fifo_async #(
		.Width(REQFIFO_WIDTH),
		.Depth(ReqDepth)
	) reqfifo(
		.clk_wr_i(clk_h_i),
		.rst_wr_ni(rst_h_ni),
		.clk_rd_i(clk_d_i),
		.rst_rd_ni(rst_d_ni),
		.wvalid(tl_h_i[(1 + (3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))))))):(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))))))]),
		.wready(tl_h_o[0:0]),
		.wdata({tl_h_i[(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))))):(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))))))], tl_h_i[(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))))):((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))))], tl_h_i[((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))):(top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))))], tl_h_i[(top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))):(top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))], tl_h_i[(top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))):((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))], tl_h_i[((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)):(top_pkg_TL_DW + 17)], tl_h_i[(top_pkg_TL_DW + 16):17], tl_h_i[16:1]}),
		.rvalid(tl_d_o[(1 + (3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))))))):(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))))))]),
		.rready(tl_d_i[0:0]),
		.rdata({tl_d_o[(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))))):(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))))))], tl_d_o[(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))))):((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))))], tl_d_o[((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))):(top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))))], tl_d_o[(top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))):(top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))], tl_d_o[(top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))):((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))], tl_d_o[((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)):(top_pkg_TL_DW + 17)], tl_d_o[(top_pkg_TL_DW + 16):17], tl_d_o[16:1]}),
		.wdepth(),
		.rdepth()
	);
	localparam RSPFIFO_WIDTH = ((((((7 + ((($clog2(($clog2((32 >> 3)) + 1)) - 1) >= 0) ? $clog2(($clog2((32 >> 3)) + 1)) : (2 - $clog2(($clog2((32 >> 3)) + 1))))) + 59) - 1) >= 0) ? ((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_DIW) + top_pkg_TL_DW) + top_pkg_TL_DUW) + 2) : (2 - ((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_DIW) + top_pkg_TL_DW) + top_pkg_TL_DUW) + 2))) - 2);
	prim_fifo_async #(
		.Width(RSPFIFO_WIDTH),
		.Depth(RspDepth)
	) rspfifo(
		.clk_wr_i(clk_d_i),
		.rst_wr_ni(rst_d_ni),
		.clk_rd_i(clk_h_i),
		.rst_rd_ni(rst_h_ni),
		.wvalid(tl_d_i[(1 + (3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))))))):(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))))))]),
		.wready(tl_d_o[0:0]),
		.wdata({tl_d_i[(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))))))):(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2))))))], tl_d_i[(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))))):((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))))], tl_d_i[((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))))):(top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2))))], tl_d_i[(top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))):(top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))], tl_d_i[(top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))):(top_pkg_TL_DW + (top_pkg_TL_DUW + 2))], tl_d_i[(top_pkg_TL_DW + (top_pkg_TL_DUW + 1)):(top_pkg_TL_DUW + 2)], tl_d_i[(top_pkg_TL_DUW + 1):2], tl_d_i[1:1]}),
		.rvalid(tl_h_o[(1 + (3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))))))):(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))))))]),
		.rready(tl_h_i[0:0]),
		.rdata({tl_h_o[(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))))))):(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2))))))], tl_h_o[(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))))):((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))))], tl_h_o[((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))))):(top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2))))], tl_h_o[(top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))):(top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))], tl_h_o[(top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))):(top_pkg_TL_DW + (top_pkg_TL_DUW + 2))], tl_h_o[(top_pkg_TL_DW + (top_pkg_TL_DUW + 1)):(top_pkg_TL_DUW + 2)], tl_h_o[(top_pkg_TL_DUW + 1):2], tl_h_o[1:1]}),
		.wdepth(),
		.rdepth()
	);
endmodule
