%This script is the constraint function, when run it will output LCOE
%through passing the parameters, running initTurbPos, running floris,
%convert watts to megawatts, and finally running LCOE calc. The constraints
%include 1)Geographical constraints 2) turbine clearance (optional).

function [C,Ceq]=constraints1(x0)

    %Design var
    %x=turbine_centres;

    %% constraints

    %inequality constraint 1: geographical bounds
%     C(1)=sum(turbine_centres(:,1)-54*111139)+...
%       sum(53.7*111139-turbine_centres(:,1))+...
%       sum(turbine_centres(:,2)-2.8*111139)+...
%       sum(2.1*111139-turbine_centres(:,2));

    %inequality constraint 2: turbine clearance
    penalty = zeros;
    for i=1:length(x0)-1
        for j=1:length(x0)-1
        b=111139*(x0(i,1)-x0(j,1));
        c=111139*(x0(i,2)-x0(j,2));
        a=sqrt(b^2+c^2);

            if a<200 % diameter
                a=penalty(i,j);
            else
                penalty(i,j)=0;
            end
        end
    end

    C(1)=sum(penalty,'all');

    Ceq=[];
end