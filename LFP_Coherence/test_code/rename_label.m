function [label] = rename_label(label_ori,AC_or_PFC,nStart)

nCh = numel(label_ori); % number of channel
label = cell(nCh,1);
j = 1;
for i=nStart:nCh+nStart-1
    if i<10
        string = strcat(AC_or_PFC,'0',num2str(i));
    else
        string = strcat(AC_or_PFC,num2str(i));
    end
    label{j} = string;
    j = j + 1;
end


end