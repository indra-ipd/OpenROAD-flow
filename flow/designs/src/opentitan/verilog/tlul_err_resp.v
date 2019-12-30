module tlul_err_resp (
	clk_i,
	rst_ni,
	tl_h_i,
	tl_h_o
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
	input wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_AW) + (((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW))) + top_pkg_TL_DW) + 17) - 1):0] tl_h_i;
	output wire [(((((((7 + (((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW))) + top_pkg_TL_AIW) + top_pkg_TL_DIW) + top_pkg_TL_DW) + top_pkg_TL_DUW) + 2) - 1):0] tl_h_o;
	localparam [2:0] AccessAck = 3'h 0;
	localparam [2:0] PutFullData = 3'h 0;
	localparam [2:0] AccessAckData = 3'h 1;
	localparam [2:0] PutPartialData = 3'h 1;
	localparam [2:0] Get = 3'h 4;
	reg [2:0] err_opcode;
	reg [((((8 + (32 + (((((32 >> 3) - 1) >= 0) ? (32 >> 3) : (2 - (32 >> 3))) + 48))) >= (32 + (((((32 >> 3) - 1) >= 0) ? (32 >> 3) : (2 - (32 >> 3))) + 49))) ? (((top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))) - (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))) + 1) : (((top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))) - (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))) + 1)) - 1):0] err_source;
	reg [((((((($clog2(($clog2((32 >> 3)) + 1)) - 1) >= 0) ? $clog2(($clog2((32 >> 3)) + 1)) : (2 - $clog2(($clog2((32 >> 3)) + 1)))) + (8 + (32 + (((((32 >> 3) - 1) >= 0) ? (32 >> 3) : (2 - (32 >> 3))) + 48)))) >= (8 + (32 + (((((32 >> 3) - 1) >= 0) ? (32 >> 3) : (2 - (32 >> 3))) + 49)))) ? ((((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))) - (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))))) + 1) : (((top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))) - ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))))) + 1)) - 1):0] err_size;
	reg err_req_pending;
	reg err_rsp_pending;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			err_req_pending <= 1'b0;
			err_source <= {top_pkg_TL_AIW {1'b0}};
			err_opcode <= Get;
			err_size <= 1'sb0;
		end
		else if ((tl_h_i[(1 + (3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))))))):(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))))))] && tl_h_o[0:0])) begin
			err_req_pending <= 1'b1;
			err_source <= tl_h_i[(top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16)))):(top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17)))];
			err_opcode <= tl_h_i[(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))))):(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))))))];
			err_size <= tl_h_i[((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 16))))):(top_pkg_TL_AIW + (top_pkg_TL_AW + ((((top_pkg_TL_DBW - 1) >= 0) ? top_pkg_TL_DBW : (2 - top_pkg_TL_DBW)) + (top_pkg_TL_DW + 17))))];
		end
		else if (!err_rsp_pending)
			err_req_pending <= 1'b0;
	assign tl_h_o[0:0] = (~err_rsp_pending & ~(err_req_pending & ~tl_h_i[0:0]));
	assign tl_h_o[(1 + (3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))))))):(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))))))] = (err_req_pending | err_rsp_pending);
	assign tl_h_o[(top_pkg_TL_DW + (top_pkg_TL_DUW + 1)):(top_pkg_TL_DUW + 2)] = 1'sb1;
	assign tl_h_o[(top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))):(top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))] = err_source;
	assign tl_h_o[(top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))):(top_pkg_TL_DW + (top_pkg_TL_DUW + 2))] = 1'sb0;
	assign tl_h_o[(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1)))))):((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2)))))] = 1'sb0;
	assign tl_h_o[((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))))):(top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2))))] = err_size;
	assign tl_h_o[(3 + (3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 1))))))):(3 + ((((top_pkg_TL_SZW - 1) >= 0) ? top_pkg_TL_SZW : (2 - top_pkg_TL_SZW)) + (top_pkg_TL_AIW + (top_pkg_TL_DIW + (top_pkg_TL_DW + (top_pkg_TL_DUW + 2))))))] = ((err_opcode == Get) ? AccessAckData : AccessAck);
	assign tl_h_o[(top_pkg_TL_DUW + 1):2] = 1'sb0;
	assign tl_h_o[1:1] = 1'b1;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			err_rsp_pending <= 1'b0;
		else if (((err_req_pending || err_rsp_pending) && !tl_h_i[0:0]))
			err_rsp_pending <= 1'b1;
		else
			err_rsp_pending <= 1'b0;
endmodule
