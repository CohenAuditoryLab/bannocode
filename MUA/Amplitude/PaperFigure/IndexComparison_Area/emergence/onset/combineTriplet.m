function [ R_ABB ] = combineTriplet( R_struct )
% get the struct data with the fields of A, B1 and B2
% combine them in the order of tone burst (ABB-ABB-...)

% the data should be a matrix of 
% channel x dF x hit-miss x session x tpos
rA  = R_struct.A;
rB1 = R_struct.B1;
rB2 = R_struct.B2;

nTpos = size(rA,5);
R_ABB = [];
for i=1:nTpos
    R_ABB = cat(5,R_ABB,rA(:,:,:,:,i));
    R_ABB = cat(5,R_ABB,rB1(:,:,:,:,i));
    R_ABB = cat(5,R_ABB,rB2(:,:,:,:,i));
end

end