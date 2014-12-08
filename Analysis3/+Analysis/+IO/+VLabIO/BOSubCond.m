function [  ] = BOSubCond( block )
%BOSUBCOND Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

cts = block.data.condtests;
subparam = block.param.SubjectParam;
cond = block.param.Condition;

end

