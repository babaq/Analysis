function [  ] = UnfoldSubCond( block )
%UNFOLDSUBCOND Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

switch block.param.TestType
    case 'Foraging_10'
        ForagingSubCond(block);
    case 'BO'
        BOSubCond(block);
end

end

