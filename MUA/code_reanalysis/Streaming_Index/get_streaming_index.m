function [iStream] = get_streaming_index(rA,rB)
%UNTITLED Summary of this function goes here
%   calculate streaming index A / ( A + B )
%   rA -- MUA response to A tone
%   rB -- MUA response to B tone

Ahh = squeeze(rA(:,1,1,:,:)); % hard-hit
Aeh = squeeze(rA(:,2,1,:,:)); % easy-hit
Ahm  = squeeze(rA(:,1,2,:,:)); % hard-miss
Aem = squeeze(rA(:,2,2,:,:)); % easy_miss

Bhh = squeeze(rB(:,1,1,:,:)); % hard-hit
Beh = squeeze(rB(:,2,1,:,:)); % easy-hit
Bhm  = squeeze(rB(:,1,2,:,:)); % hard-miss
Bem = squeeze(rB(:,2,2,:,:)); % easy_miss

% Ahit = Ahh + Aeh; Amiss = Ahm + Aem;
% Bhit = Bhh + Beh; Bmiss = Bhm + Bem;
% Ahard = Ahh + Ahm; Aeasy = Aeh + Aem;
% Bhard = Bhh + Bhm; Beasy = Beh + Bem;

Ahit = cat(1,Ahh,Aeh); Amiss = cat(1,Ahm,Aem);
Bhit = cat(1,Bhh,Beh); Bmiss = cat(1,Bhm,Bem);
Ahard = cat(1,Ahh,Ahm); Aeasy = cat(1,Aeh,Aem);
Bhard = cat(1,Bhh,Bhm); Beasy = cat(1,Beh,Bem);

Ahh(Ahh<0) = 0; Ahm(Ahm<0) = 0;
Bhh(Bhh<0) = 0; Bhm(Bhm<0) = 0;
Aeh(Aeh<0) = 0; Aem(Aem<0) = 0;
Beh(Beh<0) = 0; Bem(Bem<0) = 0;

Ahit(Ahit<0) = 0; Amiss(Amiss<0) = 0;
Bhit(Bhit<0) = 0; Bmiss(Bmiss<0) = 0;
Ahard(Ahard<0) = 0; Aeasy(Aeasy<0) = 0;
Bhard(Bhard<0) = 0; Beasy(Beasy<0) = 0;

% calculate index
iStream_hit  = Ahit ./ (Ahit + Bhit);
iStream_miss = Amiss ./ (Amiss + Bmiss);
iStream_hard = Ahard ./ (Ahard + Bhard);
iStream_easy = Aeasy ./ (Aeasy + Beasy);

% further separation of conditions
iStream_hh = Ahh ./ (Ahh + Bhh);
iStream_hm = Ahm ./ (Ahm + Bhm);
iStream_eh = Aeh ./ (Aeh + Beh);
iStream_em = Aem ./ (Aem + Bem);

I = iStream_hit ./ iStream_miss;
II = iStream_hm ./ iStream_hm;

% reshape the data for output
size_reshape = [size(I,1)*size(I,2) size(I,3)];
iStream.hit  = reshape(iStream_hit,size_reshape);
iStream.miss = reshape(iStream_miss,size_reshape);
iStream.hard = reshape(iStream_hard,size_reshape);
iStream.easy = reshape(iStream_easy,size_reshape);

size_reshape = [size(II,1)*size(I,2) size(I,3)];
iStream.hh = reshape(iStream_hh,size_reshape);
iStream.hm = reshape(iStream_hm,size_reshape);
iStream.eh = reshape(iStream_eh,size_reshape);
iStream.em = reshape(iStream_em,size_reshape);
end