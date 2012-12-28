function [ hr ] = SetUseSortName( TX, sortid )
%SETUSESORTNAME sets the sort file used for OpenDeveloper calls that retrieve
%       events like ReadEventsV. The sort code file will be set if the event name
%       matches and the desired channel has a sort named sortID. If this function is not
%       used , the event name does not match, or of the sort name sortID is not present,
%       this function has no effect and the original sort file from the online tank sort is
%       used.
%input:
%  sortid  sort ID given in OpenSorter (the original online tank sort
%           is always named TankSort)

hr = TX.SetUseSortName(sortid);
if hr==0
    hr = false;
else
    hr = true;
end

