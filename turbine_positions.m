function [TCfloris,TCA] = floris
%% Creates initial turbine position arrays for floris & cost function

max_lat = 54; 
min_lat = 53.7; 
max_long = 2.8; 
min_long = 2.1;

Theight = 34.97; % turbine height (m)
numT = 40; % number of turbines
TLL = zeros([numT,2]); % Tubine longitude and latitude coords (degrees) 

for t=1:numT %for turbine 1 - turbine 300 
    % set y/longtitude coord 
    TLL(t,2)= min_long + (max_long-min_long).*rand();
    
    % set x/latitide coord
    TLL(t,1)= min_lat + (max_lat-min_lat).*rand();   
end

TLL;

% Creating turbine centers array for floris input
TCyx = (TLL*111139); %converting to meters
TCz = Theight*ones(numT,1);
TCfloris = [TCyx(:,2),TCyx(:,1),TCz]; % (m)

% Turbine long and latidue positions for cost input
TCA = [TLL, zeros([numT,2])]; %turbine cost array



