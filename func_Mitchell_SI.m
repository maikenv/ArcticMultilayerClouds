
function [vcalc mcalc]=func_Mitchell(D,alpha,beta,gamma,sigma,P1,TK1)

g=9.81;%e2;                           %Gravity in m/s^2 => cgs
Rs=287.058;                         %gas constant
rhoair=P1/(Rs*TK1);%*1e3*1e-6;        %density of air kg m-3  in 

eta=1.680e-5;%*1e3*1e-2;    %for -10°C  %dynamic vicosity in kg m-1 s-1 =>cgs
v=eta/rhoair;                       %kinematic vicosity

mcalc=1e-3*alpha.*(D*1e2).^beta;      %Unit: cgs: cm g s => D in cm, M in g=> in kg
%ARLC=1e-4*gamma*(D*1e2).^sigma;     %Unit: cgs: cm g s => D in cm, A in cm^2=> in m^2
%figure(1)
%line(D,mRLC,'LineWidth',1.5,'DisplayName','Rimed long columns','Color',cm(4,:));
%hold on;

Xh=((2*alpha*g*rhoair*1e-3).*(D*1e2).^(beta+2-sigma))/(gamma.*eta^2);

%%
for ij=1:length(Xh)
    X=Xh(ij);
    
    %if X > 0.01 && X <= 10.0           %original in Paper
    if  X <= 10.0                       %Maiken modification from small D
        a(ij)=0.04394;
        b(ij)=0.970;
    elseif X > 10.0 && X <= 585
        a(ij)=0.06049;
        b(ij)=0.8331;
    elseif X > 585 && X <= 1.56e5
        a(ij)=0.2072;
        b(ij)=0.638;
    elseif X > 1.56e5 && X <= 1e8
        a(ij)=1.0865;
        b(ij)=0.499;
    end

end

%vcalc=1e-2*a*v.*((2*alpha*g)/(rhoair*v^2*gamma)).^b.*(D*1e2).^(b*(beta+2-sigma)-1);               %convert cm s-1 to ms-1 
vcalc=1e2*a*v.*((2*alpha*g)/(rhoair*v^2*gamma*1e3)).^b.*(D*1e2).^(b*(beta+2-sigma)-1);               %convert cm s-1 to ms-1 

end



