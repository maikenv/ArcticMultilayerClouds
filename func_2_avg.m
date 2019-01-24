
function[H_fallbeginn_out , H_falldown_out , Pressure_mean_no_cloud_out ,RHi_mean_non_cloud_out, TempK_mean_no_cloud_out ]=func_2_avg(Raso, Raso10km, Cloudixd) 

%%
%In this function the mean of p,T, RHi in the subsaturated layer is calculated

ix_bottom=Cloudixd.index_sub_bottom;
ix_top=Cloudixd.index_sub_top;
lindex=length(ix_top);                                %Amount of subsaturated layers
%%

for k=1:lindex
    
    index_sub_bottom=ix_bottom(k);               %find index at bottom of subsaturated layer
    index_sub_top=ix_top(k);                     %find index at top of subsaturated layer
    
    Heightdiff(k)=Raso10km.alt(ix_top(k))-Raso10km.alt(ix_bottom(k));    %height of subsaturated layer
      
    %%
    %Height of subsaturated layer/fall distance of ice crystal
    H_fallbeginn=Raso10km.alt(index_sub_top);
    H_falldown=Raso10km.alt(index_sub_bottom);

    %need to find index for heights in Raso-struct:
    x = Raso.alt;
    valueToMatch = H_fallbeginn;
    [minDifferenceValue, indexAtTop] = min(abs(x - valueToMatch));    % Find the closest value
    x = Raso.alt;
    valueToMatch = H_falldown;
    [minDifferenceValue, indexAtEnd] = min(abs(x - valueToMatch));    % Find the closest value

    %Mean values of T, p, RHi in subsaturated layer (SI):
    RHmax_mean_no_cloud=mean(Raso.RHmax(indexAtEnd:indexAtTop)); 
    RHi_mean_no_cloud=mean(Raso.RHi(indexAtEnd:indexAtTop)); 
    TempK_mean_no_cloud=mean(Raso.tempK(indexAtEnd:indexAtTop));
    Pressure_mean_no_cloud=mean(Raso.press(indexAtEnd:indexAtTop));

    H_fallbeginn_out(k)=H_fallbeginn;
    H_falldown_out(k)=H_falldown;
    Pressure_mean_no_cloud_out(k)=Pressure_mean_no_cloud;
    RHi_mean_non_cloud_out(k)=  RHi_mean_no_cloud;
    TempK_mean_no_cloud_out(k)=TempK_mean_no_cloud;

end

end

