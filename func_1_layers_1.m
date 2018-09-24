
function[Raso10km, numcloud_i, Cloudixd]=func_1_layers(Raso, hmax,rhthres,minsub, minsuper)

%this program searches for layers that are supersaturated (numcloud_i)

%%
%for limiting height where we look for multi-layer clouds:
x = Raso.alt;
valueToMatch = hmax*1e3;
% Find the closest value.
[minDifferenceValue, indexAtMin] = min(abs(x - valueToMatch));

%Change Raso into Raso10km
RHl10km=Raso.RHl(1:indexAtMin);
RHi10km=Raso.RHi(1:indexAtMin);
Alt10km=Raso.alt(1:indexAtMin);
RHm10km=max(RHl10km,RHi10km);
lRHm10km=length(RHm10km);
index=[1:1:lRHm10km];

Raso10km.number=Raso.number;
Raso10km.date=Raso.date;
Raso10km.N=Raso.N(1:indexAtMin);

Raso10km.index=index';
Raso10km.alt=Raso.alt(1:indexAtMin);
Raso10km.RHl10km=RHl10km;
Raso10km.RHi10km=RHi10km;
Raso10km.RHm10km=RHm10km;

%%
%Creating a variable RHmclass:

%RHm < 100%: RHmclass=1 (subsaturated)
%RHm > 100%: RHmclass=2 (supersaturated)
%RHm = Nan:  RHmclass=Nan

RHmclass(1:lRHm10km)=0;

for ii=1:lRHm10km
    mtot=RHm10km(ii);
    if mtot>=rhthres
        RHmclass(ii)=2;          
    elseif mtot<rhthres
        RHmclass(ii)=1;
    elseif isnan(mtot) 
        RHmclass(ii)=nan;  
    end
end

%%
%cleaning RHmclass: deleting single cloudvalues at top and bottom

A = RHmclass;   
for jj=1:lRHm10km
    if jj==1 && A(jj)==2 && A(jj+1)==1              %if there is a single cloud value at the lowest level
        A(jj)=1;
    elseif jj==length(A) && A(jj)==2 && A(jj-1)==1  %if there is a single cloud value at the uppermost level
        A(jj)=1;  
    end
end
RHmclass_cleaned=A;                                 %cleaned RHmclass

%uebergang= Finding the change from subsat to supersat (begin and end). Looking from down and upward:
%uebergang=-1: first entry without cloud
%uebergang=+1: first entry with cloud
uebergang(1)=0;
uebergang(2:lRHm10km)=diff(RHmclass_cleaned);

