function [ ms ] = mergestruct( varargin )
%MERGESTRUCT Merge structs with no intersected fields

vsi = cellfun(@(x)~isempty(x),varargin);
vs = varargin(vsi);
fn = [];
for i = 1:length(vs)
    try
        fn = [fn;fieldnames(vs{i})];
    catch MEstruct
        throw (MEstruct)
    end
end
if length(fn) ~= length(unique(fn))
    error('mergestruct:FieldNotUnique','Field names must be unique');
end
c=[];
for i = 1:length(vs)
    try
        c = [c;struct2cell(vs{i})];
    catch MEdata
        throw(MEdata);
    end
end
ms = cell2struct(c,fn,1);

end

