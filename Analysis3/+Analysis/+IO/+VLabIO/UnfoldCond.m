function [ ct ] = UnfoldCond( cond, dcond, dvalue )
%UNFOLDCOND Summary of this function goes here
%   Detailed explanation goes here

if nargin ==1
    dcond = ',';
    dvalue = ' ';
end

dcond = ['\s*',dcond,'\s*'];
dvalue = ['\s*',dvalue,'\s*'];

for i=1:length(cond)
    sc = strsplit(strtrim(cond{i}),dcond,'delimitertype','regularexpression');
    for j=1:length(sc)
        ssc = strsplit(sc{j},dvalue,'delimitertype','regularexpression');
        f = regexp(ssc{1},'^[_.-]*(\w*)','tokens');
        ct(i).(f{:}{:}) = ssc(2:end);
    end
end

ct = struct2table(ct);
var = ct.Properties.VariableNames;
ct = varfun(@Analysis.Base.trystr2double,ct);
ct.Properties.VariableNames = var;
end