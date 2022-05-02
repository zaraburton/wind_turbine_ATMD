function [cost] = cost(num_t,TCA,ADlat,ADlon,A,supportLimits)
%LCOE in MWH/EURO
 
%% ------- SUPPORT COSTS -------%

    % interpolate mesh grid of bathymetry data to get water depths at each
    % turbine location
    TCA(:,3) = interp2(ADlat, ADlon, A.', TCA(:,1), TCA(:,2));
    
    %split TCA based on depth values, to get seperate arrays of depths for
    %different turbine types
    mp_tca = TCA(TCA(:,3)>=supportLimits(1),:);  % monopile turbines

    j_tca = TCA(TCA(:,3)>=supportLimits(2),:); % jacket turbine array
    
    
    %cost of support types - from minimalistic cost model 
gp = 6; %installed generator power in MW (6MW used on site)
c_t = 1.25*(-0.15+0.92*gp); %cost of wind turbine

%support structure cost equations (for reference, not used in code)
d = 25; %water depth in m
c_mp = (gp*(d*d +100*d +1500))/7500; %monopile
c_j = (gp*(0.5*(d*d)-35*d+2500))/7500; %jacket support structure

mpd = abs(mp_tca(:,3)); %monopile depth
mp_tca(:,4) = ((gp*(mpd.^2 +100*mpd +1500))/7500)*1000000; % cost of monopile support in euros

%total monopile turbine support costs
tot_mp = sum(mp_tca(:,4),"all");

jd = abs(j_tca(:,3)); %jacket depth
j_tca(:,4) = ((gp*(0.5*(jd.^2)-35*jd+2500))/7500)*1000000; %jacket support structure in euros

% total jacket turbine support cost
tot_j = sum(j_tca(:,4),"all");

%  Total support structure cost (in euros)
tot_support_cost = tot_mp + tot_j;

cost = tot_support_cost; % 1 euro = 84p
end

