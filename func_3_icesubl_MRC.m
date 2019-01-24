function [maxtime, Sublimation, esati, esatiM]=func_3_icesubl_MRC(RHi1,TK1,P1,z1,r1)

TC1=TK1-273.15;
r1=r1*1e-6;                 %ice particle size conversion from mikrometer to SI=m.

%Saturation equilibrium pressure calculation using Magnus formula [SI=Pa]
esatwM=6.112e2.*exp((17.62.*TC1)./(243.12+TC1));
esatiM=6.112e2.*exp((22.46*TC1)./(272.62+TC1));

logew = 1./TK1*(- 0.58002206e4) ...        %Hyland and Wexler, 1983.
         + 0.13914993e1 ...
         - 0.48640239e-1*TK1 ...
         + 0.41764768e-4*TK1.^2 ...
         - 0.14452093e-7*TK1.^3 ...
         + 0.65459673e1*log(TK1);
esatw=exp(logew);

logei =  1./TK1*(- 0.56745359e4) ...          %Hyland and Wexler, 1983.                                                                
         + 0.63925247e1 ...
         - 0.96778430e-2*TK1 ...
         + 0.62215701e-6*(TK1).^2 ...
         + 0.20747825e-8*(TK1).^3 ...
         - 0.94840240e-12*(TK1).^4 ...
         + 0.41635019e1*log(TK1); 
esati=exp(logei);
ei=RHi1*esati./100;                 %saturation pressure regarding ice

T0=273.15;
p0=1013.25e2;
Dv=0.211*(TK1/T0)^1.94*(p0/P1)*1e-4;%Taken from Hall and Pruppacher, 1976: 
%at given Temp D is larger at lower pressure. %for p=800e2 => Dvp=2.6e-5;

%VRL:
%ls=46782.5+35.8925*TK1-0.07414*TK1^2+541.5*exp(-(TK1/123.75)^2); %[Jmol-1] from Review Paper, but does not make any difference.
Mw=18.01528e-3;                     %Molar mass of water [kg/mol]
lsL=2.8345e6;                       %in m^2/s^2
ls=lsL*Mw;                          %ls without temperature dependence in Jmol-1
Dvp=2.15e-5;                        %modified diffusion coefficient [m^2s-1] at -4degC und 800hPa
kT=0.024;                           %heat transport [Jm-1s-1K-1]
Rst=8.314;                          %universal gas const [J/kg/Mol]
si=ei/esati-1;                      %supersaturation with respect of ice
%si2=ew*esatw/ei-1;
rhoI=0.92e3;                        %density of ice [kgm-3]
g=9.81;                             %gravity
Rs=287.058;                         %gas constant
rhoL=P1/(Rs*TK1);                   %density of air

%Size at beginning:
dp(1)=r1(1)*2;

%Ice crystal capacity. If modified here, it also needs to be modified a second time lower down.
%Seifert&Beheng:
%C(1)=r1(1)*2/pi;                   %C:Capacity for plate/hexagonal
%C(1)=r1(1);                        %for spherical Particle: C=r

%Westbrook:
A=5;                                         %Aspect ratio: Plate: A>1, column: A<1                              
C(1)=0.58*(1+0.95*A^(0.75))*r1(1)*2/A;

%Mitchell: Rimed long columns
if  dp(1)<=2400e-6 %&& D(ij)> 200e-6
    alpha(1)=0.00145;
    beta(1)=1.8;
    gamma(1)=0.0512;
    sigma(1)=1.414;
end

[V(1) m1(1)]=func_Mitchell_SI(dp(1), alpha, beta, gamma, sigma, P1, TK1);

%%
for t=2:1:1000000000                %dt in 0.01 sek 
    
    %change of mass:  
    GI=((rhoI*Rst*TK1)/(Mw*Dv*esati)+((rhoI*ls)/(Mw*kT*TK1)*(ls/(Rst*TK1)-1)))^(-1);
    %GI2=((rhoI*Rst*TK1)/(Mw*Dv*esati)+((rhoI*lsL)/(kT*TK1)*(lsL*Mw/(Rst*TK1)-1)))^(-1);

    m1(t)=m1(t-1)+4*pi*C(t-1)*rhoI*GI*si*0.01;      %Change of mass per time 
    
    if m1(t)>0.0                                  %m1 becomes neg. at some time     
      
    dp(t)=1e-2*nthroot((m1(t)/(alpha(t-1)*1e-3)),beta(t-1));  %M-D-relationship (Mitchell)
    r1(t)=dp(t)/2;
    
    %C(t)=r1(t)*2/pi;                       %Seifert&Beheng    
    C(t)=0.58*(1+0.95*A^(0.75))*r1(t)*2/A;  %Westbrook

    if  dp(t)<=2400e-6 %&& D(ij)> 200e-6
        alpha(t)=0.00145;
        beta(t)=1.8;
        gamma(t)=0.0512;
        sigma(t)=1.414;
    end
 
    [V(t) m1(t)]=func_Mitchell_SI(dp(t), alpha(t), beta(t), gamma(t), sigma(t), P1, TK1);
      
    %Fall distance: dz
    dz(t)=-V(t)*0.01;

    %Falldistance until time t
    z1(t)=z1(t-1)+dz(t);                            %z1(t-1)=height at beginning %dz=change of height
     
    end

    %stop if smaller than 0kg 
    if m1(t)<=0
        break
    end    
    
     %stop if still existing at ground
     if z1(t)<=0.00                                  %-0.01
        break
     end    
    
end

lm1=length(m1);

time=(1:lm1)*0.01/60;                                 %Time in minutes

%write into struct:
Sublimation(1).timestep(1)=0;
Sublimation(1).timestep(2:lm1-1)=[1:lm1-2];
Sublimation(1).time_min(1)=0;
Sublimation(1).time_min(2:lm1-1)=time(1:end-2);
Sublimation(1).mass=m1(1:end-1);
Sublimation(1).radius=r1(1:end-1);
Sublimation(1).speed=V(1:end-1);
Sublimation(1).falldist=dz(1:end-1);
Sublimation(1).height=z1(1:end-1);

%For writing values with only two digits in plot title.
P1_Tit = round((P1*1e-2*100))/100;
TK1_Tit = round((TK1*100))/100;
RHi1_tit = round((RHi1*100))/100;
r1print_tit = round((r1(1)*1e6*100))/100;

Sublimation(1).initial_cond=[RHi1_tit TK1_Tit P1_Tit z1(1) r1print_tit];    

%finde index/closest value for 0 height:
x = Sublimation(1).height;
valueToMatch = 0.0;
[minDifferenceValue, indexAt0] = min(abs(x - valueToMatch));

maxtime=Sublimation(1).time_min(indexAt0);

%if there are different lengths due to if m1(t)>0.0: 
if length(Sublimation(1).time_min) > length(Sublimation(1).speed)          %sometimes one index to long
    Sublimation(1).time_min=Sublimation(1).time_min(1:end-1);
end
if length(Sublimation(1).mass) > length(Sublimation(1).time_min)           %sometimes one index to long
    Sublimation(1).mass=Sublimation(1).mass(1:end-1);
end

end

%to compare ls with liv/ls2:
%TC1=[-50:1:0];
%TK1=TC1+273.15;
%ls=46782.5+35.8925*TK1-0.07414*TK1.^2+541.5*exp(-(TK1./123.75).^2);
%Mw=18.01528e-3;
%liv=ls/Mw;

