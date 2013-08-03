function [ cs ] = catstruct( varargin )
%CATSTRUCT Concatenate structs. If a fieldname occurs more than once
%           in the argument list, only the last occurence is used,
%           and the fields are alphabetically sorted.
%
%   CATSTRUCT(S1,S2,'sorted') will sort the fieldnames alphabetically.
%
%   To sort the fieldnames of a structure A use:
%     A = CATSTRUCT(A,'sorted') ;
%
%   When there is nothing to concatenate, the result will be empty
%
%   See also CAT, STRUCT, FIELDNAMES, STRUCT2CELL

narginchk(1,Inf);
vsi = cellfun(@(x)~isempty(x),varargin);
vs = varargin(vsi);
N = length(vs);
if ~isstruct(vs{end})
    if isequal(vs{end},'sorted')
        sorted = 1 ;
        N = N-1 ;
        if N < 1
            cs = [];
            return
        end
    else
        error('catstruct:InvalidArgument','Last argument should be a structure, or the string "sorted".') ;
    end
else
    sorted = 0 ;
end
fn=[];vn=[];
for i=1:N
    X = vs{i} ;
    if ~isstruct(X)
        error('catstruct:InvalidArgument',['Argument #' num2str(i) ' is not a structure.']) ;
    end
    fn = [fn;fieldnames(X)];
    vn = [vn;struct2cell(X)];
end
[ufn, ind] = unique(fn);
if numel(ufn) ~= numel(fn)
    warning('catstruct:DuplicatesFound','Duplicate fieldnames found. Last value is used and fields are sorted') ;
    sorted = 1 ;
end
if sorted
    vn = vn(ind) ;
    fn = fn(ind) ;
end
if ~isempty(fn)
    cs = cell2struct(vn, fn,1);
else
    cs = [] ;
end

end

