classdef GenerateVariablesOcclude
    % The goal of this class is::do necessary pre-processings 
    %(Indexing/choping) on each trial
    % and then generate the variable by putting all trials for that
    % particular variable together for the condition at hand
    properties
       %[props1]
       targetY 
       targetydot
       %targetangvel
       gazetimestamp 
       gazeY 
       gazeangvelvec 
       gazeangvelraw 
       gazeevent
       handforceY 
       handimpulse
       robotimpulse 
       handY 
       handYvel 
       %create new [props2]
       success %success rate
       DeltaImpulse %(handimpulse-abs(Robotimpulse))/abs(Robotimpulse) *100
       gazeangvelocity %gazeangvelocity for only the pursuit points(gazeevent==2)
       idx_force5perc %time at which the force is 5 % of the pesk force 
       maxforce_beforecollision % peak force before collision
       idx_forceonset
       forceonset
       collision_point
       idx_forceonsetwrtcollision 
       DTC% distance to collision when the force onset happened
       polyfit % polyfit 
       TTC%TTC
       %maxgazeangvel% gaze angular velocity at maximum hand force point
       pursuitperc_TTC % percentage of pursuit at TTC
       pursuitperc_BTTC% percentage of pursuit From 150ms after target onset to 150 ms before force onset
       meanpursuitvel_TTC %average pursuit velocity at TTC
       meanpursuitvel_BTTC %average pursuit velocity from target onset to FOC
       DTC_Hand%distance of hand movement from H to C (i.e from the point where the hand was at FOC to where the hand was at collision)
       handYvel_collision%velocity of hand at collision
       PS_BFOC % percentage of pursuit 350ms before FOC till 150ms before FOC
       PSvel_BFOC % average pursuit velocity from 200 ms before force onset to force onset
       PSmedian_BFOC %velocity of hand at collision
       PSmax_BFOC % max pursuit velocity from 200 ms before force onset to force onset
       gazeangvelocitynew
       gazeangvel_80ps % gazeang velocity for only the trials where the ps percentage is more than equal to 80
       gazeydot_nofilt
       gazeydot_filt
       ydot_80ps
       ydot_plot
       gazelag_stat
       gazelag_plot
       gazegain_stat
       gazegain_plot
       psperc %%%%% pursuit percent 150ms after target onset till 150ms before FOC
       saccadeperc %%%%% saccade percent 150ms after target onset till 150ms before FOC
       gazeydot_BFOC
       gazegain_BFOC% gazegain BFOC. 350ms before FOC till 150ms before FOC
       gazegain_middle
