function [IDXp,IDXn] = get_layerindex(tpos,index_layer,area_type)
%UNTITLED2 Summary of this function goes here
%   obtain index separated for layers
%   area_type must be a string either 'CB', or 'AP'

if strcmp(area_type,'AP')
    % tpos already selected in the data!!
    % primary areas
    IDXp.s = index_layer.post.sup(:,tpos); % supragranular layer
    IDXp.g = index_layer.post.grn(:,tpos); % granular layer
    IDXp.i = index_layer.post.inf(:,tpos); % infragranular layer
    % non-primary areas
    IDXn.s  = index_layer.ant.sup(:,tpos); % supragranula layer
    IDXn.g  = index_layer.ant.grn(:,tpos); % granular layer
    IDXn.i  = index_layer.ant.inf(:,tpos); % infragranular layer

%     IDX_boot_post = SMI_BB_post.boot(:,i_fmi);
%     IDX_boot_ant  = SMI_BB_ant.boot(:,i_fmi);
%     
%     x_label = 'log(FSI)';
%     t_string = sTriplet{i_fmi};
elseif strcmp(area_type,'CB')
    % tpos already selected in the data!!
    % get Index value
    IDXp.s = index_layer.core.sup(:,tpos); % supragranular layer
    IDXp.g = index_layer.core.grn(:,tpos); % granular layer
    IDXp.i = index_layer.core.inf(:,tpos); % infragranular layer
    IDXn.s  = index_layer.belt.sup(:,tpos); % supragranula layer
    IDXn.g  = index_layer.belt.grn(:,tpos); % granular layer
    IDXn.i  = index_layer.belt.inf(:,tpos); % infragranular layer

%     IDX_boot_post = SMI_A_post.boot(:,i_smi);
%     IDX_boot_ant  = SMI_A_ant.boot(:,i_smi);
%     
%     x_label = 'log(CI)';
%     t_string = sTriplet{i_smi};
end

end