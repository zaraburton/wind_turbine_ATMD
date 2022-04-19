function [nvp] = NVP(yrlymoney, yrs, WACC)
% calculates NVP
nvp = [];
for yr=1:yrs
    nvp(yr) = yrlymoney(yr)/((1+WACC)^yr);
end
nvp = sum(nvp);
end 


    
    


 