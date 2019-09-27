# QuantumSqRoot

=============================

Written by Srijit Dutta and Yaswanth Tavva, as part of internship at HESL, Nanyang Technological Unversity, Singapore. The default algorithm is described in the paper, 
`
@inproceedings{dutta2020,
  title={Efficient Quantum Circuits for Square-Root and Inverse Square-Root"},
  author={Srijit Dutta, Yaswanth Tavva, Debjyoti Bhattacharjee and Anupam Chattopadhyay},
  booktitle={33rd International Conference on VLSI Design},
  year={2020},
  organization={IEEE}
}
`


We kindly request that anyone using this code to acknowledge this repository and/or the paper on which it is based in their work.


USAGE
-----------------------------

`python3 FixedPoint_InvSqRoot_Generator.py`

`python3 FixedPoint_SqRoot_Generator.py`


DESCRIPTION
-----------------------------
The python programs FixedPoint_InvSqRoot_Generator.py and FixedPoint_SqRoot_Generator.py generate verilog files for (inv) square root computation of fixed point 'm.n' format with 'k' iterations where the parameters are input by the user.

IEEE_InvSqRoot.v and IEEE_SqRoot.v contain the verilog implementations of (inv) square root computation for IEEE-754 format.

Manual implementations of Cuccaro Adder and Multiplier are present in the Manual directory.

Scripts directory has the following :
1. blif_to_aig.sh - Convert  blif to aiger using aiger tool
2. v_to_blif.sh - Convert verilog to blif using yosys tool 
3. esop.sh - Synthesis commands for ESOP
4. fs.sh - Synthesis commands for Functional synthesis
5. hs.sh - Synthesis commands for Heirarchical synthesis
6. lhrs.sh - Synthesis commands for LHRS
