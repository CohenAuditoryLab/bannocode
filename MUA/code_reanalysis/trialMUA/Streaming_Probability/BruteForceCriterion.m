function [Criterion, FlipFlag]=BruteForceCriterion(s,n,debug)

 

if nanmean(s)>nanmean(n)
  FlipFlag=0;
  a=s;
  b=n;
else
  FlipFlag=1;
  a=n;
  b=s;
end
MinValue=floor(min([a b]));
MaxValue=floor(max([a b]));

 
Range=MinValue:1:MaxValue; 

Index=[];
for r=1:length(Range)
  fooa=length(find(a>=Range(r)))/length(a); 
  foob=length(find(b<=Range(r)))/length(b); 
  Index(r)=(fooa-foob)/(fooa+foob);
end

NumberWantToBeClosestTo=0;
tmp = abs(Index-NumberWantToBeClosestTo);
[idx idx] = min(tmp); %index of closest value
Criterion = Range(idx); %closest value

 
if(debug)
  figure(666); clf;
  hist(s); hold on;
  hist(n); hold on;
  legend({'a' 'b'})

  h=get(gca);
  yl=h.YLim;
  plot([Criterion Criterion],yl,'k-','linewidth',5)

 
  figure(667);clf;plot(Range,Index,'.');ylim([-1.5 1.5])
  hold on; plot([Range(1) Range(end)], [0 0],'k-','linewidth',5)
  plot([Criterion Criterion],[-1 1],'k-','linewidth',5)
end