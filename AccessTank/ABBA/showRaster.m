function hh = showRaster(x, y, l, u)
% rasterplot by koida(03.06.22)
%   x:  データ
%   y:  データ（xと同じサイズのこと）
%   l:  各点の長さ
%   u:  スペック。色のみ有効　例：　k　→　黒



if nargin == 3
    if ~isstr(l)  
        u = l;
        symbol = '-';
    else
        symbol = l;
        l = y;
        u = y;
        y = x;
        [m,n] = size(y);
        x(:) = (1:npt)'*ones(1,n);
    end
end

if nargin == 4
    if isstr(u),    
        symbol = u;
        u = l;
    else
        symbol = '-';
    end
end


if nargin == 2
    l = y;
    u = y;
    y = x;
    [m,n] = size(y);
    x(:) = (1:npt)'*ones(1,n);;
    symbol = '-';
end


if nargin ==1
    error('need X and Y data')	
end



u = abs(u(1));
l = abs(l);
    
if isstr(x) | isstr(y) | isstr(u) | isstr(l)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) ,
  error('The sizes of X and Y must be the same.');
end


x=x(:);
y=y(:);
npt=length(x);

ytop = y + u/2;
ybot = y - u/2;



% build up nan-separated vector for bars
xb = zeros(npt*3,1);
xb(1:3:end) = x;
xb(2:3:end) = x;
xb(3:3:end) = NaN;

yb = zeros(npt*3,1);
yb(1:3:end) = ytop;
yb(2:3:end) = ybot;
yb(3:3:end) = NaN;


[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
esymbol = ['-' col]; % Make sure bars are solid

h = plot(xb,yb,esymbol);

if nargout>0, hh = h; end
