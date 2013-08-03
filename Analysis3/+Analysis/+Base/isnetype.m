function [ hr ] = isnetype( obj,type )
%ISNETYPE Check if object is a non-empty, specific type variable. 
import Analysis.Core.* Analysis.Base.*

if ~isempty(obj) && isa(obj,type)
    hr = true;
else
    hr = false;
    error('Object is empty or has not the type of "%s".',type);
end

end