%Table with height in m and layers of RHmax:
tC=table(index',Alt10km,RHm10km, RHmclass_cleaned',RHi10km, uebergang');
%diff_cleaned: taking away repreated values in RHmclass_cleaned
%diff_cleaned = RHmclass_cleaned(diff([0 RHmclass_cleaned])~=0);

%%
%Finding ALL subsaturated layers

index_bottom=find(uebergang ==-1);                        %Index at begin of subsaturated layer
index_top=(find(uebergang ==1))-1;                        %Index at begin of supersaturated layer
lindex=length(index_top);                                 %Amount of subsaturated layers including bottom layer which is not needed

%%
%Finding ONLY subsaturated layers in between supersaturated layers

if lindex>=2                                    %i=5: only if min 1 subsaturated layer 
    
    for j=2:lindex
        Heightdiff(j-1)=Raso10km.alt(index_top(j))-Raso10km.alt(index_bottom(j-1));   %finding height of subsaturated layer
    end

    ix_sub = find(Heightdiff | Heightdiff==0);      %finding amount of subsaturated layers (für 322 need |==0)
    ix_sub_bottom=index_bottom(ix_sub);          %index at bottom of subsaturated layer
    ix_sub_top=index_top(ix_sub+1);              %index at top of subsaturated layer (does not contain the lowest top which is not needed) 

    %%
    %If the subsaturated layers are due to liquid and not ice: liquid_case=1
    
    liquid_sub=0;

    for k=1:length(ix_sub)
        if Raso10km.RHi10km(ix_sub_bottom(k)-1) < rhthres      %check if the index below the sub_bottom is ice-supersaturated
            idx_liquid(k)=ix_sub_bottom(k);                     %if not, then it has to be liquid-supersaturated
            liquid_sub=1;
        end
    end

    if liquid_sub==1                                           %if there are liquid cases
        lliquid=length(idx_liquid);                             %count how many liquid cases

        ix_sub_bottom(1:lliquid-1)=NaN;                         %delete that layer
        ix_sub_bottom(isnan(ix_sub_bottom)) = [];
        ix_sub_top(1:lliquid-1)=NaN;
        ix_sub_top(isnan(ix_sub_top)) = [];

        lix_sub=lindex-lliquid;                                 %amount ice-subsaturated layers

    elseif liquid_sub==0                                        %if there is no liquid-supersaturation layer
        lix_sub=length(ix_sub);
    end

    %%  
    Cloudixd.index_sub_top=ix_sub_top;
    Cloudixd.height_sub_top=Raso10km.alt(ix_sub_top);

    Cloudixd.index_sub_bottom=ix_sub_bottom;
    Cloudixd.height_sub_bottom=Raso10km.alt(ix_sub_bottom);

elseif lindex==1                                                %if there is only 1 subsaturated layer
    
    ix_sub_top=0;

end

%%
%finding supersaturated layers
index_super_bottom=find(uebergang ==1);                      %Index at begin of supersaturated layer
index_super_top=find(uebergang ==-1)-1;                      %Index at top of supersaturated layer

%%
%if cloud reaches higher than hmax:
if length(index_super_top)< length(index_super_bottom)

    disp('cloud exceeds hmax');
    x = Raso10km.alt;
    valueToMatch = hmax*1e3;
    [minDifferenceValue, index_super_top(end+1)] = min(abs(x - valueToMatch));    %find the closest value

end
lindex_super=length(index_super_top);                        %Amount of supersaturation tops

%%
%if cloud begins at ground:
%this is only needed for the 24.5-yr dataset.
if  length(index_super_bottom) < length(index_super_top)
    index_super_bottom(2:end+1)=index_super_bottom(:);

    x = Raso10km.alt;
    valueToMatch = 0;   
    [minDifferenceValue, index_super_bottom(1)] = min(abs(x - valueToMatch)); % Find the closest value.

    lindex_super=lindex_super-1;
    
    %if lindex>=2                 %??? needs to be replaced
        %lsub=length(ix_sub_toploudidx.height_super_top);
        %Cloudixd.index_super_bottom=index_super_bottom;
        
     %   Cloudixd.index_sub_bottom=ix_sub_bottom;
     %   Cloudixd.index_sub_top=ix_sub_top;

      %  Cloudixd.height_sub_bottom=Raso10km.alt(ix_sub_bottom);
      %  Cloudixd.height_sub_top=Raso10km.alt(ix_sub_top);
    %end
    %error('cloud starts at bottom');
end

%%
%If supersaturated layer is defined by RHl and not RHi.
liquid_super=0;

for k=1:lindex_super                                        %go through all supersaturation layers
    if Raso10km.RHi10km(index_super_top(k)) < rhthres      %check if supersaturation is due to liquid
        idx_liquid_super(k)=index_super_top(k);
        liquid_super=1;
        disp('liquid supersaturation case')
    end
end

if liquid_super==1                                          %remove layers
    lliqsuper=length(idx_liquid_super);

    index_super_top(1:lliqsuper-1)=NaN;
    index_super_top(isnan(index_super_top)) = [];
    index_super_bottom(1:lliqsuper-1)=NaN;
    index_super_bottom(isnan(index_super_bottom)) = [];

    numcloud_i=lindex_super-lliqsuper+1;                    %final number of supersaturated layers
    
elseif liquid_super==0                                      %if there are no liquid cases
    numcloud_i=lindex_super;
end

%%
Cloudixd.index_super_top=index_super_top;
Cloudixd.height_super_top=Raso10km.alt(index_super_top);

Cloudixd.index_super_bottom=index_super_bottom;
Cloudixd.height_super_bottom=Raso10km.alt(index_super_bottom);

%%
%Check if supersaturation layer is too thin (case 16.7.):
thin=0;

try
for k=1:length(index_super_bottom)                      %k=1: does not work  %if cloudlayer is too thin
    cloud_dist(k)=Raso10km.alt(index_super_top(k))-Raso10km.alt(index_super_bottom(k));
    
    if cloud_dist(k)<minsuper
        Cloudixd.index_super_bottom(k)=NaN;
        Cloudixd.index_super_top(k)=NaN;
        Cloudixd.height_super_bottom(k)=NaN;
        Cloudixd.height_super_top(k)=NaN;
        Cloudixd.index_sub_bottom(k)=NaN;
        Cloudixd.height_sub_bottom(k)=NaN;
        
        if k==1  
            disp('here k=1');
            %ind(end+1)=i;
            Cloudixd.index_sub_top(k)=NaN;
            Cloudixd.height_sub_top(k)=NaN; 
        elseif k>=2  && length(Cloudixd.index_sub_top)>1            %elseif
            Cloudixd.index_sub_top(k-1)=NaN;
            Cloudixd.height_sub_top(k-1)=NaN;
        end      
            
        numcloud_i=numcloud_i-1;
        thin=1;
   end 
end

if thin==1
    Cloudixd.index_super_bottom(isnan(Cloudixd.index_super_bottom)) = [];
    Cloudixd.index_super_top(isnan(Cloudixd.index_super_top)) = [];
    Cloudixd.height_super_bottom(isnan(Cloudixd.height_super_bottom)) = [];
    Cloudixd.height_super_top(isnan(Cloudixd.height_super_top)) = [];
    Cloudixd.index_sub_bottom(isnan(Cloudixd.index_sub_bottom)) = [];
    Cloudixd.height_sub_bottom(isnan(Cloudixd.height_sub_bottom)) = [];
    Cloudixd.index_sub_top(isnan(Cloudixd.index_sub_top)) = [];
    Cloudixd.height_sub_top(isnan(Cloudixd.height_sub_top)) = [];
end
catch
end
%%
try 
if length(Cloudixd.index_sub_top) >length(Cloudixd.index_sub_bottom)    %i=2
    Cloudixd.index_sub_top(1)=[];
    Cloudixd.height_sub_top(1)=[];
end
catch
end

%%
%Check if subsaturated layers reach min thickness

thinsub=0;

try
for k=1:length(Cloudixd.height_sub_top)
    sub_height(k)=Cloudixd.height_sub_top(k)-Cloudixd.height_sub_bottom(k);
    
    if sub_height(k)< minsub                              %define minimum thickness of subsaturation layer. 20? 22?
         Cloudixd.index_sub_bottom(k)=NaN; 
         Cloudixd.index_sub_top(k)=NaN; 
         Cloudixd.height_sub_bottom(k)=NaN;  
         Cloudixd.height_sub_top(k)=NaN; 
         Cloudixd.index_super_top(k)=NaN; 
         Cloudixd.height_super_top(k)=NaN; 
         
         if length(Cloudixd.index_sub_top)>1 
             Cloudixd.index_super_bottom(k+1)=NaN; 
             Cloudixd.height_super_bottom(k+1)=NaN; 
         end
           
         numcloud_i=numcloud_i-1;
         thinsub=1;
    end 
end

if thinsub==1
    Cloudixd.index_super_bottom(isnan(Cloudixd.index_super_bottom)) = [];
    Cloudixd.index_super_top(isnan(Cloudixd.index_super_top)) = [];
    Cloudixd.height_super_bottom(isnan(Cloudixd.height_super_bottom)) = [];
    Cloudixd.height_super_top(isnan(Cloudixd.height_super_top)) = [];
    Cloudixd.index_sub_bottom(isnan(Cloudixd.index_sub_bottom)) = [];
    Cloudixd.index_sub_top(isnan(Cloudixd.index_sub_top)) = [];
    Cloudixd.height_sub_bottom(isnan(Cloudixd.height_sub_bottom)) = [];
    Cloudixd.height_sub_top(isnan(Cloudixd.height_sub_top)) = [];
end
catch
end

%%
Raso10km.index=index';
Raso10km.RHmclass_cleaned=RHmclass_cleaned';
Raso10km.uebergang=uebergang';

end




