function [smMUA,smT] = smoothMUAb(MUA,T,points)
%UNTITLED Summary of this function goes here
%   smoothing MUA for display...

% points = 250; % 01/04/22 number increased for further smoothing

%MeanRectMUA:
rows = size(MUA,1);
columns = size(MUA,2);
% dim3 = size(MUA,3);
% smMUA = MUA;
for c=1:columns
    for r=(points+1):rows-(points+1) %start at row #points+1 and ends at row #end-(points+1) for n-point average smooth
%         MeanRectMUA(r,c)=mean(MeanRectMUA(r-points:r+points,c)); %n-point average smooth
%         for d=1:dim3
            smMUA(r,c)=mean(MUA(r-points:r+points,c)); %n-point average smooth
%         end
    end
end

smMUA(1:points,:,:) = [];
% smT = T(:,ceil((points+1)/2):rows-ceil((points+1)/2));
smT = T(:,(points+1):(rows-(points+1)));

clear c r;

end