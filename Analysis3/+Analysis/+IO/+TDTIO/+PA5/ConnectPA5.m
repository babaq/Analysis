function [ hr ] = ConnectPA5( PA5X,interface,devnum )
%CONNECTPA5 Establishes a connection with the PA5 Programmable Attenuator.
%Input:
%      interface: Interface to which the device is connected.
%                   Argument   Connection     Part #s
%                   'GB'         Gigabit      PI5/FI5, PO5/FO5
%                   'USB'          USB        UZ2, UB2, UZ1, UZ4
%      devnum: Logical device number. Starts with 1 and counts upward for
%              each device of a specified type.

hr = PA5X.ConnectPA5(interface,devnum);
if hr==0
    hr = false;
else
    hr = true;
end

end

