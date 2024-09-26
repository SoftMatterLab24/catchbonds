clear all
close all

HomeDir = pwd;

del = [0:0.0025:0.05]; %[0:0.005:0.05]
f = 2*3*del;
RunDirName = 'Catch3';

mkdir(RunDirName)
cd(RunDirName)
RunDirectory = pwd;

for ii = 1:length(del)
    
    %Create Run Folder
    RunName = strcat('I',num2str(ii));
    mkdir(RunName)
   
    inputdir{ii} = strcat(RunName);
    cd(HomeDir)

    %Build Input Script
    buildInput(HomeDir,RunDirectory,RunName);

    %Build Data Script
    buildData(HomeDir,RunDirectory,RunName,del(ii))
    
    
end

%Build Run Script
cd(HomeDir)
buildRun(RunDirectory,inputdir)