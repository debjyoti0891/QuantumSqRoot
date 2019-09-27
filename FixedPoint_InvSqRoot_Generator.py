'''
	Copyright (C) 2017  Srijit Dutta
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
'''

import math

def main(): #for block.v
	n1 = input("Enter n (Total bits including sign bit): ")
	q1 = input("Enter q (Number of fractional bits): ")
	it1 = input("Enter no. of iterations :")
	
	n = int(n1)
	q=int(q1)
	ite = int(it1)

	
	fb = open("inv_"+n1+"_"+q1+"_"+it1+".v","w")
	fb.close()

	m = n-q-1
	with open("inv_"+n1+"_"+q1+"_"+it1+".v","a") as f:
		f.write("`timescale 1ns / 1ps\n")
		f.write("module top_module(i, o);\n")
		f.write("\n")

		f.write("\tinput ["+str(n-1)+":0] i;\n")
		f.write("\toutput ["+str(n-1)+":0] o;\n")
		
		f.write("\n")
		f.write("\twire signed ["+str(n-1)+":0] three = "+str(n)+"'b0")
		for i in range(m-2):
			f.write("0")
		f.write("11")
		for i in range(q):
			f.write("0")
		f.write(";\n")
		f.write("\twire signed ["+str(n-1)+":0] y0 = "+str(n)+"'b0")
		for i in range(m):
			f.write("0")
		f.write("001")
		for i in range(q-3):
			f.write("0")
		f.write(";\n")


		for j in range(ite) :
			i = j+1
			f.write("\n")
			f.write("\t//////  block "+str(i)+"  ////////\n")
			f.write("\twire signed ["+str(n-1)+":0] y"+str(i)+";\n")
			f.write("\twire signed ["+str(2*n-1)+":0] r_result"+str(i)+"1;\n")
			f.write("\twire signed ["+str(2*n-1)+":0] r_result"+str(i)+"2;\n")
			f.write("\twire signed ["+str(2*n-1)+":0] r_result"+str(i)+"3;\n")
			f.write("\twire signed ["+str(n-1)+":0] inter"+str(i)+"1;\n")
			f.write("\twire signed ["+str(n-1)+":0] inter"+str(i)+"2;\n")
			f.write("\twire signed ["+str(n-1)+":0] inter"+str(i)+"3;\n")
			f.write("\n")

			f.write("\tassign r_result"+str(i)+"1 = y"+str(i-1)+"["+str(n-2)+":0] * y"+str(i-1)+"["+str(n-2)+":0];\n")
			f.write("\tassign inter"+str(i)+"1["+str(n-1)+"] = y"+str(i-1)+"["+str(n-1)+"] ^ y"+str(i-1)+"["+str(n-1)+"];\n")
			f.write("\tassign inter"+str(i)+"1["+str(n-2)+":0] = r_result"+str(i)+"1["+str(n-2+q)+":"+str(q)+"];\n")
			f.write("\n")

			f.write("\tassign r_result"+str(i)+"2 = inter"+str(i)+"1["+str(n-2)+":0] * i["+str(n-2)+":0];\n")
			f.write("\tassign inter"+str(i)+"2["+str(n-1)+"] = 1;\n")
			f.write("\tassign inter"+str(i)+"2["+str(n-2)+":0] = r_result"+str(i)+"2["+str(n-2+q)+":"+str(q)+"];\n")
			f.write("\n")


			f.write("\n")
			f.write("\tassign inter"+str(i)+"3["+str(n-2)+":0] = (inter"+str(i)+"2["+str(n-1)+"] == three["+str(n-1)+"]) ? inter"+str(i)+"2["+str(n-2)+":0] + three["+str(n-2)+":0] : \n\t\t(inter"+str(i)+"2["+str(n-2)+":0] > three["+str(n-2)+":0]) ? (inter"+str(i)+"2["+str(n-2)+":0]-three["+str(n-2)+":0]) : (three["+str(n-2)+":0] - inter"+str(i)+"2["+str(n-2)+":0]);\n")
			f.write("\n")
			f.write("\tassign inter"+str(i)+"3["+str(n-1)+"] = (inter"+str(i)+"2["+str(n-1)+"] == three["+str(n-1)+"]) ? inter"+str(i)+"2["+str(n-1)+"] :\n\t\t(inter"+str(i)+"2["+str(n-1)+"] == 0 && three["+str(n-1)+"] == 1) ? (( inter"+str(i)+"2["+str(n-2)+":0] > three["+str(n-2)+":0] ) ? 0 : ( (inter"+str(i)+"3["+str(n-2)+":0] == 0) ? 0 : 1)) :\n\t\t(( inter"+str(i)+"2["+str(n-2)+":0] > three["+str(n-2)+":0] ) ? (inter"+str(i)+"3["+str(n-2)+":0] == 0 ? 0 : 1) : 0);\n")
			f.write("\n")



			f.write("\twire signed ["+str(n-1)+":0] temp"+str(i)+" = inter"+str(i)+"3 >> 1;\n")
			f.write("\n")

			f.write("\tassign r_result"+str(i)+"3 = temp"+str(i)+"["+str(n-2)+":0] * y"+str(i-1)+"["+str(n-2)+":0];\n")
			f.write("\tassign y"+str(i)+"["+str(n-1)+"] = temp"+str(i)+"["+str(n-1)+"] ^ y"+str(i-1)+"["+str(n-1)+"];\n")
			f.write("\tassign y"+str(i)+"["+str(n-2)+":0] = r_result"+str(i)+"3["+str(n-2+q)+":"+str(q)+"];\n")
			f.write("\n")

			f.write("/////////////////\n")
			f.write("\n")


		f.write("\tassign o = y"+str(ite)+";\n")
		f.write("\n")
		f.write("endmodule")

if __name__ == "__main__":
	main()
