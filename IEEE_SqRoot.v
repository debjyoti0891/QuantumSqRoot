`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:49:58 05/29/2017 
// Design Name: 
// Module Name:    IEEE_SqRoot 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	Copyright (C) 2017  Srijit Dutta
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
////////////////////////////////////////////////asign //////////////////////////////////
module top_module(i,o);
	input [31:0] i;
	output [31:0] o;
	
	wire signed [7:0] mant; 
	wire signed [22:0] frac;
	
	assign mant = i[30:23];
	assign frac = i[22:0];
	
	wire signed [7:0] new_mant = mant[7] == 1?
		mant - 8'b01111111 : 8'b01111111 - mant;
	
	wire signed [24:0] sqrt2 = 25'b0101101010000010011110011;
	wire signed [7:0] fin_man1 = new_mant[0] == 0 ?
		(new_mant>>1) +  8'b01111111 : 
		((new_mant - 8'b00000001)>>1) +  8'b01111111;
		
		
	wire signed [7:0] fin_man2 = new_mant[0] == 0 ?
		8'b01111111 - (new_mant>>1) :
		8'b01111111 - ((new_mant + 8'b00000001)>>1);
		
	wire signed [7:0] fin_mant = mant[7] == 1?
							fin_man1 : fin_man2;
	
	wire signed [24:0] val = {2'b01,frac};
	
	//////  preparatory   ///////
	wire signed [24:0] a0;
	wire signed [24:0] c0;
	wire signed [24:0] a1;
	wire signed [24:0] c1;
	wire signed [24:0] a2;
	wire signed [24:0] c2;
	wire signed [24:0] a3;
	wire signed [24:0] c3;
	wire signed [24:0] a4;
	wire signed [24:0] c4;
	
	assign a0 = val >> 2;

	wire signed [24:0] one;
	wire signed [24:0] thr_fourth;
	wire signed [24:0] mone;
	assign mone = 25'b1100000000000000000000000; //-1
	assign one = 25'b0100000000000000000000000; //1
	assign thr_fourth = 25'b1011000000000000000000000; //-3/4
	
	
	assign c0[23:0] = (a0[24] == mone[24]) ? a0[23:0] + mone[23:0] : 
		(a0[23:0] > mone[23:0]) ? (a0[23:0]-mone[23:0]) : (mone[23:0] - a0[23:0]);

	assign c0[24] = (a0[24] == mone[24]) ? a0[24] :
		(a0[24] == 0 && mone[24] == 1) ? (( a0[23:0] > mone[23:0] ) ? 0 : ( (c0[23:0] == 0) ? 0 : 1)) :
		(( a0[23:0] > mone[23:0] ) ? (c0[23:0] == 0 ? 0 : 1) : 0);


	//////  block 1  ////////
	//input a0 and c0 get o/p in a1,c1

	wire signed [24:0] inter11;
	wire signed [24:0] inter12;
	wire signed [24:0] inter13;

	wire signed [23:0] tmp1 = c0[23:0];
	wire signed [24:0] b1 = {1'b0,tmp1>>1};

	assign inter11[23:0] = (b1[24] == one[24]) ? b1[23:0] + one[23:0] : 
		(b1[23:0] > one[23:0]) ? (b1[23:0]-one[23:0]) : (one[23:0] - b1[23:0]);

	assign inter11[24] = (b1[24] == one[24]) ? b1[24] :
		(b1[24] == 0 && one[24] == 1) ? (( b1[23:0] > one[23:0] ) ? 0 : ( (inter11[23:0] == 0) ? 0 : 1)) :
		(( b1[23:0] > one[23:0] ) ? (inter11[23:0] == 0 ? 0 : 1) : 0);

	wire signed [24:0] t1 = {c0[24],tmp1>>2};

	assign inter12[23:0] = (t1[24] == thr_fourth[24]) ? t1[23:0] + thr_fourth[23:0] : 
		(t1[23:0] > thr_fourth[23:0]) ? (t1[23:0]-thr_fourth[23:0]) : (thr_fourth[23:0] - t1[23:0]);

	assign inter12[24] = (t1[24] == thr_fourth[24]) ? t1[24] :
		(t1[24] == 0 && thr_fourth[24] == 1) ? (( t1[23:0] > thr_fourth[23:0] ) ? 0 : ( (inter12[23:0] == 0) ? 0 : 1)) :
		(( t1[23:0] > thr_fourth[23:0] ) ? (inter12[23:0] == 0 ? 0 : 1) : 0);

	wire signed [49:0] r_result11;
	wire signed [49:0] r_result12;
	wire signed [49:0] r_result13;

	assign r_result11 = inter11[23:0] * a0[23:0];
	assign a1[24] = inter11[24] ^ a0[24];
	assign a1[23:0] = r_result11[46:23];

	assign r_result12 = inter12[23:0] * c0[23:0];
	assign inter13[24] = inter12[24] ^ c0[24];
	assign inter13[23:0] = r_result12[46:23];

	assign r_result13 = inter13[23:0] * c0[23:0];
	assign c1[24] = inter13[24] ^ c0[24];
	assign c1[23:0] = r_result13[46:23];

	////////////////////////




	//////  block 2  ////////
	//input a1 and c1 get o/p in a2,c2

	wire signed [24:0] inter21;
	wire signed [24:0] inter22;
	wire signed [24:0] inter23;

	wire signed [23:0] tmp2 = c1[23:0];
	wire signed [24:0] b2 = {1'b0,tmp2>>1};

	assign inter21[23:0] = (b2[24] == one[24]) ? b2[23:0] + one[23:0] : 
		(b2[23:0] > one[23:0]) ? (b2[23:0]-one[23:0]) : (one[23:0] - b2[23:0]);

	assign inter21[24] = (b2[24] == one[24]) ? b2[24] :
		(b2[24] == 0 && one[24] == 1) ? (( b2[23:0] > one[23:0] ) ? 0 : ( (inter21[23:0] == 0) ? 0 : 1)) :
		(( b2[23:0] > one[23:0] ) ? (inter21[23:0] == 0 ? 0 : 1) : 0);

	wire signed [24:0] t2 = {c1[24],tmp2>>2};

	assign inter22[23:0] = (t2[24] == thr_fourth[24]) ? t2[23:0] + thr_fourth[23:0] : 
		(t2[23:0] > thr_fourth[23:0]) ? (t2[23:0]-thr_fourth[23:0]) : (thr_fourth[23:0] - t2[23:0]);

	assign inter22[24] = (t2[24] == thr_fourth[24]) ? t2[24] :
		(t2[24] == 0 && thr_fourth[24] == 1) ? (( t2[23:0] > thr_fourth[23:0] ) ? 0 : ( (inter22[23:0] == 0) ? 0 : 1)) :
		(( t2[23:0] > thr_fourth[23:0] ) ? (inter22[23:0] == 0 ? 0 : 1) : 0);

	wire signed [49:0] r_result21;
	wire signed [49:0] r_result22;
	wire signed [49:0] r_result23;

	assign r_result21 = inter21[23:0] * a1[23:0];
	assign a2[24] = inter21[24] ^ a1[24];
	assign a2[23:0] = r_result21[46:23];

	assign r_result22 = inter22[23:0] * c1[23:0];
	assign inter23[24] = inter22[24] ^ c1[24];
	assign inter23[23:0] = r_result22[46:23];

	assign r_result23 = inter23[23:0] * c1[23:0];
	assign c2[24] = inter23[24] ^ c1[24];
	assign c2[23:0] = r_result23[46:23];

	////////////////////////




	//////  block 3  ////////
	//input a2 and c2 get o/p in a3,c3

	wire signed [24:0] inter31;
	wire signed [24:0] inter32;
	wire signed [24:0] inter33;

	wire signed [23:0] tmp3 = c2[23:0];
	wire signed [24:0] b3 = {1'b0,tmp3>>1};

	assign inter31[23:0] = (b3[24] == one[24]) ? b3[23:0] + one[23:0] : 
		(b3[23:0] > one[23:0]) ? (b3[23:0]-one[23:0]) : (one[23:0] - b3[23:0]);

	assign inter31[24] = (b3[24] == one[24]) ? b3[24] :
		(b3[24] == 0 && one[24] == 1) ? (( b3[23:0] > one[23:0] ) ? 0 : ( (inter31[23:0] == 0) ? 0 : 1)) :
		(( b3[23:0] > one[23:0] ) ? (inter31[23:0] == 0 ? 0 : 1) : 0);

	wire signed [24:0] t3 = {c2[24],tmp3>>2};

	assign inter32[23:0] = (t3[24] == thr_fourth[24]) ? t3[23:0] + thr_fourth[23:0] : 
		(t3[23:0] > thr_fourth[23:0]) ? (t3[23:0]-thr_fourth[23:0]) : (thr_fourth[23:0] - t3[23:0]);

	assign inter32[24] = (t3[24] == thr_fourth[24]) ? t3[24] :
		(t3[24] == 0 && thr_fourth[24] == 1) ? (( t3[23:0] > thr_fourth[23:0] ) ? 0 : ( (inter32[23:0] == 0) ? 0 : 1)) :
		(( t3[23:0] > thr_fourth[23:0] ) ? (inter32[23:0] == 0 ? 0 : 1) : 0);

	wire signed [49:0] r_result31;
	wire signed [49:0] r_result32;
	wire signed [49:0] r_result33;

	assign r_result31 = inter31[23:0] * a2[23:0];
	assign a3[24] = inter31[24] ^ a2[24];
	assign a3[23:0] = r_result31[46:23];

	assign r_result32 = inter32[23:0] * c2[23:0];
	assign inter33[24] = inter32[24] ^ c2[24];
	assign inter33[23:0] = r_result32[46:23];

	assign r_result33 = inter33[23:0] * c2[23:0];
	assign c3[24] = inter33[24] ^ c2[24];
	assign c3[23:0] = r_result33[46:23];

	////////////////////////




	//////  block 4  ////////
	//input a3 and c3 get o/p in a4,c4

	wire signed [24:0] inter41;
	wire signed [24:0] inter42;
	wire signed [24:0] inter43;

	wire signed [23:0] tmp4 = c3[23:0];
	wire signed [24:0] b4 = {1'b0,tmp4>>1};

	assign inter41[23:0] = (b4[24] == one[24]) ? b4[23:0] + one[23:0] : 
		(b4[23:0] > one[23:0]) ? (b4[23:0]-one[23:0]) : (one[23:0] - b4[23:0]);

	assign inter41[24] = (b4[24] == one[24]) ? b4[24] :
		(b4[24] == 0 && one[24] == 1) ? (( b4[23:0] > one[23:0] ) ? 0 : ( (inter41[23:0] == 0) ? 0 : 1)) :
		(( b4[23:0] > one[23:0] ) ? (inter41[23:0] == 0 ? 0 : 1) : 0);

	wire signed [24:0] t4 = {c3[24],tmp4>>2};

	assign inter42[23:0] = (t4[24] == thr_fourth[24]) ? t4[23:0] + thr_fourth[23:0] : 
		(t4[23:0] > thr_fourth[23:0]) ? (t4[23:0]-thr_fourth[23:0]) : (thr_fourth[23:0] - t4[23:0]);

	assign inter42[24] = (t4[24] == thr_fourth[24]) ? t4[24] :
		(t4[24] == 0 && thr_fourth[24] == 1) ? (( t4[23:0] > thr_fourth[23:0] ) ? 0 : ( (inter42[23:0] == 0) ? 0 : 1)) :
		(( t4[23:0] > thr_fourth[23:0] ) ? (inter42[23:0] == 0 ? 0 : 1) : 0);

	wire signed [49:0] r_result41;
	wire signed [49:0] r_result42;
	wire signed [49:0] r_result43;

	assign r_result41 = inter41[23:0] * a3[23:0];
	assign a4[24] = inter41[24] ^ a3[24];
	assign a4[23:0] = r_result41[46:23];

	assign r_result42 = inter42[23:0] * c3[23:0];
	assign inter43[24] = inter42[24] ^ c2[24];
	assign inter43[23:0] = r_result42[46:23];

	assign r_result43 = inter43[23:0] * c3[23:0];
	assign c4[24] = inter43[24] ^ c3[24];
	assign c4[23:0] = r_result43[46:23];

	////////////////////////


	wire signed [23:0] tt;
	assign tt = a4[23:0];
	wire signed [24:0] sqrt_val= {1'b0, tt<<1};

	wire signed [24:0] fsqrt_val = frac == 0 ?
							25'b0000000000000000000000000:
							sqrt_val;
							
	wire signed [49:0] r_pdt;
	wire signed [24:0] pdt;
	assign r_pdt = sqrt_val[23:0] * sqrt2[23:0];
	assign pdt[24] = sqrt_val[24] ^ sqrt2[24];
	assign pdt[23:0] = r_pdt[46:23];
	
	assign o = new_mant[0] == 0 ?
		{1'b0,fin_mant,fsqrt_val[22:0]}:
		{1'b0,fin_mant,pdt[22:0]};


endmodule
