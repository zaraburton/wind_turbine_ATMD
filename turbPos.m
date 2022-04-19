function [TCfloris,TCA] = turbPos(numT, hubHeight, XL, YL)
%% Creates turbine position arrays for floris & cost function from turbine longitude and latitude array

TLL = zeros(numT,2);
TLL(1:numT,1) = XL;
TLL(1:numT,2) = YL;


% Creating turbine centers array for floris input
TCyx = (TLL*111139); %converting to meters
TCz = hubHeight*ones(numT,1);
TCfloris = [TCyx(:,2),TCyx(:,1),TCz]; % (m)

% Turbine long and latidue positions for cost input
TCA = [TLL, zeros([numT,2])]; %turbine cost array

end 