%        gazegain_slope_mid
       slope_gg %slope of gazegain 150ms till 150ms before FOC
    
    end

    methods
        
    function s = GenerateVariablesOcclude (obj)
   %obj is the condition(exp:D1_M3);
        props1 = properties(s);  %props1 all the properties except properties that are in props2
        props1(contains(props1,{'success','DeltaImpulse','gazeangvelocity','idx_force5perc','maxforce_beforecollision','idx_forceonset','forceonset','collision_point',...
            'idx_forceonsetwrtcollision','DTC','polyfit','TTC','pursuitperc_TTC','pursuitperc_BTTC','meanpursuitvel_TTC','meanpursuitvel_BTTC','DTC_Hand','handYvel_collision','PS_BFOC','PSvel_BFOC','PSmedian_BFOC','PSmax_BFOC','gazeangvelocitynew','gazeangvel_80ps','gazeydot_nofilt','gazeydot_filt','ydot_80ps'...
            ,'ydot_plot','gazelag_stat','gazelag_plot','gazegain_stat','gazegain_plot','psperc','saccadeperc','gazeydot_BFOC','gazegain_BFOC','gazegain_middle','slope_gg'})) = [];
        props2 = {'success', 'DeltaImpulse','gazeangvelocity','idx_force5perc','maxforce_beforecollision','idx_forceonset','forceonset','collision_point','idx_forceonsetwrtcollision','DTC','polyfit','TTC','pursuitperc_TTC',...
            'pursuitperc_BTTC','meanpursuitvel_TTC','meanpursuitvel_BTTC','DTC_Hand','handYvel_collision','PS_BFOC','PSvel_BFOC','PSmedian_BFOC','PSmax_BFOC','gazeangvelocitynew','gazeangvel_80ps','gazeydot_nofilt','gazeydot_filt','ydot_80ps','ydot_plot','gazelag_stat','gazelag_plot',...
            'gazegain_stat','gazegain_plot','psperc','saccadeperc','gazeydot_BFOC','gazegain_BFOC','gazegain_middle','slope_gg'};
   %preallocation props2
        s.(props2{1}) = nan(1, size(obj,3)); %sucess
        s.(props2{2}) = nan(1, size(obj,3)); %delta impulse
        s.(props2{3}) = nan(size(obj,1), size(obj,3)); %gazeangvelocity
        s.(props2{4}) = nan(1, size(obj,3)); %idx_force5perc
        s.(props2{5}) = nan(1, size(obj,3)); %maxforce_beforecollision
        s.(props2{6}) = nan(1, size(obj,3)); %idx_forceonset
        s.(props2{7}) = nan(1, size(obj,3)); %force at forceonset
        s.(props2{8}) = nan(1, size(obj,3));%collision_point
        s.(props2{9}) = nan(1, size(obj,3));%idx_forceonsetwrtcollision %FOC 
        s.(props2{10}) = nan(1, size(obj,3));%DTC reported in mm
        s.(props2{11}) = nan(1, size(obj,3));%polyfit
        s.(props2{12}) = nan(1, size(obj,3));%TTC reported in cm
        s.(props2{13}) = nan(1, size(obj,3));% percentage of pursuit at TTC
        s.(props2{14}) = nan(1, size(obj,3));%percentage of pursuit from 150 ms after target onset to 150 ms before FOC
        s.(props2{15}) = nan(1, size(obj,3));%average pursuit velocity at TTC
        s.(props2{16}) = nan(1, size(obj,3));%average pursuit velocity from target onset to FOC
        s.(props2{17}) = nan(1, size(obj,3)); %distance of hand movement from H to C (i.e from the point where the hand was at FOC to where the hand was at collision)
        s.(props2{18})= nan(1, size(obj,3)); %velocity of hand at collision
        s.(props2{19})= nan(1, size(obj,3)); % percentage of pursuit at 200 ms before force onset
        s.(props2{20})= nan(1, size(obj,3)); % average pursuit velocity from 200 ms before force onset to force onset
        s.(props2{21})= nan(1, size(obj,3)); % median pursuit velocity from 200 ms before force onset to force onset
        s.(props2{22})= nan(1, size(obj,3)); % max pursuit velocity from 200 ms before force onset to force onset
        s.(props2{23}) = nan(901, size(obj,3)); %chopped gazeangvelocity(only pursuit points)
        s.(props2{24}) = nan(901, size(obj,3)); % gazeangvelocity only for trials that have 80% and more pursuit points and FOC<200
        s.(props2{25}) = nan(size(obj,1), size(obj,3)); %gazeydot withoutfilter
        s.(props2{26}) = nan(size(obj,1), size(obj,3)); %gazeydot with filter
        s.(props2{27}) = nan(201, size(obj,3)); %ydot_80ps 200ms before FOC
        s.(props2{28})= nan(901, size(obj,3)); %ydot for 500ms before collision till 400 ms after collision to be used for plotting purposes
        s.(props2{29})= nan(201, size(obj,3)); %gaze lag 200 ms before FOC to be used for statistical analysis
        s.(props2{30})= nan(901, size(obj,3)); %gaze lag 901 timepoints to be used for plotting
        s.(props2{31})= nan(201, size(obj,3)); %gaze gain 200 ms before FOC to be used for statistical analysis
        s.(props2{32})= nan(901, size(obj,3)); %gaze gain 901 timepoints to be used for plotting
        s.(props2{33})= nan(1, size(obj,3)); %psperc pursuit percentage from 150ms after Target onset till 150 ms before FOC
        s.(props2{34})= nan(1, size(obj,3)); %saccadeperc_stat. saccade percentage for 150ms after target onset till 150ms before FOC
        s.(props2{35})= nan(201, size(obj,3)); %gazeydot 450 ms before FOC till 150ms before FOC
        s.(props2{36})= nan(201, size(obj,3)); %gazegain 450 ms before FOC till 150ms before FOC
        s.(props2{37})= nan(2000, size(obj,3));%gazegain_middle
        s.(props2{38})= nan(1, size(obj,3)); %slope of gazegain per trial
          movingAverageFilterWindowSize=5;

        
     for iprop = 1:length(props1)
            thisprop = props1{iprop}; 
  %preallocation props1
            s.(thisprop) = nan(901,size(obj,3));
         for i =1:size(obj,3)
  %at each iteration (i) access trial(i)
              s.(props2{1})(i)= Trial(obj,i).(props2{1})(1,1); %access success variable for each trial
              s.(props2{2})(i) = (sum(Trial(obj,i).('handimpulse'),'omitnan')...
                  - abs(sum(Trial(obj,i).('robotimpulse'), 'omitnan')))*...
                  100/abs(sum(Trial(obj,i).('robotimpulse'), 'omitnan')); % create Deltaimpulse based on the formula at each trial
              time_window = [-500 400] ; %chopping criteria
              index = find(Trial(obj,i).pertforcedata~=0, 1, 'first'); %collision timepoint
              s.(props2{8})(:,i) = index;
            if index<= abs(time_window(1))
                   s.(thisprop)(:,i)=nan;
              else
              s.(thisprop)(:,i) = Trial(obj,i).(thisprop)(index +...
                  time_window(1):index + time_window(2)); %chop variable based on time window                    
            
            %% To find the 5% of the peak hand force
            handForceStartPoint=find(Trial(obj,i).handforcedata~=0,1,'first');
            [s.(props2{5})(:,i),idxpeakforce]= max(Trial(obj,i).handforceY(handForceStartPoint:index));
            maxForceInTrial=max(Trial(obj,i).handforceY(handForceStartPoint:index));
            maxHandForcePoint=handForceStartPoint+idxpeakforce;
            
            searchVectorHandForceBegin=Trial(obj,i).handforceY(1:maxHandForcePoint)- mean(Trial(obj,i).handforceY(1:100));
            fivePercentPeakForce=0.05*(maxForceInTrial- mean(Trial(obj,i).handforceY(1:100)));
            beginForceStart= find(searchVectorHandForceBegin>fivePercentPeakForce==0,1,'last'); %index of 5 % hand force with respect to whole vector
            s.(props2{4})(:,i)=beginForceStart;%5% index with respect to wholevector

            %%
