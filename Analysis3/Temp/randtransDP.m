function [ fp,tdots ] = randtransDP( dots,ir,overlaperror )
%RANDTRANSDP Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    ir = 0.5;
    overlaperror = 0.05;
elseif nargin < 3
    overlaperror = 0.05;
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

    function [isv,fp,dots] = testfp(fp,dots,error)
        [c,r] = minboundcircle(dots(:,1),dots(:,2));
        fp = fp*r+c;
        ed = @(p1,p2)sqrt(sum((p2-p1).^2));
        isv = true;
        dots(:,1) = dots(:,1)-fp(1);
        dots(:,2) = dots(:,2)-fp(2);
        for i=1:size(dots,1)
            d = ed(fp,dots(i,:));
            if d < error
                isv = false;
                break;
            end
        end
    end

while true
    [isv,fp,tdots] = testfp(randfp(ir),dots,overlaperror);
    if isv
        break;
    end
end

end

