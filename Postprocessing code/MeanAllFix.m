classdef MeanAllFix
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      D1_M3 
      D1_S2
      D1_S3
      D2_AF
      D2_BF
      D2_F
      D2_AFM1
      D2_AFS2
      D2_AFM3
      D2_AFS1
      D2_AFS3
      D2_BFM1
      D2_BFS2
      D2_BFM3
      D2_BFS1
      D2_BFS3
      D2_FM1
      D2_FS2
      D2_FM3
      D2_FS1
      D2_FS3
      
    end
    
    methods
%         function [obj1,obj2, obj3,obj4,obj5,obj6,obj7,obj8] = MeanAllFix(value1,value2,value3,value4,value5,value6,value7,value8)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
 %function [obj1,obj2,obj3,obj4,obj5,obj6,obj7] = MeanAllFix(value1,value2,value3,value4,value5,value6,value7)
function [obj1] = MeanAllFix(value1)


            props=properties(obj1);
            
            for i=1:13
                subj=SubjectFixation(i);
                 if isempty(subj.D1_M3)
                     for j=1:length(props)
                        obj1.(props{j})(:,i)=nan;
                          % obj2.(props{j})(:,i)=nan;
%                            obj3.(props{j})(:,i)=nan;
%                             obj4.(props{j})(:,i)=nan;
%                            obj5.(props{j})(:,i)=nan;
%                           obj6.(props{j})(:,i)=nan;
%                       obj7.(props{j})(i)=nan;
%                       
                     end
                 else
                    
                    var1=subj.assign;
                    for j=1:length(props)
                               
                        %obj1.(props{j})(1,i)=var1.(props{j}).(value1); %this is for success
                              
                         %obj1.(props{j})(:,i)=median(var1.(props{j}).(value1),2, 'omitnan');% when there is value in the variable for each time point
%                         obj2.(props{j})(:,i)=median(var1.(props{j}).(value2),2, 'omitnan'); %check you want median or mean
%                         obj3.(props{j})(:,i)=median(var1.(props{j}).(value3),2, 'omitnan');
                             obj1.(props{j})(1:size(var1.(props{j}).(value1),2),i)=var1.(props{j}).(value1);%when there is value in the variable for each trial
                        %      obj2.(props{j})(1:size(var1.(props{j}).(value2),2),i)=var1.(props{j}).(value2);
%                              obj3.(props{j})(1:size(var1.(props{j}).(value3),2),i)=var1.(props{j}).(value3);
%                              obj4.(props{j})(1:size(var1.(props{j}).(value4),2),i)=var1.(props{j}).(value4);
%                             obj5.(props{j})(1:size(var1.(props{j}).(value5),2),i)=var1.(props{j}).(value5);
%                             obj6.(props{j})(1:size(var1.(props{j}).(value6),2),i)=var1.(props{j}).(value6);
%                            obj7.(props{j})(1:size(var1.(props{j}).(value7),2),i)=var1.(props{j}).(value7);
%                           obj7.(props{j})(1:size(var1.(props{j}).(value7),2),i)=var1.(props{j}).(value7);
%                           obj8.(props{j})(1:size(var1.(props{j}).(value8),2),i)=var1.(props{j}).(value8);
                               
                              
                    end
                 end
                 end
            end
           end   
             
        end
        
        
 

