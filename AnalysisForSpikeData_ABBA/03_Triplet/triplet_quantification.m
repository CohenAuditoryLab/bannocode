function [ index ] = triplet_quantification( A, B1, B2 )
%triplet_quantification Summary of this function goes here
%   Given the spike count for each triplet stimulus (ABB), the function
%   calculate d' comparing response between narrow and wide semitone
%   difference condition (d_stream), d' comparing the respons to A and B2
%   (d_freq), and Fano factor (F). the input must be a struct having the
%   firld of mean and var

A_m = A.mean; A_v = A.var;
B1_m = B1.mean; B1_v = B1.var;
B2_m = B2.mean; B2_v = B2.var;

% stream selectivity
d_stream(:,1) = ( A_m(:,1) - A_m(:,end) ) ./ sqrt( ( A_v(:,1) + A_v(:,end) ) / 2 );
d_stream(:,2) = ( B1_m(:,1) - B1_m(:,end) ) ./ sqrt( ( B1_v(:,1) + B1_v(:,end) ) / 2 );
d_stream(:,3) = ( B2_m(:,1) - B2_m(:,end) ) ./ sqrt( ( B2_v(:,1) + B2_v(:,end) ) / 2 );
% frequency selectivity
d_fselec1 = ( A_m - B1_m ) ./ sqrt( ( A_v + B1_v ) / 2 );
d_fselec2 = ( A_m - B2_m ) ./ sqrt( ( A_v + B2_v ) / 2 );
% Fano factor
F(:,:,1) = A_v ./ A_m;
F(:,:,2) = B1_v ./ B1_m;
F(:,:,3) = B2_v ./ B2_m;

i_stream(:,1) = ( A_m(:,1) - A_m(:,end) ) ./ ( A_m(:,1) + A_m(:,end) );
i_stream(:,2) = ( B1_m(:,1) - B1_m(:,end) ) ./ ( B1_m(:,1) + B1_m(:,end) );
i_stream(:,3) = ( B2_m(:,1) - B2_m(:,end) ) ./ ( B2_m(:,1) + B2_m(:,end) );

i_fselec1 = ( A_m - B1_m ) ./ ( A_m + B1_m );
i_fselec2 = ( A_m - B2_m ) ./ ( A_m + B2_m );

% combine data for output
index = struct('d_stream',d_stream,'d_fselec1',d_fselec1,'d_fselec2',d_fselec2,'Fano',F, ...
               'i_stream',i_stream,'i_fselec1',i_fselec1,'i_fselec2',i_fselec2);
end

