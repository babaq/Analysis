function [ fp,tdots ] = randtransDP( dots,ir,overlaperror,pushscale )
%RANDTRANSDP Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    ir = 0.5;
    overlaperror = 30; % Arcmin
    pushscale = 0.1;
elseif nargin < 3
    overlaperror = 30; % Arcmin
    pushscale = 0.1;
elseif nargin < 4
    pushscale = 0.1;
end

    function fp = randfp(ir)
        fp = zeros(1,2);
        for i=1:2
            while true
                fp(i) = rand*2-1;
                if abs(fp(i)) >= ir
                    break;
                end
            end
        end
    end

    function [isv,fp,dots] = testfp(fp,dots,error,epf,ps)
        [c,r] = minboundcircle(dots(:,1),dots(:,2));
        fp = fp*r*epf+c;
        ed = @(p1,p2)sqrt(sum((p2-p1).^2));
        isv = true;
        dots(:,1) = dots(:,1)-c(1)-fp(1)*ps;
        dots(:,2) = dots(:,2)-c(2)-fp(2)*ps;
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
    
    [isv,fp,tdots] = testfp(randfp(ir),dots,overlaperror,epf,pushscale);
    if isv
        break;
    end
    iteration = iteration + 1;
end

end

