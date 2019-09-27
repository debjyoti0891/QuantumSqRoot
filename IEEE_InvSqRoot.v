`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:52 06/18/2017 
// Design Name: 
// Module Name:    IEEE_InvSqRoot 
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
//////////////////////////////////////////////////////////////////////////////////
module combined(i,o);
	
	input [31:0] i;
	output [31:0] o;
	
	wire signed [7:0] exp; 
	wire  [22:0] frac;
	
	wire signed [31:0] t1;
	wire signed [31:0] t2;
	wire signed [31:0] t3;
	wire signed [31:0] t4;
	
	wire signed [31:0] shifti = i>>1;
	wire signed [31:0] magic = 32'b01011111001101110101100111011111;
	wire signed [31:0] threetwo = 32'b00111111110000000000000000000000;
	
	wire signed [31:0] o1 = magic - shifti;
	assign exp = i[30:23];
	assign frac = i[22:0];
	wire signed [31:0] i_half = {1'b0, exp-8'b00000001, frac};
	
	/////////////////////////////////////////////////////////////////////////////
	
	wire signed [7:0] exp1; 
	wire  [22:0] frac1;
	wire  [23:0] mfrac1;
	
	assign exp1 = o1[30:23];
	assign frac1 = o1[22:0];
	assign mfrac1 = {1'b1,frac1};
	
	wire [47:0] ansfrac = mfrac1 * mfrac1;
	wire signed [7:0] extra = ansfrac[47]>0 ? 8'b00000001 : 8'b00000000;
	wire signed [7:0] bias = 8'b01111111;
	wire signed [7:0] temp = exp1 - bias;
	wire signed [7:0] temp2 = exp1 + extra;
	wire signed [7:0] ansexp = temp + temp2;
	wire [47:0] finfrac = ansfrac[47]>0 ? ansfrac >> 1 : ansfrac;
	
	assign t1 = {1'b0,ansexp, finfrac[45:23]};
	
	//////////////////////////////// mul /////////////////////////////////////////////
	
	wire signed [7:0] exp12; 
	wire  [22:0] frac12;
	wire signed [7:0] exp22; 
	wire  [22:0] frac22;
	wire  [23:0] mfrac12;
	wire  [23:0] mfrac22;
	
	assign exp12 = t1[30:23];
	assign frac12 = t1[22:0];
	assign exp22 = i_half[30:23];
	assign frac22 = i_half[22:0];
	assign mfrac12 = {1'b1,frac12};
	assign mfrac22 = {1'b1,frac22};
	
	wire [47:0] ansfrac2 = mfrac12 * mfrac22;
	wire signed [7:0] extra2 = ansfrac2[47]>0 ? 8'b00000001 : 8'b00000000;
	wire signed [7:0] bias2 = 8'b01111111;
	wire signed [7:0] tempu = exp12 - bias2;
	wire signed [7:0] tempu2 = exp22 + extra2;
	wire signed [7:0] ansexp2 = tempu + tempu2;
	wire [47:0] finfrac2 = ansfrac2[47]>0 ? ansfrac2 >> 1 : ansfrac2;
	
	assign t2 = {1'b0,ansexp2, finfrac2[45:23]};
	
	//////////////////////////////  sub   //////////////////////////////////////////////
	
	wire signed [7:0] texp1; 
	wire  [22:0] tfrac1;
	wire signed [7:0] texp2; 
	wire  [22:0] tfrac2;
	wire  [23:0] tmfrac1;
	wire  [23:0] tmfrac2;
	wire  [23:0] tmnfrac;
	
	assign texp1 = threetwo[30:23];
	assign tfrac1 = threetwo[22:0];
	assign texp2 = t2[30:23];
	assign tfrac2 = t2[22:0];
	wire signed [7:0] tdifexp = texp1 - texp2;
	
	assign tmfrac1 = {1'b1,tfrac1};
	assign tmfrac2 = {1'b1,tfrac2};
	assign tmnfrac = tmfrac2 >> tdifexp;

	wire signed [23:0] tans = tmfrac1 - tmnfrac;
	wire signed [23:0] tans1 = tans << 1;
	wire signed [22:0] tfinfrac = (tans[23]>0) ? tans[22:0] : tans1[22:0];
	
	wire signed [22:0] tfinexp = (tans[23]>0) ? texp1 : texp1-8'b00000001;
	
	assign t3 = {1'b0,tfinexp, tfinfrac};
	
	//////////////////////////// mul /////////////////////////////////////////


	wire signed [7:0] qexp1; 
	wire  [22:0] qfrac1;
	wire signed [7:0] qexp2; 
	wire  [22:0] qfrac2;
	wire  [23:0] qmfrac1;
	wire  [23:0] qmfrac2;
	
	assign qexp1 = o1[30:23];
	assign qfrac1 = o1[22:0];
	assign qexp2 = t3[30:23];
	assign qfrac2 = t3[22:0];
	assign qmfrac1 = {1'b1,qfrac1};
	assign qmfrac2 = {1'b1,qfrac2};
	
	wire [47:0] qansfrac = qmfrac1 * qmfrac2;
	wire signed [7:0] qextra = qansfrac[47]>0 ? 8'b00000001 : 8'b00000000;
	wire signed [7:0] qbias = 8'b01111111;
	wire signed [7:0] qtemp = qexp1 - qbias;
	wire signed [7:0] qtemp2 = qexp2 + qextra;
	wire signed [7:0] qansexp = qtemp + qtemp2;
	wire [47:0] qfinfrac = qansfrac[47]>0 ? qansfrac >> 1 : qansfrac;
	
	assign o = {1'b0,qansexp, qfinfrac[45:23]};
endmodule
