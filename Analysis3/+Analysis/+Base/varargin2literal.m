function [ vail ] = varargin2literal( vai )
%VARARGIN2LITERAL Summary of this function goes here
%   Detailed explanation goes here

vail = '';
for i=1:length(vai)
    vail = [vail,',','varargin{',num2str(i),'}'];
end

end

