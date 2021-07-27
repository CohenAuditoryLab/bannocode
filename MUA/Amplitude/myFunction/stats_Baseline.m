function [ h, p ] = stats_Baseline( sigRESP_area )
%stats_SessionSummary Summary of this function goes here
%   perform pairwise comparison of baseline activity in hit and miss trials
%   

alpha = 0.05; % significance level
dh = permute(sigRESP_area(:,1,1,:),[1 4 2 3]); % hit [-575 -500]
dm = permute(sigRESP_area(:,1,2,:),[1 4 2 3]); % miss [-575 -500]
ih = permute(sigRESP_area(:,2,1,:),[1 4 2 3]); % hit [-75 0]
im = permute(sigRESP_area(:,2,2,:),[1 4 2 3]); % miss [-75 0]

% pairwise comparison of hit vs miss trials
[h(1),p(1)] = ttest(dh(:),dm(:),'alpha',alpha); %[-575 -500]
[h(2),p(2)] = ttest(ih(:),im(:),'alpha',alpha); %[-75 0]

end

