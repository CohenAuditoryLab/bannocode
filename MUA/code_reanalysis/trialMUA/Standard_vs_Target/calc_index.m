function [index] = calc_index(Resp)
% Resp must be a matrix sample x tpos (T-1 and T)

% rectivication
Resp(Resp<0) = 0;

R_Tm1 = Resp(:,1);
R_T   = Resp(:,2);

% calculate index
index = (R_T - R_Tm1) ./ (R_T + R_Tm1);


end