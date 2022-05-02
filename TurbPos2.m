function [florisTurbPos,costTurbPos] = TurbPos2(x0)
%% Creates turbine position arrays for floris & cost function from x0

numT = length(x0(:,1));
hubHeight=167.47;

% Creating turbine centers array for floris input
TFyx = deg2km(x0)*1000;
TFz = hubHeight*ones(numT,1);
florisTurbPos = [TFyx(:,2),TFyx(:,1),TFz]; % (m)

% Turbine long and latidue positions for cost input
costTurbPos = [x0, zeros([numT,2])]; %turbine cost array



