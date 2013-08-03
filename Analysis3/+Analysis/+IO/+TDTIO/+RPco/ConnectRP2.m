function [ hr ] = ConnectRP2( RPX,interface,devnum )
%CONNECTRP2 Establishes a connection with an RP2 or RP2.1 Real-time Processor
%           through a device interface (such as Gigabit or USB).
%           A device number identifies which RP2 is connected.
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

hr = RPX.ConnectRP2(interface,devnum);
if hr==0
    hr = false;
else
    hr = true;
end

end

