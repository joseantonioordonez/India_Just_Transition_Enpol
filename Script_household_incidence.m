
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%            Household Data Code         %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read the file containing income group per capita in the second column,
%state in the third column, item code in the fourth column, expenditures in
%the 5th column
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('D:\Doku\Diss\MCC Berlin\2 India IO\5_Quellen\HH Data India\Lorenzo Data Coded')
[num,txt,raw]=xlsread('HH_india_perCapitaQuintiles_weighted_average_LM.xlsx');
averagenum=num;
averagetxt=txt;
averageraw=raw;

%read the matching table and state labels 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('D:\Doku\Diss\MCC Berlin\2 India IO\5_Quellen\HH Data India\Lorenzo Data Coded')
[num,txt]=xlsread('EXIO_HH_matched.xlsx');
matchingnum=num;
matchinglabels=txt;
[num,txt]=xlsread('states_labels.xlsx');
statelabelsnum=num;
statelabels=txt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%read state subsidies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('D:\Doku\Diss\MCC Berlin\2 India IO\5_Quellen\HH Data India\Lorenzo Data Coded')
[num,txt]=xlsread('states_subsidies.xlsx');
subsidies=num(:,6);
subsidiestxt=txt(:,1);
[num,txt]=xlsread('states_labels.xlsx');
statelabelsnum=num;
statelabels=txt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read state subsidies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('D:\Doku\Diss\MCC Berlin\2 India IO\5_Quellen\Power Sector Data')
[num,txt]=xlsread('Capacity_breakdown.xlsx');
capacitybreakdown=num;
capacitylabels=txt(2:35,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Check the average household consumption per item, quintile and state and% create a vector EXIOmatch that contains the corresponding matching number for EXIO, the price increase from the results vector  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %results vector is just the indian 200x1 price increase vector
 results=results2(n*countrynumber+1:n*countrynumber+200);
 for w=1:length(results)
     if results(w)==0;
         results(w)=1;
     end
 end
%   results=ones(200,1); % Comment this to overwrite results

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
EXIOmatch=zeros(length(averagenum),2); %vector to save the matching number and corresponding price increase

for j=1:length(averagenum);
    for k=1:length(matchingnum);

    if averagenum(j,4)==matchingnum(k,1); 
        EXIOmatch(j,1)=matchingnum(k,2); 
        
        if matchingnum(k,2)==0;
        EXIOmatch(j,2)=1; %if no matching category, price change multiplier is declared as 1 (unchanged)
        else
        EXIOmatch(j,2)=results(matchingnum(k,2));
        end
             

% %LPG Subsdies abolishment
%         if averagenum(j,4)==348; %LPG Subsidies removal
%         EXIOmatch(j,2)=1.93; %IISD data
%         end
% 
% %Kerosine Subsidies abolishment
% 
%         if averagenum(j,4)==344; %Kerosine Subsidies removal
%         EXIOmatch(j,2)=3.26; %IISD data
%         end
%        
% %Diesel Subsidies abolishment
% 
%         if averagenum(j,4)==510; %Diesel Subsidies removal
%         EXIOmatch(j,2)=1.39; %IISD data
%         end
%         if averagenum(j,4)==354; %Diesel Subsidies removal
%         EXIOmatch(j,2)=1.39; %IISD data
%         end

%Electricity with Carbon Tax 

        if averagenum(j,4)==342
            for r=1:34
            if strcmp(averagetxt(j,2),capacitylabels(r))==1;
             EXIOmatch(j,2)=results(128)*capacitybreakdown(r,1)+results(129)*capacitybreakdown(r,2)+results(133)*capacitybreakdown(r,3)+results(130)*capacitybreakdown(r,4)+results(131)*capacitybreakdown(r,5)+results(132)*capacitybreakdown(r,6);
%             EXIOmatch(j,2)=results(128);
%              EXIOmatch(j,2)=results(128)*capacitybreakdown(r,1)+1.1828*capacitybreakdown(r,2)+1.11428*capacitybreakdown(r,3)+results(130)*capacitybreakdown(r,4)+results(131)*capacitybreakdown(r,5)+results(132)*capacitybreakdown(r,6);

            end
            end
        end

        EXIOmatch(j,3)=matchingnum(k,6);
     
        EXIOmatchlabel(j,1)=matchinglabels(k,1);
        EXIOmatchlabel(j,2)=matchinglabels(k,2);
        EXIOmatchlabel(j,3)=matchinglabels(k,3);
    end
    end
  
end

% Subsidies 
% for k=1:length(subsidiestxt);
%          for j=1:length(averagenum);
%             if strcmp(averagetxt((j+1),2),subsidiestxt(k))==1;
%                 if averagenum(j,4)==342
%                     EXIOmatch(j,2)=EXIOmatch(j,2)*subsidies(k);  %Achtung, nur wenn subidies und CO2 steuer gleichzeitig, sonstEXIOmatch(j,2)=subsidies(k);       
%                 end
%             end                        
%          end
%  end    



newexpenditures=averagenum(:,5).*EXIOmatch(:,2);  
merged=horzcat(averagenum,EXIOmatch,newexpenditures); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd('D:\Doku\Diss\MCC Berlin\2 India IO\3_Arbeitspakete\Matlab Results')
% xlswrite('HH_Data_IO_Matched.xlsx',{'Nr.','Income Group Per Capita',' ','Item Code','Total Expenditures','Corresponding IO Sector','relative price increase','expenditure type','new expenditures'},'Matched','A1')
% xlswrite('HH_Data_IO_Matched.xlsx',merged,'Matched','A2')
% winopen('HH_Data_IO_Matched.xlsx')



% Compute total expenditures for each quintile and state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expcounter1=0; 
expcounter2=0;

for k=1:length(statelabels);
     for incomegroup=1:5;
         for j=1:length(averagenum);
           if merged(j,2)==incomegroup;
            if strcmp(averagetxt((j+1),2),statelabels(k))==1;
                expcounter1=merged(j,5)+expcounter1;
                expcounter2=merged(j,9)+expcounter2;           
            end            
           end
         end    
    totalexp1(k,incomegroup)=expcounter1; %expenditures before tax for state k and incomegroup are saved in totalexp1
    totalexp2(k,incomegroup)=expcounter2; %expenditures ater tax totalexp2
    expcounter1=0; %rest the counter for new state and decile
    expcounter2=0;       
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

% Compute total expenditures for each consuming category each quintile and state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expcounter11=0; 
expcounter21=0;

expcounter12=0; 
expcounter22=0;

expcounter13=0; 
expcounter23=0;

expcounter14=0; 
expcounter24=0;

expcounter15=0; 
expcounter25=0;

expcounter16=0; 
expcounter26=0;

for k=1:length(statelabels);
     for incomegroup=1:5;
         for j=1:length(averagenum);
           if merged(j,2)==incomegroup;
            if strcmp(averagetxt((j+1),2),statelabels(k))==1;;
                if merged(j,8)==1;
                expcounter11=merged(j,5)+expcounter11;
                expcounter21=merged(j,9)+expcounter21; 
                end
                if merged(j,8)==2;
                expcounter12=merged(j,5)+expcounter12;
                expcounter22=merged(j,9)+expcounter22; 
                end
                if merged(j,8)==3;
                expcounter13=merged(j,5)+expcounter13;
                expcounter23=merged(j,9)+expcounter23; 
                end
                if merged(j,8)==4;
                expcounter14=merged(j,5)+expcounter14;
                expcounter24=merged(j,9)+expcounter24; 
                end
                if merged(j,8)==5;
                expcounter15=merged(j,5)+expcounter15;
                expcounter25=merged(j,9)+expcounter25; 
                end
                if merged(j,8)==6;
                expcounter16=merged(j,5)+expcounter16;
                expcounter26=merged(j,9)+expcounter26; 
                end
                
                                
            end            
           end
         end    
    totalexp11(k,incomegroup)=expcounter11; %expenditures before tax for state k and incomegroup are saved in totalexp1
    totalexp21(k,incomegroup)=expcounter21; %expenditures ater tax totalexp2
    expcounter11=0; %rest the counter for new state and decile
    expcounter21=0;     
    
    totalexp12(k,incomegroup)=expcounter12; %expenditures before tax for state k and incomegroup are saved in totalexp1
    totalexp22(k,incomegroup)=expcounter22; %expenditures ater tax totalexp2
    expcounter12=0; %rest the counter for new state and decile
    expcounter22=0;
    
    totalexp13(k,incomegroup)=expcounter13; %expenditures before tax for state k and incomegroup are saved in totalexp1
    totalexp23(k,incomegroup)=expcounter23; %expenditures ater tax totalexp2
    expcounter13=0; %rest the counter for new state and decile
    expcounter23=0; 

    totalexp14(k,incomegroup)=expcounter14; %expenditures before tax for state k and incomegroup are saved in totalexp1
    totalexp24(k,incomegroup)=expcounter24; %expenditures ater tax totalexp2
    expcounter14=0; %rest the counter for new state and decile
    expcounter24=0; 
    
    totalexp15(k,incomegroup)=expcounter15; %expenditures before tax for state k and incomegroup are saved in totalexp1
    totalexp25(k,incomegroup)=expcounter25; %expenditures ater tax totalexp2
    expcounter15=0; %rest the counter for new state and decile
    expcounter25=0;
    
    totalexp16(k,incomegroup)=expcounter16; %expenditures before tax for state k and incomegroup are saved in totalexp1
    totalexp26(k,incomegroup)=expcounter26; %expenditures ater tax totalexp2
    expcounter16=0; %rest the counter for new state and decile
    expcounter26=0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



  cd('D:\Doku\Diss\MCC Berlin\2 India IO\3_Arbeitspakete\Matlab Results')
  indianstates={'ANDAMAN & NICOBAR ISLANDS','ANDHRA PRADESH','ARUNACHAL PRADESH','ASSAM','BIHAR','CHANDIGARH','DADRA & NAGAR HAVELI','DAMAN & DIU','DELHI','GOA','GUJARAT','HARYANA','HIMACHAL PRADESH','JAMMU & KASHMIR','JHARKHAND','KARNATAKA','KERALA','LAKSHADWEEP','MADHYA PRADESH','MAHARASTRA','MANIPUR','MEGHALAYA','MIZORAM','NAGALAND','ORISSA','PONDICHERRY','PUNJAB','RAJASTHAN','SIKKIM','TAMIL NADU','TRIPURA','UTTAR PRADESH','UTTARANCHAL','WEST BENGAL'};
  quintiles={'Quintile 1','Quintile 2','Quintile 3','Quintile 4','Quintile 5'};
  xlswrite('October_Results_to_households5c.xlsx',indianstates',taxstring,'A3')
  xlswrite('October_Results_to_households5c.xlsx',indianstates',taxstring,'A41')
  xlswrite('October_Results_to_households5c.xlsx',indianstates',taxstring,'A79')

  %Relative Expenditures
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Total
  xlswrite('October_Results_to_households5c.xlsx',{'Total Expenditures'},taxstring,'B1')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'B2')
  xlswrite('October_Results_to_households5c.xlsx',totalexp2./totalexp1,taxstring,'B3')
  
  %Food
  xlswrite('October_Results_to_households5c.xlsx',{'Food'},taxstring,'H1')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'H2')
  xlswrite('October_Results_to_households5c.xlsx',totalexp21./totalexp11,taxstring,'H3')
  
  %Energy
  xlswrite('Results_to_households5c.xlsx',{'Energy'},taxstring,'N1')
  xlswrite('Results_to_households5c.xlsx',quintiles,taxstring,'N2')
  xlswrite('Results_to_households5c.xlsx',totalexp22./totalexp12,taxstring,'N3')
  
  %Goods
  xlswrite('October_Results_to_households5c.xlsx',{'Goods'},taxstring,'T1')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'T2')
  xlswrite('October_Results_to_households5c.xlsx',totalexp23./totalexp13,taxstring,'T3')
  
  %Services
  xlswrite('October_Results_to_households5c.xlsx',{'Services'},taxstring,'Z1')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'Z2')
  xlswrite('October_Results_to_households5c.xlsx',totalexp24./totalexp14,taxstring,'Z3')
  
  %Electricity
  xlswrite('October_Results_to_households5c.xlsx',{'Electricity'},taxstring,'AF1')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'AF2')
  xlswrite('October_Results_to_households5c.xlsx',totalexp25./totalexp15,taxstring,'AF3')
  
  %LPG
  xlswrite('October_Results_to_households5c.xlsx',{'LPG'},taxstring,'AL1')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'AL2')
  xlswrite('October_Results_to_households5c.xlsx',totalexp26./totalexp16,taxstring,'AL3')
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  %Absolute expenditures before tax
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Totalexpenditures 
  xlswrite('October_Results_to_households5c.xlsx',{'Total Expenditures'},taxstring,'B39')
  xlswrite('October_Results_to_households5c.xlsx',{'Relative Increase','Quintile 1','Quintile 2','Quintile 3','Quintile 4','Quintile 5'},taxstring,'A40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp1,taxstring,'B41')
  
  %Food
  xlswrite('October_Results_to_households5c.xlsx',{'Food'},taxstring,'H39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'H40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp11,taxstring,'H41')
  
  %Energy
  xlswrite('October_Results_to_households5c.xlsx',{'Energy'},taxstring,'N39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'N40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp12,taxstring,'N41')
  
  %Goods
  xlswrite('October_Results_to_households5c.xlsx',{'Goods'},taxstring,'T39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'T40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp13,taxstring,'T41')
  
  %Services
  xlswrite('October_Results_to_households5c.xlsx',{'Services'},taxstring,'Z39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'Z40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp14,taxstring,'Z41')
  
  %Electricity
  xlswrite('October_Results_to_households5c.xlsx',{'Electricity'},taxstring,'AF39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'AF40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp15,taxstring,'AF41')
 
  %LPG
  xlswrite('October_Results_to_households5c.xlsx',{'LPG'},taxstring,'AL39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'AL40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp16,taxstring,'AL41')
  
   %Absolute expenditures after tax
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Totalexpenditures 
  xlswrite('October_Results_to_households5c.xlsx',{'Total Expenditures'},taxstring,'B77')
  xlswrite('October_Results_to_households5c.xlsx',{'Relative Increase','Quintile 1','Quintile 2','Quintile 3','Quintile 4','Quintile 5'},taxstring,'A78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp2,taxstring,'B79')
  
  %Food
  xlswrite('October_Results_to_households5c.xlsx',{'Food'},taxstring,'H77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'H78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp21,taxstring,'H79')
  
  %Energy
  xlswrite('October_Results_to_households5c.xlsx',{'Energy'},taxstring,'N77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'N78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp22,taxstring,'N79')
  
  %Goods
  xlswrite('October_Results_to_households5c.xlsx',{'Goods'},taxstring,'T77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'T78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp23,taxstring,'T79')
  
  %Services
  xlswrite('October_Results_to_households5c.xlsx',{'Services'},taxstring,'Z77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'Z78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp24,taxstring,'Z79')
  
  %Electricity
  xlswrite('October_Results_to_households5c.xlsx',{'Electricity'},taxstring,'AF77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'AF78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp25,taxstring,'AF79')
  
  %LPG
  xlswrite('October_Results_to_households5c.xlsx',{'LPG'},taxstring,'AL77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring,'AL78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp26,taxstring,'AL79')
%   winopen('Results_to_households5c.xlsx')


%Share of expenditures by category
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  xlswrite('October_Results_to_households5c.xlsx',indianstates',taxstring2,'A41')
  xlswrite('October_Results_to_households5c.xlsx',indianstates',taxstring2,'A79')



%Absolute expenditures before tax
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Totalexpenditures 
  xlswrite('October_Results_to_households5c.xlsx',{'Total Expenditures'},taxstring2,'B39')
  xlswrite('October_Results_to_households5c.xlsx',{'Relative Increase','Quintile 1','Quintile 2','Quintile 3','Quintile 4','Quintile 5'},taxstring2,'A40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp1./totalexp1,taxstring2,'B41')
  
  %Food
  xlswrite('October_Results_to_households5c.xlsx',{'Food'},taxstring2,'H39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'H40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp11./totalexp1,taxstring2,'H41')
  
  %Energy
  xlswrite('October_Results_to_households5c.xlsx',{'Energy'},taxstring2,'N39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'N40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp12./totalexp1,taxstring2,'N41')
  
  %Goods
  xlswrite('October_Results_to_households5c.xlsx',{'Goods'},taxstring2,'T39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'T40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp13./totalexp1,taxstring2,'T41')
  
  %Services
  xlswrite('October_Results_to_households5c.xlsx',{'Services'},taxstring2,'Z39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'Z40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp14./totalexp1,taxstring2,'Z41')
  
  %Electricity
  xlswrite('October_Results_to_households5c.xlsx',{'Electricity'},taxstring2,'AF39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'AF40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp15./totalexp1,taxstring2,'AF41')
  
  %LPG
  xlswrite('October_Results_to_households5c.xlsx',{'LPG'},taxstring2,'AL39')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'AL40')
  xlswrite('October_Results_to_households5c.xlsx',totalexp16./totalexp1,taxstring2,'AL41')
  
   %Absolute expenditures after tax
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Totalexpenditures 
  xlswrite('October_Results_to_households5c.xlsx',{'Total Expenditures'},taxstring2,'B77')
  xlswrite('October_Results_to_households5c.xlsx',{'Relative Increase','Quintile 1','Quintile 2','Quintile 3','Quintile 4','Quintile 5'},taxstring2,'A78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp2./totalexp2,taxstring2,'B79')
  
  %Food
  xlswrite('October_Results_to_households5c.xlsx',{'Food'},taxstring2,'H77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'H78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp21./totalexp2,taxstring2,'H79')
  
  %Energy
  xlswrite('October_Results_to_households5c.xlsx',{'Energy'},taxstring2,'N77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'N78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp22./totalexp2,taxstring2,'N79')
  
  %Goods
  xlswrite('October_Results_to_households5c.xlsx',{'Goods'},taxstring2,'T77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'T78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp23./totalexp2,taxstring2,'T79')
  
  %Services
  xlswrite('October_Results_to_households5c.xlsx',{'Services'},taxstring2,'Z77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'Z78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp24./totalexp2,taxstring2,'Z79')
  
  %Electricity
  xlswrite('October_Results_to_households5c.xlsx',{'Electricity'},taxstring2,'AF77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'AF78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp25./totalexp2,taxstring2,'AF79')
  
  %LPG
  xlswrite('October_Results_to_households5c.xlsx',{'LPG'},taxstring2,'AL77')
  xlswrite('October_Results_to_households5c.xlsx',quintiles,taxstring2,'AL78')
  xlswrite('October_Results_to_households5c.xlsx',totalexp26./totalexp2,taxstring2,'AL79')

   winopen('October_Results_to_households5c.xlsx')




  
  
  
%   
%   xlswrite('Results_to_households5c.xlsx',{'Absolute expenditures before tax.','Quintile 1','Quintile 2','Quintile 3','Quintile 4','Quintile 5'},'40USD_per_tonV2','A38')
%   xlswrite('Results_to_households5c.xlsx',totalexp1,'40USD_per_tonV2','B39')
%   xlswrite('Results_to_households5c.xlsx',indianstates','40USD_per_tonV2','A39')
% 
%   xlswrite('Results_to_households5c.xlsx',{'Absolute expenditures after tax','Quintile 1','Quintile 2','Quintile 3','Quintile 4','Quintile 5'},'40USD_per_tonV2','A74')
%   xlswrite('Results_to_households5c.xlsx',totalexp2,'40USD_per_tonV2','B75')
%   xlswrite('Results_to_households5c.xlsx',indianstates','40USD_per_tonV2','A75')

 
  
  
  
  
  
  
  
  
  
  
  
  
%   winopen('Results_to_households5c.xlsx')






      
    
        