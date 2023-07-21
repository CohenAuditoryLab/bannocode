function [sl_index,sp_index] = calc_SLSPindex(R_Atone,R_Btone,ver)
% caluculate selectivity index and sparseness index
% R_Atone and R_Btone must be a matrix (Ch x tpos x stdiff)
% sl_index -- selectivity index compareing preferred vs non-preferred resp
% sp_index -- sparseness index (cf. Vinje and Gallant, 2000)
% both index gives NaN when no response at all (0/0 = NaN)
% ver -- specify version to choose the way to calculate selectivity index
% version 1: compare L tone vs H tone with largest dF
% version 2: compare tones that gives maximum and minimum

R = cat(3,R_Atone,R_Btone);
n_ch = size(R,1); % number of channel
n_tpos = size(R,2); % number of tpos
n_level = size(R,3); % number of different frequency

for ii = 1:n_ch
    for jj = 1:n_tpos
        R_temp = squeeze(R(ii,jj,:));
        if jj==1
            % get preferred and non-preferred stimulus
            i = 1:length(R_temp);
            iP = i(R_temp==max(R_temp)); % preferred stimulus
            iN = i(R_temp==min(R_temp)); % non-preferred stimulus
        end

        % rectification
        R_temp(R_temp<0) = 0;

        % get selectivity index
        %         sl_index(ii,jj) = (R_temp(iP) - R_temp(iN)) / (R_temp(iP) + R_temp(iN));
        if ver==1
            % version 1: set L to pref, H in largest dF to non-pref
            sl_index(ii,jj) = calc_selectivity_index(R_temp,1,length(R_temp));
        elseif ver==2
            % version 2: define pref and non-pref for each MUA
            sl_index(ii,jj) = calc_selectivity_index(R_temp,iP,iN);
        end

        % get sparseness index
        sp_index(ii,jj) = calc_sparseness_index(R_temp);
        % sq_mR = mean(R_temp) ^ 2; % square of mean
        % m_sqR = mean( R_temp .^ 2 ); % mean of square
        % sp_index = (1 - sq_mR/m_sqR ) / (1 - 1/n_level);

        clear R_temp
    end
    clear i iP iN
end

end

% % % define function to calculate selectivity index % % % 
function sel_index = calc_selectivity_index(r,iP,iN)
sel_index = (r(iP) - r(iN)) / (r(iP) + r(iN));
end


% % % define function to calculate sparseness index % % % 
function sp_index = calc_sparseness_index(r)
n_level = length(r);
sq_mR = mean(r) ^ 2; % square of mean
m_sqR = mean( r .^ 2 ); % mean of square
sp_index = (1 - sq_mR/m_sqR ) / (1 - 1/n_level);
end