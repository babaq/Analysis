function [ fp,tdots ] = randtransDP( dots,ir,overlaperror,pushscale,dprandr )
%RANDTRANSDP Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    ir = 0.5;
    overlaperror = 30; % Arcmin
    pushscale = 0.1;
    dprandr = 0.1;
elseif nargin < 3
    overlaperror = 30; % Arcmin
    pushscale = 0.1;
    dprandr = 0.1;
elseif nargin < 4
    pushscale = 0.1;
    dprandr = 0.1;
elseif nargin < 5
    dprandr = 0.1;
end

    function fp = randfp(ir,or)
        fp = zeros(1,2);
        for i=1:2
            while true
                fp(i) = rand*2-1;
                t = abs(fp(i));
                if (t >= ir) && (t <= or)
                    break;
                end
            end
        end
    end

    function [isv,fp,dots] = testfp(fp,dots,error,epf,ps,dprr)
        [c,r] = minboundcircle(dots(:,1),dots(:,2));
        dpr = randfp(0,dprr)*r;
        fp = fp*r*epf+dpr;
        ed = @(p1,p2)sqrt(sum((p2-p1).^2));
        isv = true;
        dots(:,1) = dots(:,1)-c(1)+dpr(1)-fp(1)*ps;
        dots(:,2) = dots(:,2)-c(2)+dpr(2)-fp(2)*ps;
        for i=1:size(dots,1)
            d = ed(fp,dots(i,:));
            if d < error
                isv = false;
                break;
            end
        end
    end

maxepf = 1/ir;
iteration = 1;
maxiteration = 100;
epf = 1;
epfstep = (maxepf-1)/maxiteration;
while true
    if iteration > maxiteration
        epf = 1 + (iteration-maxiteration)/maxiteration*epfstep;
    elseif iteration > 2*maxiteration
        error('Can not find valid random translation of Dots and Fixation Point.');
    end
    
    [isv,fp,tdots] = testfp(randfp(ir,1),dots,overlaperror,epf,pushscale,dprandr);
    if isv
        break;
    end
    iteration = iteration + 1;
end

end

