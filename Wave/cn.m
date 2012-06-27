function c = cn(x,type,xsd)
% cn.m
% 2011-04-27 by Zhang Li
% Response Change Normalization

if nargin < 2
    type = 'a';
end
stin = size(x,2);

if strcmp(type,'n')
    cmin = min(min(x));
    c = x-cmin;
    cmax = max(max(c));
    c = c/cmax;
else
    % absolute change
    for i = 1:stin
        c(:,i) = x(:,i)-x(:,1);
    end
    acmax = max(abs(c),[],2);
    for i = 1:stin
        % relative change
        if strcmp(type,'r')
            c(:,i) = c(:,i)./x(:,1);
        end
        % Z Score
        if strcmp(type,'z') && ~isempty(xsd)
            c(:,i) = c(:,i)./xsd(:,1);
        end
        % absolute change normalization
        if strcmp(type,'an')
%             c(:,i) = c(:,i)./(acmax(:,1)-x(:,1));
            c(:,i) = c(:,i)./acmax(:,1);
        end
    end
end

