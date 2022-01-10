function [ R_ABB ] = combineTriplet2( R_struct )
% get the struct data with the fields of A, B1 and B2
% combine ABB triplet into a data from a triplet 

% the data should be a matrix of 
% channel x dF x hit-miss x session x tpos
rA  = R_struct.A;
rB1 = R_struct.B1;
rB2 = R_struct.B2;

% nTpos = size(rA,5);
R_ABB = [];
R_ABB = cat(1,R_ABB,rA);
R_ABB = cat(1,R_ABB,rB1);
R_ABB = cat(1,R_ABB,rB2);
% for i=1:nTpos
%     R_ABB = cat(5,R_ABB,rA(:,:,:,:,i));
%     R_ABB = cat(5,R_ABB,rB1(:,:,:,:,i));
%     R_ABB = cat(5,R_ABB,rB2(:,:,:,:,i));
% end

end