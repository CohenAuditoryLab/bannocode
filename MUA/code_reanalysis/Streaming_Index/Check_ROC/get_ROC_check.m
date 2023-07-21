function [AUC,curve] = get_ROC_check(rA,rB,version)
%UNTITLED Summary of this function goes here
%   calculate area under ROC curve for slight different data structure
%   rA -- MUA response to A tone (ch x easy-hard x hit-miss x tpos)
%   rB -- MUA response to B tone (ch x easy-hard x hit-miss x tpos)
%   version -- choose function to use, 1 for perfcurve.m, 2 for roc_curve.m
%   just for checking whether perfcurve.m works properly...

Ahh = squeeze(rA(:,1,1,:)); % hard-hit
Aeh = squeeze(rA(:,2,1,:)); % easy-hit
Ahm  = squeeze(rA(:,1,2,:)); % hard-miss
Aem = squeeze(rA(:,2,2,:)); % easy_miss

Bhh = squeeze(rB(:,1,1,:)); % hard-hit
Beh = squeeze(rB(:,2,1,:)); % easy-hit
Bhm  = squeeze(rB(:,1,2,:)); % hard-miss
Bem = squeeze(rB(:,2,2,:)); % easy_miss

% Ahit = Ahh + Aeh; Amiss = Ahm + Aem;
% Bhit = Bhh + Beh; Bmiss = Bhm + Bem;
% Ahard = Ahh + Ahm; Aeasy = Aeh + Aem;
% Bhard = Bhh + Bhm; Beasy = Beh + Bem;

Ahit = cat(1,Ahh,Aeh); Amiss = cat(1,Ahm,Aem);
Bhit = cat(1,Bhh,Beh); Bmiss = cat(1,Bhm,Bem);
Ahard = cat(1,Ahh,Ahm); Aeasy = cat(1,Aeh,Aem);
Bhard = cat(1,Bhh,Bhm); Beasy = cat(1,Beh,Bem);

[AUC.hard, curve.hard] = calc_AUC(Ahard,Bhard,version);
[AUC.easy, curve.easy] = calc_AUC(Aeasy,Beasy,version);
[AUC.hit,  curve.hit ]= calc_AUC(Ahit,Bhit,version);
[AUC.miss, curve.miss]= calc_AUC(Amiss,Bmiss,version);

% further separation of conditions
[AUC.hh, curve.hh] = calc_AUC(Ahh,Bhh,version);
[AUC.hm, curve.hm] = calc_AUC(Ahm,Bhm,version);
[AUC.eh, curve.eh] = calc_AUC(Aeh,Beh,version);
[AUC.em, curve.em] = calc_AUC(Aem,Bem,version);
end



function [AUC,curve] = calc_AUC(rA_condition,rB_condition,version)
% % reshape matrix (no need for reshape matrix)
% rsA = reshape(rA_condition,size(rA_condition,1)*size(rA_condition,2),size(rA_condition,3));
% rsB = reshape(rB_condition,size(rB_condition,1)*size(rB_condition,2),size(rB_condition,3));
rsA = rA_condition;
rsB = rB_condition;

% normalize MUA
nTpos = size(rsA,2);
maxA = max(abs(rsA),[],2);
maxB = max(abs(rsB),[],2);
maxAB = max([maxA maxB],[],2);
Mmat = maxAB * ones(1,nTpos);
normA = rsA ./ Mmat;
normB = rsB ./ Mmat;

% ROC analysis
nBoot = 0; 
for i=1:nTpos % choose tpos
    A = rsA(:,i); A = A(~isnan(A)); % remove NaN
    B = rsB(:,i); B = B(~isnan(B)); % remvoe NaN
    % A = normA(:,i); A = A(~isnan(A));
    % B = normB(:,i); B = B(~isnan(B));
    label_A = zeros(length(A),1);
    label_B = ones(length(B),1);
    scores = [A;B];
    labels = logical([label_A;label_B]);
    if version==1
        % ROC analysis
        [X,Y,~,AUC(i,:)] = perfcurve(labels,scores,0,'NBoot',nBoot,'BootType','bca','Alpha',0.05);
        curve(:,:,i) = [X Y];
    elseif version==2
        % ROC analysis version 2
        ROC_data = roc_curve(B,A,0,0);
        AUC(i,:) = ROC_data.param.AROC;
        cv = ROC_data.curve;
        X = 1-cv(:,2);
        Y = cv(:,1);
        curve(:,:,i) = [X,Y];
    end
end


end