%             forceY=Trial(obj,i).handforceY(index+time_window(1):index+time_window(2));
            diff_vector=diff(Trial(obj,i).handforceY(1:index));
            diff_logicalvect=diff_vector>0;
            minima_index= strfind((diff_logicalvect)',[0,1]);%minima index with respect to the chopped vectore(timewindow(1) to timewindow(2))   
            minima_idx_before5perc=minima_index(find(minima_index<beginForceStart,1,'last')); %index of minima before 5 percent hand force with respect to chopped vector
            forceminima_before5perc= Trial(obj,i).handforceY(minima_idx_before5perc); %find the force at the last minima before 5 percent force point
            [forceminima_after5perc,idxforceminima_after5perc]= min(Trial(obj,i).handforceY(minima_index((find(minima_index>beginForceStart,1,'first')):end))); % find the minimum force after 5% force till the collision
            force_at5perc=Trial(obj,i).handforceY(beginForceStart);
            
            if isempty(idxforceminima_after5perc)==1
                forceminima_after5perc=100; % if no minima after 5 % set an arbitary force value to the force after 5 percent so that it can never satisfy the if statements later
            else
                minima_idx_after5perc= minima_index(((find(minima_index>beginForceStart,1,'first'))+idxforceminima_after5perc)-1); %find the index with respect to chopped vector for the minima after the 5 percent 
            end

            
           if forceminima_before5perc<force_at5perc | forceminima_before5perc< forceminima_after5perc
               s.(props2{6})(:,i)= minima_idx_before5perc;
               s.(props2{7})(:,i)= forceminima_before5perc;
%                s.(props2{9})(:,i)=(-time_window(1))-(index-minima_idx_before5perc);
                s.(props2{9})(:,i)=index-minima_idx_before5perc;
               s.(props2{10})(:,i)=(Trial(obj,i).targetY(s.(props2{6})(:,i))-Trial(obj,i).handY(s.(props2{6})(:,i))).*0.1; %%DTC in mm to cm 
               timeVectorforRegression=(s.(props2{6})(:,i):index)/1e3;
               forceVectorforRegression=movmean(Trial(obj,i).handforceY(s.(props2{6})(:,i):index),movingAverageFilterWindowSize);
               timeVectorforRegression=timeVectorforRegression-timeVectorforRegression(1);
               p = polyfit(timeVectorforRegression,forceVectorforRegression,1); 
               s.(props2{11})(:,i)=p(1);
             

           elseif forceminima_after5perc < force_at5perc
                   s.(props2{6})(:,i)= minima_idx_after5perc;
                   s.(props2{7})(:,i)= forceminima_after5perc;
%                    s.(props2{9})(:,i)=(-time_window(1))-(index-minima_idx_after5perc);
                   s.(props2{9})(:,i)=index-minima_idx_after5perc;
                   s.(props2{10})(:,i)=(Trial(obj,i).targetY(s.(props2{6})(:,i))-Trial(obj,i).handY(s.(props2{6})(:,i))).*0.1; %DTC in cm
                   timeVectorforRegression=(s.(props2{6})(:,i):index)/1e3;
                   forceVectorforRegression=movmean(Trial(obj,i).handforceY(s.(props2{6})(:,i):index),movingAverageFilterWindowSize);
                   timeVectorforRegression=timeVectorforRegression-timeVectorforRegression(1);
                   p = polyfit(timeVectorforRegression,forceVectorforRegression,1); 
                   s.(props2{11})(:,i)=p(1);
           else
               s.(props2{6})(:,i)= beginForceStart;
                   s.(props2{7})(:,i)= force_at5perc;
%                    s.(props2{9})(:,i)=(-time_window(1))-(index-beginForceStart);
                   s.(props2{9})(:,i)=index-beginForceStart;
                   s.(props2{10})(:,i)=(Trial(obj,i).targetY(s.(props2{6})(:,i))-Trial(obj,i).handY(s.(props2{6})(:,i))).*0.1; %DTC in cm
                   timeVectorforRegression=(s.(props2{6})(:,i):index)/1e3;
                   forceVectorforRegression=movmean(Trial(obj,i).handforceY(s.(props2{6})(:,i):index),movingAverageFilterWindowSize);
                   timeVectorforRegression=timeVectorforRegression-timeVectorforRegression(1);
                   p = polyfit(timeVectorforRegression,forceVectorforRegression,1); 
                   s.(props2{11})(:,i)=p(1);

           end
                   %% Now calculate TTC according to the DTC calculated above 
           
               if Trial(obj,i).protocolvec(1,1)==3 | Trial(obj,i).protocolvec(1,1)==4 | Trial(obj,i).protocolvec(1,1)==7| Trial(obj,i).protocolvec(1,1)==8| Trial(obj,i).protocolvec(1,1)==9| Trial(obj,i).protocolvec(1,1)==10
                   s.(props2{12})(:,i)=(((s.(props2{10})(:,i).*0.01))./0.25).*1000; % convert DTC to m and then divide by m/s and then convert the TTC to ms by multiplying with 1000 
               elseif Trial(obj,i).protocolvec(1,1)==5| Trial(obj,i).protocolvec(1,1)==6
                   s.(props2{12})(:,i)=(((s.(props2{10})(:,i)).*0.01)./0.35).*1000; % TTC being reported in ms for all condition
               elseif Trial(obj,i).protocolvec(1,1)==1| Trial(obj,i).protocolvec(1,1)==2
                   s.(props2{12})(:,i)=(((s.(props2{10})(:,i)).*0.01)./0.15).*1000;
               end
                  s.(props2{17})(:,i)=abs(Trial(obj,i).handY(s.(props2{6})(:,i))-Trial(obj,i).handY(index)).*0.1; %DTCHAnd 
                  s.(props2{18})(:,i)=(Trial(obj,i).handYvel(index)).*0.1;


            %%
              angraw = Trial(obj,i).gazeangvelraw(:,1);
             
              s.(props2{3})(Trial(obj,i).gazeevent(:,1)==2,i)=...
                        angraw(Trial(obj,i).gazeevent(:,1)==2,1);

              gazeangvel_TTC=s.(props2{3})(s.(props2{6})(:,i):index); %make a vector of the gazeangvel with only values at pursuit event for the TTC time span
               s.(props2{13})(:,i)= sum(~isnan(gazeangvel_TTC)/size(gazeangvel_TTC,2)).*100; %percentage of pursuit at TTC
              gazeangvel_BTTC=s.(props2{3})((150:(s.(props2{6})(:,i)-150)),i);%make a vector of the gazeangvel with only values at pursuit event for 150ms after target onset to 150ms before FOC
              if (s.(props2{6})(:,i))> 200
                  gazeangvel_BFOC=s.(props2{3})((s.(props2{6})(:,i)-200):s.(props2{6})(:,i)); 
              end

              s.(props2{14})(:,i)= sum(~isnan(gazeangvel_BTTC)/size(gazeangvel_BTTC,1)).*100;
              s.(props2{15})(:,i)=mean(gazeangvel_TTC,'omitnan');
              s.(props2{16})(:,i)=mean(gazeangvel_BTTC,'omitnan');
              s.(props2{19})(:,i)= sum(~isnan(gazeangvel_BFOC)/size(gazeangvel_BFOC,2)).*100;% percentage of pursuit at 200 ms before force onset
              s.(props2{20})(:,i)=mean(gazeangvel_BFOC,'omitnan');  % average pursuit velocity from 200 ms before force onset to force onset
              s.(props2{21})(:,i)=median(gazeangvel_BFOC,'omitnan'); %median of pursuit velocity at 200 ms before force onset
              s.(props2{22})(:,i)=max(gazeangvel_BFOC);% max of pursuit velocity at 200 ms before force onset
              s.(props2{23})(:,i)=(s.(props2{3})(index +...
                  time_window(1):index + time_window(2)))';
             gazepos=Trial(obj,i).gazeY;
             timestamps= Trial(obj,i).gazetimestamp;
             s.(props2{25})(:,i)=0.1*derivative(gazepos)./derivative(timestamps);  %convert to cm
             gazeydot_filt=sgolayfilt(s.(props2{25})(:,i),4,67); % 4 and 67 are parameter for the sgolay filter.
             s.(props2{26})(Trial(obj,i).gazeevent(:,1)==2,i)= gazeydot_filt(Trial(obj,i).gazeevent(:,1)==2,1);
             gazeydot=s.(props2{26})(:,i);
             pursuitbeforeC=s.(props2{3})((150:(s.(props2{6})-150)),i);
             saccade=(Trial(obj,i).gazeevent(:,1)==1);
             pursuitpercentage=sum(~all(isnan(pursuitbeforeC))/size(pursuitbeforeC,1)).*100;
             if (s.(props2{6})(:,i)>=351)
             saccadebeforeFOC=saccade(150:(s.(props2{6})(:,i)-150));
             s.(props2{34})(:,i)=(sum(saccadebeforeFOC)/size(saccadebeforeFOC,1)).*100;
            s.(props2{33})(:,i)=pursuitpercentage;
             end
             
%              if (s.(props2{6})(:,i)>=201)
%              pursuitbeforeFOC=s.(props2{3})((s.(props2{6})(:,i)-200):s.(props2{6})(:,i));
%              end
%              pursuitperc_200=sum(~isnan(pursuitbeforeFOC)/size(pursuitbeforeFOC,2)).*100; %pursuitpercentage for the 200 ms before FOC
             
               if pursuitpercentage >= 50 && (s.(props2{9})(:,i)<=500) && (s.(props2{6})(:,i)>=351) %% considering FOC that has only occured not more than 500 ms before collision 
                   
                   s.(props2{24})(:,i)=s.(props2{23})(:,i);
                  
                   s.(props2{28})(:,i)=s.(props2{26})(index +...
                  time_window(1):index + time_window(2)); % y dot for only the trials which 200ms before FOC and 80% pursuit in trials to be used for plotting
                  gazelag= s.(props2{26})(:,i)-((Trial(obj,i).targetydot).*0.1); %gaze lag for the whole trial but only for trials with 200ms before FOC and 80% pursuit
                  s.(props2{29})(:,i)=gazelag((s.(props2{6})(:,i)-200):s.(props2{6})(:,i)); %gazelag for 200ms before FOC to be used for statistical analysis
                  s.(props2{30})(:,i)=gazelag(index +...
                  time_window(1):index + time_window(2)); %gaze lag for 901 timepoint to be used for plotting
                  gazegain = (s.(props2{26})(:,i))./((Trial(obj,i).targetydot).*0.1);%gaze gain for the whole trial but only for trials with 200ms before FOC and 80% pursuit
                  if (sum(~isnan(gazegain((s.(props2{6})(:,i)-200):s.(props2{6})(:,i)))/size(gazegain((s.(props2{6})(:,i)-200):s.(props2{6})(:,i)),1)).*100) >50 %% to take care of trials that has very lessnumber of gazegain
                  s.(props2{31})(:,i)=gazegain((s.(props2{6})(:,i)-200):s.(props2{6})(:,i)); %gazegain for 200ms before FOC to be used for statistical analysis
                  s.(props2{32})(:,i)=gazegain(index +...
                  time_window(1):index + time_window(2)); %gaze gain for 901 timepoint to be used for plotting
                  end
                 
                  gazegainBFOC = gazegain((s.(props2{6})(:,i)-350):(s.(props2{6})(:,i)-150));
                  gazeangvel_BFOC=s.(props2{3})((s.(props2{6})(:,i)-350):(s.(props2{6})(:,i)-150));
                  s.(props2{19})(:,i)= sum(~isnan(gazeangvel_BFOC)/size(gazeangvel_BFOC,2)).*100;% percentage of pursuit at 350 ms before force onset till 150ms before forceonset
                  s.(props2{20})(:,i)=mean(gazeangvel_BFOC,'omitnan');  % average pursuit velocity from 200 ms before force onset to force onset
                  s.(props2{21})(:,i)=median(gazeangvel_BFOC,'omitnan'); %median of pursuit velocity at 200 ms before force onset
                  s.(props2{22})(:,i)=max(gazeangvel_BFOC);% max of pursuit velocity at 200 ms before force onset
                  s.(props2{23})(:,i)=(s.(props2{3})(index +...
                  time_window(1):index + time_window(2)))';
                  if (sum(~isnan(gazegainBFOC))/size(gazegainBFOC,1)*100) >50
                     s.(props2{36})(:,i)=gazegainBFOC;
                     else
                      s.(props2{36})(:,i)=nan;
                  end

                  gazegain_middle = gazegain(150:(s.(props2{6})(:,i)-150));
                  if (sum(~isnan(gazegain_middle))/size(gazegain_middle,1)*100) >50
                      s.(props2{37})((1:length(gazegain_middle)),i)=(gazegain_middle);
                  else
                      s.(props2{37})(:,i)=nan;
                  end




                  gazeydotFOC=gazeydot((s.(props2{6})(:,i)-200):s.(props2{6})(:,i));
                  gazeydotBFOC=gazeydot((s.(props2{6})(:,i)-350):(s.(props2{6})(:,i)-150));
                  if (sum(~isnan(gazeydotFOC))/size(gazeydotFOC,1)*100) >50 %% to take care of trials that has very lessnumber of gazegain
                     s.(props2{27})(:,i)=gazeydotFOC; % doing this to make sure that there is 50% no nan values in the 200 ms before FOC time period
                  else
                      s.(props2{27})(:,i)=nan;    
                  if (sum(~isnan(gazeydotBFOC))/size(gazeydotBFOC,1)*100) >50 
                      s.(props2{35})(:,i)=gazeydotBFOC;
                  else
                      s.(props2{35})(:,i)=nan;
                  end
                  end
                  
                  
                  %Finding slope of gaze gain for 200 ms before Force onset

                  timeVectorforRegressiongaze=(150:(s.(props2{6})(:,i)-150))/1e3; %as we are only interested in 201 ms before FOC
                  gazegainVectorforRegression=movmean(gazegain(150:(s.(props2{6})(:,i)-150)),20,'omitnan');
                  timeVectorforRegressiongaze=timeVectorforRegressiongaze-timeVectorforRegressiongaze(1); %what to do if the first row in nan?
                  nanidx=isnan(gazegainVectorforRegression); %find the nans in gazegainvector (the nans are caused by saccade)
                  p_gaze = polyfit(timeVectorforRegressiongaze(~nanidx),gazegainVectorforRegression(~nanidx),1);  %only consider the values in the regression vector which are not nans.
                   s.(props2{38})(:,i)=p_gaze(1);
                   

%% This portion is used to only keep the values where FOC wrt to collision (s.(props2{9})) 

               if  (s.(props2{9})(:,i)<=500)
                   
                   s.(props2{1})(:,i)=s.(props2{1})(:,i); %success
                   s.(props2{2})(:,i)=s.(props2{2})(:,i); %deltaimpulse
                   s.(props2{11})(:,i)=s.(props2{11})(:,i); %slope
                   s.(props2{12})(:,i)=s.(props2{12})(:,i); %TTC
                   s.(props2{17})(:,i)=s.(props2{17})(:,i); %distance of hand movement from H to C 
                   s.(props2{18})(:,i)=s.(props2{18})(:,i); %velocity of hand at collision
                   s.(props2{26})(:,i)=s.(props2{26})(:,i); % gazeydot_filt
               
               else
                   s.(props2{1})(:,i)=nan; 
                   s.(props2{2})(:,i)=nan; 
                   s.(props2{11})(:,i)=nan;
                   s.(props2{12})(:,i)=nan;
                   s.(props2{17})(:,i)=nan;
                   s.(props2{18})(:,i)=nan;
                   s.(props2{26})(:,i)=nan;
                   
               end
                  
















               end
            
            
            end
            
        end
                s.(props2{1}) = ((sum(s.(props2{1})))/size(obj,3))*100; 

%                 [Ny,Nx] = size(s.(props2{37}));
%                 Nz = sum(~isnan(s.(props2{37}))); 
%                 maxsize=max(Nz);
%                 gazegain_midnew=(s.(props2{37}));
%                 interp_gaze=nan(maxsize,Nx);
%                 for k = 1:Nx
%                     if ~all(isnan(gazegain_midnew(:,k)))==1
%                     interp_gaze(:,k) = interp1(1:Nz(k),gazegain_midnew(1:Nz(k),k),1:maxsize,'linear','extrap');    
%                    
%                     end
% 
%                 
%                 end 
%                 median_interp=median(interp_gaze,2,'omitnan');
%                 timeVectorforRegressiongaze=((1:size(median_interp))/1e3)'; %as we are only interested in 201 ms before FOC
%                 gazegainVectorforRegression=movmean(median_interp,20,'omitnan');
%                 timeVectorforRegressiongaze=timeVectorforRegressiongaze-timeVectorforRegressiongaze(1); %what to do if the first row in nan?
% %               nanidx=isnan(gazegainVectorforRegression); %find the nans in gazegainvector (the nans are caused by saccade)
%                 % p_gaze = polyfit(timeVectorforRegressiongaze(~nanidx),gazegainVectorforRegression(~nanidx),1);  %only consider the values in the regression vector which are not nans.
%                 
%                     
%                 p_gaze = polyfit(timeVectorforRegressiongaze,gazegainVectorforRegression(:,1),1); 
%                 s.(props2{38})=p_gaze(1);
                
                
     end



    end


    end
    end
