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

	
	fb = open("file_"+n1+"_"+q1+"_"+it1+".v","w")
	fb.close()


	with open("file_"+n1+"_"+q1+"_"+it1+".v","a") as f:
		f.write("`timescale 1ns / 1ps\n")
		f.write("module single_module(i, o);\n")
		f.write("\n")

		f.write("\tinput ["+str(n-1)+":0] i;\n")
		f.write("\toutput ["+str(n-1)+":0] o;\n")
		
		f.write("\n")
		f.write("//////  preparatory   ///////\n")

		for j in range(ite+1) :
			f.write("\twire signed ["+str(n-1)+":0] a"+str(j)+";\n");
			f.write("\twire signed ["+str(n-1)+":0] c"+str(j)+";\n");
		f.write("\n");


		if (n-q-1)%2 == 0 :
			f.write("\tassign a0 = i >> "+str(n-q-1) + ";\n")
		else :
			f.write("\tassign a0 = i >> "+str(n-q) + ";\n")

		f.write("\n")
		f.write("\twire signed ["+str(n-1)+":0] one;\n");
		f.write("\twire signed ["+str(n-1)+":0] thr_fourth;\n");
		f.write("\twire signed ["+str(n-1)+":0] mone;\n");

		f.write("\tassign mone = "+str(n)+"'b1")
		for i in range(n-q-2):
			f.write("0")
		f.write("1")
		for i in range(q):
			f.write("0")
		f.write("; //-1\n")

		f.write("\tassign one = "+str(n)+"'b0")
		for i in range(n-q-2):
			f.write("0")
		f.write("1")
		for i in range(q):
			f.write("0")
		f.write("; //1\n")

		f.write("\tassign thr_fourth = "+str(n)+"'b1")
		for i in range(n-q-1):
			f.write("0")
		f.write("11")
		for i in range(q-2):
			f.write("0")
		f.write("; //-3/4\n")
		f.write("\n")

		f.write("\tassign c0["+str(n-2)+":0] = (a0["+str(n-1)+"] == mone["+str(n-1)+"]) ? a0["+str(n-2)+":0] + mone["+str(n-2)+":0] : \n\t\t(a0["+str(n-2)+":0] > mone["+str(n-2)+":0]) ? (a0["+str(n-2)+":0]-mone["+str(n-2)+":0]) : (mone["+str(n-2)+":0] - a0["+str(n-2)+":0]);\n")
		f.write("\n")
		f.write("\tassign c0["+str(n-1)+"] = (a0["+str(n-1)+"] == mone["+str(n-1)+"]) ? a0["+str(n-1)+"] :\n\t\t(a0["+str(n-1)+"] == 0 && mone["+str(n-1)+"] == 1) ? (( a0["+str(n-2)+":0] > mone["+str(n-2)+":0] ) ? 0 : ( (c0["+str(n-2)+":0] == 0) ? 0 : 1)) :\n\t\t(( a0["+str(n-2)+":0] > mone["+str(n-2)+":0] ) ? (c0["+str(n-2)+":0] == 0 ? 0 : 1) : 0);\n")

		for j in range(ite) :
			i = j+1
			f.write("\n")
			f.write("\n")
			f.write("\t//////  block "+str(i)+"  ////////\n")
			f.write("\t//input a"+str(i-1)+" and c"+str(i-1)+" get o/p in a"+str(i)+" and c"+str(i)+"\n")
			f.write("\n")

			f.write("\twire signed ["+str(n-1)+":0] inter"+str(i)+"1;\n")
			f.write("\twire signed ["+str(n-1)+":0] inter"+str(i)+"2;\n")
			f.write("\twire signed ["+str(n-1)+":0] inter"+str(i)+"3;\n")
			f.write("\n")
			f.write("\twire signed ["+str(n-2)+":0] tmp"+str(i)+" = c"+str(i-1)+"["+str(n-2)+":0];\n");
			f.write("\twire signed ["+str(n-1)+":0] b"+str(i)+" = {1'b0,tmp"+str(i)+">>1};\n")


			f.write("\n")
			f.write("\tassign inter"+str(i)+"1["+str(n-2)+":0] = (b"+str(i)+"["+str(n-1)+"] == one["+str(n-1)+"]) ? b"+str(i)+"["+str(n-2)+":0] + one["+str(n-2)+":0] : \n\t\t(b"+str(i)+"["+str(n-2)+":0] > one["+str(n-2)+":0]) ? (b"+str(i)+"["+str(n-2)+":0]-one["+str(n-2)+":0]) : (one["+str(n-2)+":0] - b"+str(i)+"["+str(n-2)+":0]);\n")
			f.write("\n")
			f.write("\tassign inter"+str(i)+"1["+str(n-1)+"] = (b"+str(i)+"["+str(n-1)+"] == one["+str(n-1)+"]) ? b"+str(i)+"["+str(n-1)+"] :\n\t\t(b"+str(i)+"["+str(n-1)+"] == 0 && one["+str(n-1)+"] == 1) ? (( b"+str(i)+"["+str(n-2)+":0] > one["+str(n-2)+":0] ) ? 0 : ( (inter"+str(i)+"1["+str(n-2)+":0] == 0) ? 0 : 1)) :\n\t\t(( b"+str(i)+"["+str(n-2)+":0] > one["+str(n-2)+":0] ) ? (inter"+str(i)+"1["+str(n-2)+":0] == 0 ? 0 : 1) : 0);\n")
			f.write("\n")

			f.write("\twire signed ["+str(n-1)+":0] t"+str(i)+" = {c"+str(i-1)+"["+str(n-1)+"],tmp"+str(i)+">>2};\n")
			f.write("\n")		

			f.write("\tassign inter"+str(i)+"2["+str(n-2)+":0] = (t"+str(i)+"["+str(n-1)+"] == thr_fourth["+str(n-1)+"]) ? t"+str(i)+"["+str(n-2)+":0] + thr_fourth["+str(n-2)+":0] : \n\t\t(t"+str(i)+"["+str(n-2)+":0] > thr_fourth["+str(n-2)+":0]) ? (t"+str(i)+"["+str(n-2)+":0]-thr_fourth["+str(n-2)+":0]) : (thr_fourth["+str(n-2)+":0] - t"+str(i)+"["+str(n-2)+":0]);\n")
			f.write("\n")
			f.write("\tassign inter"+str(i)+"2["+str(n-1)+"] = (t"+str(i)+"["+str(n-1)+"] == thr_fourth["+str(n-1)+"]) ? t"+str(i)+"["+str(n-1)+"] :\n\t\t(t"+str(i)+"["+str(n-1)+"] == 0 && thr_fourth["+str(n-1)+"] == 1) ? (( t"+str(i)+"["+str(n-2)+":0] > thr_fourth["+str(n-2)+":0] ) ? 0 : ( (inter"+str(i)+"2["+str(n-2)+":0] == 0) ? 0 : 1)) :\n\t\t(( t"+str(i)+"["+str(n-2)+":0] > thr_fourth["+str(n-2)+":0] ) ? (inter"+str(i)+"2["+str(n-2)+":0] == 0 ? 0 : 1) : 0);\n")
			f.write("\n")


			f.write("\twire signed ["+str(2*n-1)+":0] r_result"+str(i)+"1;\n")
			f.write("\twire signed ["+str(2*n-1)+":0] r_result"+str(i)+"2;\n")
			f.write("\twire signed ["+str(2*n-1)+":0] r_result"+str(i)+"3;\n")
			f.write("\n")


			f.write("\tassign r_result"+str(i)+"1 = inter"+str(i)+"1["+str(n-2)+":0] * a"+str(i-1)+"["+str(n-2)+":0];\n")
			f.write("\tassign a"+str(i)+"["+str(n-1)+"] = inter"+str(i)+"1["+str(n-1)+"] ^ a"+str(i-1)+"["+str(n-1)+"];\n")
			f.write("\tassign a"+str(i)+"["+str(n-2)+":0] = r_result"+str(i)+"1["+str(n-2+q)+":"+str(q)+"];\n")
			f.write("\n")

			f.write("\tassign r_result"+str(i)+"2 = inter"+str(i)+"2["+str(n-2)+":0] * c"+str(i-1)+"["+str(n-2)+":0];\n")
			f.write("\tassign inter"+str(i)+"3["+str(n-1)+"] = inter"+str(i)+"2["+str(n-1)+"] ^ c"+str(i-1)+"["+str(n-1)+"];\n")
			f.write("\tassign inter"+str(i)+"3["+str(n-2)+":0] = r_result"+str(i)+"2["+str(n-2+q)+":"+str(q)+"];\n")
			f.write("\n")

			f.write("\tassign r_result"+str(i)+"3 = inter"+str(i)+"3["+str(n-2)+":0] * c"+str(i-1)+"["+str(n-2)+":0];\n")
			f.write("\tassign c"+str(i)+"["+str(n-1)+"] = inter"+str(i)+"3["+str(n-1)+"] ^ c"+str(i-1)+"["+str(n-1)+"];\n")
			f.write("\tassign c"+str(i)+"["+str(n-2)+":0] = r_result"+str(i)+"3["+str(n-2+q)+":"+str(q)+"];\n")
			f.write("\n")
			f.write("\t////////////////////////\n")
			f.write("\n")
			f.write("\n")



		f.write("\twire signed ["+str(n-2)+":0] tt;\n")
		f.write("\tassign tt = a"+str(ite)+"["+str(n-2)+":0];\n")

		if (n-q-1)%2 == 0 :
			f.write("\tassign o = {1'b0, tt<<"+str(math.floor((n-q-1)/2))+"};\n")
		else :
			f.write("\tassign o = {1'b0, tt<<"+str(math.floor((n-q)/2))+"};\n")

		f.write("\n")
		f.write("endmodule")



if __name__ == "__main__":
	main()
