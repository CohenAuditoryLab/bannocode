function [IDX] = reshapeSMIBMI(index_LayerArea)
% reshape SMIBMI_LayerArea.mat
% clear all;

% load SMIBMI_LayerArea_emergence
% import SMI_LayerArea and BMI_LayerArea
% they are cell array of area x layer x ABB

% ABB = 1; % A -- 1, B1 -- 2, B2 -- 3
for ABB=1:3
    % core
    idx_sup.core  = index_LayerArea{1,1,ABB};
    idx_gran.core = index_LayerArea{1,2,ABB};
    idx_deep.core = index_LayerArea{1,3,ABB};
    % smi_sup.core = SMI_LayerArea{1,1,ABB};
    % smi_gran.core = SMI_LayerArea{1,2,ABB};
    % smi_deep.core = SMI_LayerArea{1,3,ABB};
    % bmi_sup.core = BMI_LayerArea{1,1,ABB};
    % bmi_gran.core = BMI_LayerArea{1,2,ABB};
    % bmi_deep.core = BMI_LayerArea{1,3,ABB};

    % belt
    idx_sup.belt  = index_LayerArea{2,1,ABB};
    idx_gran.belt = index_LayerArea{2,2,ABB};
    idx_deep.belt = index_LayerArea{2,3,ABB};
    % smi_sup.belt = SMI_LayerArea{2,1,ABB};
    % smi_gran.belt = SMI_LayerArea{2,2,ABB};
    % smi_deep.belt = SMI_LayerArea{2,3,ABB};
    % bmi_sup.belt = BMI_LayerArea{2,1,ABB};
    % bmi_gran.belt = BMI_LayerArea{2,2,ABB};
    % bmi_deep.belt = BMI_LayerArea{2,3,ABB};

    if ABB==1
        IDX.A.sup  = idx_sup;
        IDX.A.gran = idx_gran;
        IDX.A.deep = idx_deep;
        %     SMI.A.sup  = smi_sup;
        %     SMI.A.gran = smi_gran;
        %     SMI.A.deep = smi_deep;
        %     BMI.A.sup  = bmi_sup;
        %     BMI.A.gran = bmi_gran;
        %     BMI.A.deep = bmi_deep;
        clear smi_sup smi_gran smi_deep bmi_sup bmi_gran bmi_deep
    elseif ABB==2
        IDX.B1.sup  = idx_sup;
        IDX.B1.gran = idx_gran;
        IDX.B1.deep = idx_deep;
        %     SMI.B1.sup  = smi_sup;
        %     SMI.B1.gran = smi_gran;
        %     SMI.B1.deep = smi_deep;
        %     BMI.B1.sup  = bmi_sup;
        %     BMI.B1.gran = bmi_gran;
        %     BMI.B1.deep = bmi_deep;
        clear smi_sup smi_gran smi_deep bmi_sup bmi_gran bmi_deep
    elseif ABB==3
        IDX.B2.sup  = idx_sup;
        IDX.B2.gran = idx_gran;
        IDX.B2.deep = idx_deep;
        %     SMI.B2.sup  = smi_sup;
        %     SMI.B2.gran = smi_gran;
        %     SMI.B2.deep = smi_deep;
        %     BMI.B2.sup  = bmi_sup;
        %     BMI.B2.gran = bmi_gran;
        %     BMI.B2.deep = bmi_deep;
        clear smi_sup smi_gran smi_deep bmi_sup bmi_gran bmi_deep
    end
end

end