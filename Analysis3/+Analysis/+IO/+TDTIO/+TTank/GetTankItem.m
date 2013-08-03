function [ item ] = GetTankItem( TTX,tankname,itemcode )
%GETTANKITEM returns the path or the tank version for the tank provided in
%           TankName. This function is only valid with enumerated or registered tanks
%input:
%   itemcode   PT returns path to tank
%               VERSION returns the version of the tank or a null string
%               if the tank does not exist
%output:
%   item   Path to the given tank
%          Version ¡®20¡¯ ¨C new format tank
%                  ¡®10¡¯ ¨C legacy tank
%                   null string ¨C tank does not exist

item = TTX.GetTankItem(tankname,itemcode);
end

