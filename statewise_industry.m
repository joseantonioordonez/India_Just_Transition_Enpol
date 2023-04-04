%% Industry Analysis $$
%STEP 0 READ DATA
%STEP 1 MERGE BLOCK A AND J
%STEP 2 COMPUTE BRANCHES STATEWISE
%STEP 3 APPLY CO2 PRICE INCREASE

%% STEP 0 DATA READ  $$
close all
clear all

cd('C:\Users\orj\Documents\MCC Berlin\2 India IO\5_Quellen\Industry Survey Microdata\Extracted_2011')

[num,txt,raw]=xlsread('blka201112.xlsx'); %identification matrix
blkan=num;
blkat=txt;
blkaraw=raw;
[num,txt,raw]=xlsread('blkj201112.xlsx');
blkjn=num;
blkjt=txt;
blkjraw=raw;
[num,txt]=xlsread('statecodes.xlsx');
statecodes=num;
statelabels=txt;
% mergedn=zeros(length(blken),32);
[num,txt]=xlsread('electricitybranches.xlsx');
eleccodes=num;
eleclabel=txt;
eleclabel=string(txt);
[num,txt]=xlsread('majorbranches.xlsx');
majorbranchesn=num;
majorbranchest=txt;
[num,txt]=xlsread('IO_priceincrease1.xlsx');
IO_priceincrease=num;
%% STEP 0.1 Create a 2 digit label code for BLOCK A and Merge it

fivedigit=blkaraw(:,7);
fivedigit2=num2str(cell2mat(fivedigit))
firstdigit=fivedigit2(:,1);
seconddigit=fivedigit2(:,2);
twodigitscode=strcat(firstdigit,seconddigit);
twodigitscode = str2num(twodigitscode)
% CONCATENENATE TWODIGITSCODE WITH BLOCK A, then MATCH STATES AND
% INDUSTRIES 
blkan=horzcat(blkan,twodigitscode);


%% STEP 1

%%% BLOCK J contains data on total output %%%
%%% Merging Code with Identifiyer Matrix A  %%%
    a=1;
    for j=1:length(blkjn);
          if blkjn(j,3)==blkan(a,3); %compare DLS code, if the same
          mergedaj(j,:)=horzcat(blkjn(j,:),blkan(a,:)); %merge employment matrix block E with coding matrix block A
%            mergedajraw(j,:)=[blkaraw(j,:),blkjraw(a,:)];
%           mergedajraw(j,:)
          end
          
          if blkjn(j+1,3)>blkan(a,3); %if DLS code of next element higher, increase the counter
          a=a+1;%this works only as data is sorted by DLS number   
          end  
          
    end 
%   xlswrite('Block_J_A_merged.xlsx',mergedaj,'Block_J_A')
%    winopen('Block_J_A_merged.xlsx') 
weightedoutput=mergedaj(:,15).*mergedaj(:,37);
mergedaj=horzcat(mergedaj,weightedoutput);

%% STEP 2 COMPUTE BY BRANCHES 
% Select all with 12 SNO
   counter=1
for i=1:length(mergedaj);
    if mergedaj(i,4)==12; %This is for the SNO, dont know which on is what
        totalvalueaddedn(counter,:)=mergedaj(i,:);
%         totalvalueaddedraw(coutner,:)=mergedajraw(i,:);%totalemployment is a matrix merging Block E und A but onyl with cells of totalemployment from block E 
  counter=counter+1;
    end
end

%  branchvalueadded=zeros(length(majorbranchesn),1);
% 
% for s=1:length(majorbranchesn);
%     for e=1:length(totalvalueaddedn);
%     if totalvalueaddedn(e,38)==majorbranchesn(s)
%         branchvalueadded(s)=totalvalueaddedn(e,39)+branchvalueadded(s); 
% 
%     end
%     end
% end
% 
%   xlswrite('totaloutput2.xlsx',majorbranchest,'totaloutput2','A2')
%   xlswrite('totaloutput2.xlsx',branchvalueadded,'totaloutput2','B2')
%   winopen('totaloutput2.xlsx')

 branchvalueadded2=zeros(length(majorbranchesn),35);
for r=1:35
    branchvalueadded=zeros(length(majorbranchesn),1);

for s=1:length(majorbranchesn);
    for e=1:length(totalvalueaddedn);
    if totalvalueaddedn(e,38)==majorbranchesn(s)
            if totalvalueaddedn(e,23)==statecodes(r)

        branchvalueadded(s)=totalvalueaddedn(e,39)+branchvalueadded(s); 
            end
    end
    end
end
branchvalueadded2(:,r)=branchvalueadded
end
%   xlswrite('totaloutput4.xlsx',majorbranchest,'totaloutput2','A2')
%   xlswrite('totaloutput4.xlsx',branchvalueadded2,'totaloutput2','B2')
%   xlswrite('totaloutput4.xlsx',statelabels','totaloutput2','B1')
%   winopen('totaloutput4.xlsx')


averagepriceincrease=zeros(length(majorbranchesn),1);
maxpriceincrease=zeros(length(majorbranchesn),1);
for m=1:length(majorbranchesn)
    counter=0
    for i=1:length(IO_priceincrease)
    if IO_priceincrease(i,2)==majorbranchesn(m);
        averagepriceincrease(m)=IO_priceincrease(i,3)+averagepriceincrease(m);
        counter=counter+1;
        if maxpriceincrease(m)<IO_priceincrease(i,3)
            maxpriceincrease(m)=IO_priceincrease(i,3)
        end
    end
    end
    
averagepriceincrease(m)=averagepriceincrease(m)/counter;
averagepriceincrease'
maxpriceincrease'
pause
end


   xlswrite('totaloutput4.xlsx',majorbranchest,'priceincrease','A2')
   xlswrite('totaloutput4.xlsx',averagepriceincrease,'priceincrease','B2')
   xlswrite('totaloutput4.xlsx',maxpriceincrease,'priceincrease','C2')

   winopen('totaloutput4.xlsx')




























