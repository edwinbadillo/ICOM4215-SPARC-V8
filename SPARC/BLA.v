// Branch Logic Analyser
module BLA (output out_BLA, BA_O, BN_O, input [3:0] in,  input [3:0] flags); // still missing some arguments

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out_BLA		  : 1-bit that serves as output for the logic test
	// in			  : 4-bit bus corresponding to the condition code
	//-----------------------------------------------------------------------------------------------------------------
	wire inv0, inv1, inv2, inv3, inv_N, inv_Z, inv_V, inv_C, NV_XOR, inv_NV_XOR, inv_CZ_OR, CZ_OR;
	wire BG_O1, BG_O2, BLE_O1, BLE_O2, BGE_O1, BL_O1, BGU_O1, BLEU_O1;
	wire BNE_O, BE_O, BG_O, BLE_O, BGE_O, BL_O, BGU_O, BLEU_O, BCC_O, BCS_O, BPOS_O, BNEG_O, BVC_O, BVS_O;
 

	not (inv0, in[0]);
	not (inv1, in[1]);
	not (inv2, in[2]);
	not (inv3, in[3]);
	//{N,Z,V,C}
	not (inv_N, flags[3]);
	not (inv_Z, flags[2]);
	not (inv_V, flags[1]);
	not (inv_C, flags[0]);
	
	//XOR with N & V as inputs
	xor NVXOR(NV_XOR, flags[3], flags[1]);
	not (inv_NV_XOR, NV_XOR);
	
	//OR with C & Z as inputs
	or CZOR(CZ_OR, flags[0], flags[2]);
	not (inv_CZ_OR, CZ_OR);

	
	
	and  BA   (BA_O,  in[3], inv2, inv1, inv0);
	and  BN   (BN_O,  inv3,  inv2, inv1, inv0);
	and  BNE  (BNE_O, in[3], inv2, inv1, in[0], inv_Z);
	and  BE   (BE_O,  inv3, inv2, inv1, in[0], flags[2]);

	// BG
	and  BG_1 (BG_O1,  in[3], inv2, in[1], inv0);
	nor  BG_2 (BG_O2, NV_XOR, flags[2]);
	and  BG   (BG_O, BG_O1, BG_O2);
	
	// BLE
	and  BLE_1 (BLE_O1,  inv3, inv2, in[1], inv0);
	or   BLE_2 (BLE_O2, NV_XOR, flags[2]);
	and  BLE   (BLE_O, BLE_O1, BLE_O2);
	
	//BGE
	and  BGE_1 (BGE_O1,  in[3], inv2, in[1], in[0]);
	and  BGE (BGE_O, inv_NV_XOR, BGE_O1);

	//BL
	and  BL_1 (BL_O1,  inv3, inv2, in[1], in[0]);
	and  BL (BL_O, NV_XOR, BL_O1);
	
	//BGU
	and  BGU_1 (BGU_O1,  in[3], in[2], inv1, inv0);
	and  BGU   (BGU_O, inv_CZ_OR, BGU_O1);

	//BLEU
	and  BLEU_1 (BLEU_O1,  in[3], inv2, in[1], in[0]);
	and  BLEU   (BLEU_O, CZ_OR, BLEU_O1);

	and  BCC   (BCC_O,  in[3], in[2], inv1, in[0], inv_C);

	and  BCS   (BCS_O,  inv3, in[2], inv1, in[0], flags[0]);
	
	and  BPOS   (BPOS_O,  in[3], in[2], in[1], inv0, inv_N);
	
	and  BNEG   (BNEG_O,  inv3, in[2], in[1], inv0, flags[3]);

	and  BVC   (BVC_O,  in[3], in[2], in[1], in[0], inv_V);
	
	and  BVS   (BVS_O,   inv3, in[2], in[1], in[0], flags[1]);

	or out (out_BLA, BA_O, BN_O, BNE_O, BE_O, BG_O, BLE_O, BGE_O, BL_O, BGU_O, BLEU_O, BCC_O, BCS_O, BPOS_O, BNEG_O, BVC_O, BVS_O);
	
endmodule
