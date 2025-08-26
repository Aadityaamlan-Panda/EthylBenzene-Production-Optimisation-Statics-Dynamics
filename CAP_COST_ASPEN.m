
clc
clear all
close all

col_data=[11 9 -60.255	636.028	4.778	81.245	0.669461701	0.6096;
24	23 -1862.33394	1011.8	0.855	1.688	1.217307083	0.6096;
29	28 -1881.90291	1835.63115	0.482	0.431	1.308055935	0.6096
];

% [NO OF TRAYS	EFFECTIVE_NO_FO_TRAYS	CONDENSOR DUTY	REBOILER
% DUTY	REBOILER TEMP DIFFERENCE	CONDENSER TEMP DIFFERENCE	DIAMETER	TRAY SPACE]
%[C1;C2;C3]

Colm_cost=zeros(1,3);
for i=1:3
    Colm_cost(i)=17640*col_data(i,7)^1.066*(0.6096*col_data(i,2)+1.2*0.6096*(col_data(i,1)-col_data(i,2)))^0.8092;
end

Tray_cost=zeros(1,3);
for i=1:3
    A=pi*col_data(i,7)^2/4;
    Cp=exp(2.994+0.446*log(A)+0.396*log(A)^2);
    N=col_data(i,2);
    if N<20
    Fq=exp(0.477+0.085*log(N)-0.347*log(N)^2);
    else
        Fq=1;
    end
    Tray_cost(i)=Cp*N*1.8*Fq;
end

conden_cap_cost=zeros(1,3);
HTC_C=0.568;
for i=1:3
   delta_T=col_data(i,6);
   Q_cond=abs(col_data(i,3));
   A=Q_cond/(HTC_C*delta_T);
   conden_cap_cost(i)=7296*A^0.65;
end

reb_cap_cost=zeros(1,3);
HTC_R=0.852;
for i=1:3
   delta_T=col_data(i,5);
   Q_reb=col_data(i,4);
   A=Q_reb/(HTC_R*delta_T);
   reb_cap_cost(i)=7296*A^0.65;
end

reactor_cost=zeros(1,2);
for i=1:2
    V=200*10^-6;
    asp_rat=2;
    D=(V/asp_rat/pi*4)^(1/3);
    L=D*asp_rat;
    reactor_cost(i)=17640*D^1.066*L^0.802;
end

Total_Cap_cost_columns=Colm_cost+conden_cap_cost+Tray_cost+reb_cap_cost;

Total_Cap_cost_of_all=sum(Total_Cap_cost_columns)+sum(reactor_cost);

%% OPERATING COST

LPS_cost=7.78;%GJ^-1
MPS_cost=8.22;
HPS_cost=9.8;
CW_cost=0.354;

Cond_op_cost=CW_cost*sum(abs(col_data(:,3)))/10^6*365*24*60*60;

Reb_op_cost=(HPS_cost*(col_data(1,4)+col_data(3,4))+MPS_cost*col_data(2,4))/10^6*365*24*60*60;

Total_op_cost=Cond_op_cost+Reb_op_cost;


TCC=Total_Cap_cost_of_all;
YOC=Total_op_cost;
PBP=3;
TAC=TCC/PBP+YOC;

