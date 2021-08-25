function [sigRESP_reshape] = reshapeMatrix_for_comp(sigRESP)
%UNTITLED4 Summary of this function goes here
%   function reshape the matrix structure for statistical comparison
%   between hit and mess trial of Target responses (as a function of target
%   position)
%   input must have channel x tpos x hit-miss x session

% dimension of output matrix...
size_reshape = [size(sigRESP,1) * size(sigRESP,4) size(sigRESP,2)];

R_hit  = permute(sigRESP(:,:,1,:),[1 4 2 3]);
R_miss = permute(sigRESP(:,:,2,:),[1 4 2 3]);

sigRESP_reshape(:,:,1) = reshape(R_hit,size_reshape);
sigRESP_reshape(:,:,2) = reshape(R_miss,size_reshape);

end

