%This script is the objective function, when run it will output LCOE
%through passing the parameters, running initTurbPos, running floris,
%convert watts to megawatts, and finally running LCOE calc. The objective
%is to minimise LCOE.

function [f]=objective1(x)

    %Design var
    
    %objective
    [turbine_centres,lev_cost_en]=model1(numT);
    f=lev_cost_en;
end