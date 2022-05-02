%This script is the objective function, when run it will output LCOE
%through passing the parameters, running initTurbPos, running floris,
%convert watts to megawatts, and finally running LCOE calc. The objective
%is to minimise LCOE.

function [x]=objective1(x0)
%% objective

    [~,lev_cost_en,~]=model1(x0);
    x = lev_cost_en;   


end