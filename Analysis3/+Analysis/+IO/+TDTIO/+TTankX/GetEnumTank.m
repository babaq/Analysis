function [ tankname ] = GetEnumTank( TX, idx )
%GETENUMTANK get tanks enumerated (registered) on the connected server
%input:
%  idx  position in the registry, 0 based
%output:
%  tankname  name of the tank at the index specified, null string
%            indicates the end of enumerated tanks

tankname = TX.GetEnumTank(idx);
end

