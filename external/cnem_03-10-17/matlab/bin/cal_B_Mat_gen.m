% Copyright (C) 2003-2011
% Lounes ILLOUL (illoul_lounes@yahoo.fr)
% Philippe LORONG (philippe.lorong@ensam.eu)
% Nicolas RANC
% Arts et Metiers ParisTech, Paris, France

function B_Gen=cal_B_Mat_gen(B,Mat_Var1_to_Var2)

B_Gen=sparse_block(Mat_Var1_to_Var2,size(Mat_Var1_to_Var2,1),size(B,1)/size(Mat_Var1_to_Var2,2))*B;
