classdef SubjectFixation
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
    
        function Subj = SubjectFixation(obj)
        % The goal of this function is::go to the directory of target
        % subject. access all Day1 and Day2 conditions. convert cell to
        % multivariate arrays.Create Day2 conditions by using protocol
        % indexes
        global props
        
        props=properties(Subj);
        if obj<=9
        filename = sprintf('S00%d',obj);
        else
            filename = sprintf('S0%d',obj);
        end
        p=cd(filename); %go to the directory of Subject(i)
        FileList=dir('*.mat');
        if isempty(FileList)
            cd(p)
            return;
        end
        L=length(FileList);
        data = cell(L,1);
        for i=1:L
        % access the conditions and store in each cell
        data{i}.name=FileList(i).name;
        newData1 = load('-mat', data{i}.name);
        length_index = length(newData1.subjDataMatrix);
        l=zeros(1,length_index);
            for k=1:length_index
             l(1,k) = length(newData1.subjDataMatrix{1,k});
            end
        l_max = max(l);
        Matrix3D= nan(l_max,...
        size(newData1.subjDataMatrix{1,1},2),length_index); %preallocate multivariate array based on max length
        for j=1:length_index
            %convert each dataset to multivariate array
          Matrix3D(1:length(newData1.subjDataMatrix{1,1,j}),...
              :,j) = cell2mat(newData1.subjDataMatrix(1,1,j));
        end
        data{i}.signals = Matrix3D;
        
        end
        cd(p)
        %create Day2 AF based on protocol vactors
        for i=1:length(props(1:6))
        Subj.(props{i}) = data{i,1}.signals;
        end
        protocolAF = zeros(1, 520);
        for i =1:size(Subj.D2_AF,3)
            protocolAF(i)= Trial(Subj.D2_AF,i).protocolvec(1,1);
        end
        for i=1:length(props(7:11))
        Subj.(props{i+6}) = Subj.D2_AF(:,:,protocolAF==i);   
        end
%%%F
      

        protocolBF = zeros(1, 520);
        for i =1:size(Subj.D2_BF,3)
            protocolBF(i)= Trial(Subj.D2_BF,i).protocolvec(1,1);
        end
        for i=1:length(props(12:16))
        Subj.(props{i+11}) = Subj.D2_BF(:,:,protocolBF==i);   
        end

          protocolF = zeros(1, 520);
        for i =1:size(Subj.D2_F,3)
            protocolF(i)= Trial(Subj.D2_F,i).protocolvec(1,1);
        end
        for i=1:length(props(17:21))
        Subj.(props{i+16}) = Subj.D2_F(:,:,protocolF==i);   
        end
        %pro1==M1
        %prot2==S2
        %prot3==M3
        %prot4==S1
        %prot5==S3
                
    end         
    
    function var = assign(Subj)
        % assigning all variables to each condition
        global props
        for iprop = 1:length(props)
          thisprop = props{iprop};
          var.(thisprop) = GenerateVariables(Subj.(thisprop));          
        end       
        
    end 
     
    
    end 
end
