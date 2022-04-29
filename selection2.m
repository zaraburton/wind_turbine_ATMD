function [YY1 YY2] = selection2(P,F,p)
% P - population, F - fitness value, p - population size
[x y]=size(P);
Y1 = zeros(p,y);
F = F + 10; %adding 10 to ensure no chromosome has negative fitness

% elite selection
e=3;

for i=1:e
    [r1 c1]=find(F==max(F));
    Y1(i,:)=P(max(c1),:);
    P(max(c1),:)=[];
    Fn(i)=F(max(c1));
    F(:,max(c1))=[];
end

D=F/sum(F); % Determin selection probability
E=cumsum(D); % Determine cumulative probability
N=rand(1); % Generate a vector constraining normalised random numbers
d1=1;
d2=e;
while d2 <= p-e
    if N <= E(d1)
        Y1(d2+1,:)=P(d1,:);
        Fn(d2+1)=F(d1);
        N=rand(1);
        d2 = d2+1;
        d1=1;
    else
        d1 = d1+1;
    end
end

YY1 = Y1;
YY2 = Fn-10; % Subtract 10 to return the original fitness
end
