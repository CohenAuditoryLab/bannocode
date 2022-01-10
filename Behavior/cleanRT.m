function [cleanRT] = cleanRT(RT,rt_range)
    RT(RT<rt_range(1)) = [];
    RT(RT>rt_range(2)) = [];
    
    cleanRT = RT;
end