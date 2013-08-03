function [ hr ] = ConnectRL2( RPX,interface,devnum )
%CONNECTRL2 Establishes a connection with the Stingray Docking Station (RL2)
%           via the Gigabit or USB bus interface.
%Input:
%      interface: Interface to which the device is connected.
%                   Argument   Connection     Part #s
%                   'GB'         Gigabit      PI5/FI5, PO5/FO5
%                   'USB'          USB        UZ2, UB2, UZ1, UZ4
%      devnum: Logical device number. Starts with 1 and counts upward for
%              each device of a specified type.
% Note: Invoke device connect commands only once to connect to a device,
%       and then use ClearCOF and LoadCOF commands to upload or reload the
%       control object to implement changes to the signal.

hr = RPX.ConnectRL2(interface,devnum);
if hr==0
    hr = false;
else
    hr = true;
end

end

