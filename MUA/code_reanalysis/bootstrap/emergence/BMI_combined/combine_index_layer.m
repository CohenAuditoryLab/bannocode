function cIndex = combine_index_layer(index_p,index_n)
%UNTITLED5 Summary of this function goes here
%   combine index values (CI, FSI, or BMI) into struct for the statistical
%   analysis of laminar comparison
%   index_p -- struct of index value from primary auditory cortex must have
%   the field s, g and i for supuragranular, granular and infragranular
%   layers
%   index_n -- struct of index value from non-primary auditory cortex.
%   structure must be the same as index_p

cIndex.sup.core  = index_p.s;
cIndex.gran.core = index_p.g;
cIndex.deep.core = index_p.i;
cIndex.sup.belt  = index_n.s;
cIndex.gran.belt = index_n.g;
cIndex.deep.belt = index_n.i;

end