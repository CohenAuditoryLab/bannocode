sevpath = 'C:\TDT\Synapse\Tanks\Domo-180813-182551';
% sevpath = 'C:\TDT\Synapse\Tanks\Domo-181210';
% list_files = {'20180709_ABBA_d02','20180711_ABBA_d01', ...
%     '20180807_ABBA_d01','20180820_ABBAl_d03','20180821_ABBAl_d01','20180822_ABBAl_d01', ...
%     '20180823_ABBAl_d01','20180827_ABBAl_d01','20180829_ABBAl_d01','20180905_ABBAl_d01', ...
%     '20180907_ABBA_d01'};
list_files = {'20180905_ABBAl_d01','20180907_ABBA_d01'};

for i=1:numel(list_files)
    % block = '20180711_ABBA_d01';
    block = list_files{i};
    fdest = block(1:8);
    method = 'median';
    
    pre_process_v2(sevpath,block,fdest,method);
end