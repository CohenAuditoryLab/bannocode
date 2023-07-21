function [smi,bmi] = calc_Index(Rmatrix)
Rhh = Rmatrix(:,1);
Reh = Rmatrix(:,2);
Rhm = Rmatrix(:,3);
Rem = Rmatrix(:,4);

% stimulus and behavioral modulation index (withoug normalization)
smi = abs( Rhh - Reh ) + abs( Rhm - Rem ); % modulation by stimulus frequency
bmi =  ( Rhh - Rhm ) + ( Reh - Rem ); % modulation by behavioral outocme

% log transformation to make the distribution normal
smi = smi(smi>0);
smi = log2(smi); % only for dStim...

% mean
smi = mean(smi,1);
bmi = mean(bmi,1);
end