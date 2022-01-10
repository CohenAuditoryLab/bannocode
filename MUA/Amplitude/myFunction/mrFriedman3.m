function [p, Table, stats] = mrFriedman3(data, groups)
% This function attempts to perform an unbalanced Friedman test.
% The inputs have the same structure as ANOVAN, so look at it for
% documentation.
% This function does a two-way ANOVA, so there can only be two groups.
% Specifically, groups{1} defines the columns, and groups{2} defines the
% rows.
% The p value returned is the p value associated to the column effects.

if prod(size(data)) ~= length(data)
   error('data must be a vector');
end 

data = data(:); % make it a column vector

if (length(groups(:)) ~= 2) error('There can only be two groups (inner, outer)'); end;

outergroups = unique(groups{2});
innergroups = unique(groups{1});

sets = cell(length(innergroups),length(outergroups));

for outer=1:length(outergroups)
    for inner=1:length(innergroups)
        sets{inner,outer} = data((groups{1}==innergroups(inner)) & (groups{2}==outergroups(outer)));
    end
end

% get number of samples...
if length(sets{1,1}) ~= length(sets{2,1}) % inbalance in number of samples
%     for outer=1:length(outergroups)
% %         n_reps(outer) = length(sets{1,outer});
%         n_reps(outer) = length(data) / length(outergroups); % 55
%     end

%     for inner=1:length(innergroups)
%         n_reps(inner) = length(sets{inner,1});
%     end

    for outer=1:length(outergroups)
        for inner=1:length(innergroups)
            n_reps(inner,outer) = length(sets{inner,outer});
        end
    end
    isBalance = 0;
else
    for outer=1:length(outergroups)
            n_reps(outer) = length(sets{1,outer});
    end
    isBalance = 1;
%     for inner=1:length(innergroups)
%         n_reps(inner) = length(sets{inner,1});
%     end
end

% % get number of samples... (added by TB)
% if length(innergroups) < length(outergroups)
%     for inner=1:length(innergroups)
%         n_reps(inner) = length(sets{inner,1});
%     end
% else
%     for inner=1:length(innergroups)
%         n_reps(inner) = length(data) / length(innergroups);
%     end
% end

ranks = [];
ranks_mat = cell(1,length(outergroups));
% ranks_mat = [];
anovaGroups = [];
sumta = 0;
lens = zeros(1,length(outergroups));

anovaGroups2 = [];
for outer=1:length(outergroups)
    grouping = [];
    observations = [];

    for inner=1:length(innergroups)
        y = sets{inner,outer};
        
        grouping = [grouping; repmat(inner,length(y),1)];
        observations = [observations; y];
    end
    anovaGroups2 = [anovaGroups2; repmat(outer,length(observations),1)];

    % this is the estimated number of repetitions per group (inner and outer)
    % this is then used as the normalization factor to adjust all of the
    % ranks by, so that ranks are effectively between >0 and # of columns (inner).
    len = length(observations)/length(innergroups);
    lens(outer) = len;

    if (~isempty(observations))
        [r,tieadj] = tiedrank(observations);
%         ranks = [ranks, r/len];
        ranks = [ranks; r/len]; % modified by TB
        sumta = sumta + 2*tieadj;
   
        anovaGroups = [anovaGroups; grouping];
        
%         disp(length(observations));
        if isBalance == 0
            ranks_mat{outer} = [ranks_mat{outer}, r/len];
        elseif isBalance == 1
%             temp = reshape(r/len,n_reps(outer),5);
            temp = reshape(r/len,n_reps(outer),size(sets,1));
            ranks_mat = [ranks_mat; temp];
            clear temp
        end
    end
end

c = length(innergroups);
r = length(outergroups);
% reps = mean(lens); % get an estimate of the number of repititions per row per column

% weighted average (doesn't make any difference...)
nn = sum(n_reps,1);
reps = (lens * nn') / sum(nn);

% change the pseudo-ranks back into something that more resembles ranks, i.e.
% between >0 and # reps * # columns
ranks = ranks*reps;
% ranks_mat = ranks_mat*reps;
for outer=1:r
    ranks_mat{outer} = ranks_mat{outer}*reps;
end

% get mean... (added by TB)
if isBalance==0
%     temp_ranks = ranks_mat;
%     for i=1:length(n_reps)
%         temp = temp_ranks(1:n_reps(i),:);
%         m(i) = mean(temp(:));
%         temp_ranks(1:n_reps(i),:) = [];
%     end
    
    M = cell(1,length(innergroups));
    for outer=1:length(outergroups)
        temp_ranks = ranks_mat{1,outer};
        for inner=1:length(innergroups)
            temp = temp_ranks(1:n_reps(inner,outer),:);
            M{inner} = [M{inner}; temp];
            temp_ranks(1:n_reps(inner,outer),:) = [];
        end
    end
    for inner=1:length(innergroups)
        m(inner) = mean(M{inner});
    end
elseif isBalance==1
    m = mean(ranks_mat,1);
end

% Perform anova but don't display the table
% ranks = ranks(:); % added by TB
[p0,Table] = anovan(ranks,{anovaGroups},'linear',3,[],'off');
% [p0,Table] = anovan(ranks,{anovaGroups anovaGroups2},'full',3,[],'off');

% Everything below was taken directly from the Friedman.m file

% Compute Friedman test statistic and p-value
chistat = Table{2,2};
sigmasq = c*reps*(reps*c+1) / 12;
if (sumta > 0)
   sigmasq = sigmasq - sumta / (12 * r * (reps*c-1));
end
if (chistat > 0)
   chistat = chistat / sigmasq;
end
p = 1 - chi2cdf(chistat, c-1);

Table(3,:) = [];                    % remove row info
if (reps>1), Table{3,5} = []; Table{3,6} = []; end % remove interaction test
Table{1,5} = 'Chi-sq';              % fix test statistic name
Table{2,5} = chistat;               % fix test statistic value
Table{1,6} = 'Prob>Chi-sq';         % fix p-value name
Table{2,6} = p;                     % fix p-value value

if (nargout > 2)
   stats.source = 'friedman';
   stats.n = r;
%   stats.meanranks = mean(m);
   stats.meanranks = m; % added by TB
   stats.sigma = sqrt(sigmasq);
end