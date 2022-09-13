function [colorInfo2,gammaTable] = measureDisplay(varargin)

% todo Auto determine COM
% todo Mac if possible?
% todo fix pwd

%MEASUREDISPLAY Use spectradiometers to measure monitor data.
%
%   Uses either Photo Research PR-655 (default) or X-Rite i1Pro
%   PR-655 uses serial connection, i1Pro requires VPixx toolbox, set the
%   path to I1.mexw64, path is perhaps
%   X:\SO Backup\VPixx\Software Tools for MAC\VPixx_Software_Tools\i1ProToolbox_trunk\mexdev\build\matlab\yourOS
%   Tested with Windows, ignore Software Tools for MAC directory.
%
%   This function is used for 2 purposes. The traditional use is to
%   generate gamma functions for monitor calibration, and saves in a
%   .MAT containing colorInfo2 structure (previous verison: colorInfo).
%   The new version additionally saves monitor spectra for use with the new
%   color conversions based on Stockman & Sharpe (2000) color data.
%
%[colorInfo2, gammaTable] = measureDisplay
%   Returns a colorInfo2 struct that is automatically saved, and optionally
%   a gamma table for monitor calibrations.
%
%   Optional parameters are declared with 'Property', 'Value' settings.
%   They can be in any order as long as pairs are together, any
%   values not specified use defaults as below:
%
%       PROPERTY    DEFAULT     DESCRIPTION
%       'Port'      'COM1'      Windows port for PR-655 only.
%                               future Mac or Linux with /dev/tty ?
%       'Steps'     8           Number of steps to measure, intermediate
%                               steps will be interpolated. 8 means range of
%                               linspace(32, 256, 8)
%       'Device'    (Prompt)    PR655 or i1Pro, future devices as needed
%                               (Prompt): will ask you in Command Window
%       'Screen'    (Last)      Psychtoolbox screen number. Recommended to
%                               use 0 and use computer with only
%                               one monitor if experimental conditions
%                               intended.
%                               (Last): will pick the "last" screen in Display
%                               Settings, if 1 monitor 0 == 1
%       'Manual'    0           0 = automatically measure luminances from
%                               Psychtoolbox ran from the same computer.
%                               1 = only measure when ENTER is pushed, can
%                               use any display including another
%                               computer's monitor, VR headset, etc. Levels
%                               must be manually adjusted per ptb screen
%                               prompts.
%       'Button'    Space       String. Key to push to take measurement and
%                               advance. Must be valid Psychtoolbox name as
%                               determined by KbName(NameOfButton). This
%                               option is only used if Manual == 1
%
%   Dependency:
%       PR655meas_4 replaces Psychtoolbox PR655measspd
%
%   Version history:
%   1.0 by JEV, 2016, based on previous programs
%   2.0+ by SFO, 2021-2022.
%   2.1 2022-8-8 - added XYZ<>LMS transforms
% 
%   colorInfo2 structure format: see colorInfo2 version.txt. This was last
%   checked at 1.5, but trust the text file over this comment.

% % % Warning: Program crashed. Any data that could be saved is in emergency.mat, but it is strongly recommend to debug and rerun. 
% % % > In measureDisplay (line 574) 
% % % Error using measureDisplay (line 276)
% % % PR-655 requested, but connection failed. Restart if you're having issues.
% % % 
% % % Error in measureDisplay (line 276)
% % %             error('PR-655 requested, but connection failed. Restart if you''re having issues.')
 

% TROUBLESHOOTING
%PR655close then cycle
% restart matlab
% check COM

%todo m
%https://www.mathworks.com/matlabcentral/answers/110249-how-can-i-identify-com-port-devices-on-windows

%close all;

Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');

%clearvars -except PRport stepsPerGun;

%% Parse varargin
c = computer;
switch c
    case 'PCWIN64'
    case 'MACI64'
    case 'GLNXA64'
    otherwise
        error('Computer type not recognized.')
end

allowedDevices = {'pr655', 'pr-655', 'i1', 'i1pro'};
%availablePorts = serialportlist;
% May want i1Display in future, not needed now and will lack spectrum

p = inputParser;  % Init
addParameter(p, 'Port', 'Null'); % PR-655 only
%todo automate, todo mac
addParameter(p, 'Steps', 8); % Number of measurements per gun, 8 = pixel values linspace(32,256,8)
addParameter(p, 'Device','Null', @(x) ismember(lower(x), allowedDevices))
addParameter(p, 'Screen', -1, @(x) isnumeric(x)) % -1 == use last
addParameter(p, 'Manual', 0);
addParameter(p, 'Button', 'Space');

%todo ignore port if i1?
parse(p, varargin{:});

% Get local variables
port = upper(p.Results.Port);
stepsPerGun = p.Results.Steps;
manualMode = p.Results.Manual;
button = KbName(p.Results.Button);

% Specify numeric device index for ease of reading
device = lower(p.Results.Device); % Determine device, PR-655 or i1Pro
devNum = -1;
if contains(port,'COM')
    % Assume PR-655
    disp('Port is specified by user. Assuming you are using PR-655.')
    device = 'pr655';
    %devNum = 1;
end

if strcmpi(device, 'pr-655') || strcmpi(device, 'pr655')
    devNum = 1;
elseif strcmpi(device, 'i1') || strcmpi(device, 'i1pro')
    devNum = 2;
elseif strcmpi(device, 'test')
    devNum = 0;
    manualMode = 1;
elseif strcmpi(device, 'null')
    fprintf(['\nSpectroradiomter not specified. Select one of the following:\n\n' ...
        '1 Photo Research PR-655\n2 X-Rite i1Pro\n']);
    devNum = input('   Device: '); % OK to assume numeric
elseif isempty(devNum) || ~ismember(devNum, [1 2]);
    error('Invalid device.');
else
    error('Invalid device');
end

% Auto-detect port for PR-655
if devNum == 1
    %todo
end


%% Measure
try
    if ~manualMode; HideCursor; end % May be changed, no cursor makes manual hard
    % Add path, for later xyz2xyy() etc
    % todo debug this
    %!
%     [directory,~,~] = fileparts(mfilename('fullpath')); % Get where this file is
% 
%     fullPath = genpath(directory);
%     addpath(fullPath);

    %% Prompt for monitor & computer names

    commandwindow;
    monitorID = input('Please enter the name of the monitor you''re calibrating: ','s');
    computerID = input('Please enter the name of the computer you''re using to calibrate: ','s');
    ShowCursor;

%     %% Prompt for fundamentals and color matching functions
%     %todo implement csv
%     funds = '-1';
%     resps = {'y','n', ''};
%     while ~strcmpi(funds, resps)
%         funds = input('Cone fundamentals will be Stockman & Sharpe (2000) 2-degree by default.\nPress ENTER or Y to accept or N to choose another.\n','s');
% 
%         %Default file names 
         matFileFundamentals = 'cfs.mat';
         matFileCMF = 'cmfs.mat';
% 
%         %todo redo?
%         % Default file paths
%         %         dirFundamentals = strcat(directory, '\Fundamentals\');
%         %         dirCMF = strcat(directory, '\CMF\');
%         dirFundamentals = fullfile(pwd,'Fundamentals');
%         dirCMF=fullfile(pwd, 'CMF');
%         % Default fundamentals and CMF names
         strCfsToUse = 'CF_StockmanSharpe_2deg';
%         cmfName = 'CMF_StockmanSharpe_2deg';
% 
%         %         % Default fundamentals and CMF matrices
%         %         cfMat = eval(cfName);
%         %         cmfMat = eval(cmfName);
% 
%         % Default extensions
% %         extFundamentals = '.mat';
% %         extCMF = '.mat';
%     end
% 
%     % Get file name elements if default not used
%     if strcmpi(funds, 'n')
%         % Change default .mat .csv files
%         [matFileFundamentals, dirFundamentals] = uigetfile({'*.mat', 'MAT-files (*.mat)'; ...
%             '*.csv', 'Comma-separated values file (*.csv)'}, ...
%             'Choose fundamentals file'); %todo .csv?
%         [matFileCMF, dirCMF] = uigetfile({'*.mat', 'MAT-files (*.mat)'; ...
%             '*.csv', 'Comma-separated values file (*.csv)'}, ...
%             'Choose CMF file'); %todo .csv?
% 
%         % Get extensions
%         [~, ~, extFundamentals] = fileparts(strcat(dirFundamentals, matFileFundamentals));
%         [~, ~, extCMF] = fileparts(strcat(dirCMF, matFileCMF));
%     end
% 
%     %% Load cone fundamentals
%     % Get variables before loading
%     variablesNow = who;
     %load(strcat(dirFundamentals, filesep, matFileFundamentals));
     load(matFileFundamentals);
    
% 
%     % Get variables that were loaded
%     if strcmpi(funds, 'n')
%         variablesAfter = setxor(variablesNow, who);
%         variablesAfter(end) = []; % Don't watch variablesNow
%         % Prompt for new files
%         numNewFiles = numel(variablesAfter);
%         fprintf('The .mat file contains the following cone fundamentals.\n');
% 
%         for i = 1:numNewFiles
%             fprintf('    %d: %s', i, variablesAfter{i});
%             fprintf('\n');
%         end
%         fileNumToLoad = input('Which do you want to use?\n');
% 
%         % Find index, load variable
%         strCfsToUse = variablesAfter{fileNumToLoad};
% 
%         % Remove kept variable from list, delete the rest
%         %variablesAfter(fileNumToLoad) = [];
% 
%         cfs = eval(strCfsToUse); % Get matrix from string
%         clear(variablesAfter{:}); % Clear unused fundamentals
%     else
         cfs = eval(strCfsToUse);
%     end
%     clearvars variablesNow variablesAfter
% 
%     %% Load color matching functions
%     % Get variables before loading
%     variablesNow = who;
     %load(strcat(dirCMF, filesep, matFileCMF));
     load(matFileCMF);
% 
%     % Get variables that were loaded
%     if strcmpi(funds, 'n')
%         variablesAfter = setxor(variablesNow, who);
%         variablesAfter(end) = []; % Don't watch variablesNow
%         % Prompt for new files
%         numNewFiles = numel(variablesAfter);
%         fprintf('The .mat file contains the following color matching functions.\n');
% 
%         for i = 1:numNewFiles
%             fprintf('    %d: %s', i, variablesAfter{i});
%             fprintf('\n');
%         end
%         fileNumToLoad = input('Which do you want to use?\n');
% 
%         % Find index, load variable
%         strCMFsToUse = variablesAfter{fileNumToLoad};
strCMFsToUse = 'CMF_StockmanSharpe_2deg';
cmf = eval(strCMFsToUse);
% 
%         % Remove kept variable from list, delete the rest
%         %variablesAfter(fileNumToLoad) = [];
%         cmf = eval(cmfName);
%         clear(variablesAfter{:});
%     else
%         cmf = eval(cmfName);
%     end
% 
%     fprintf('\n\n\n'); % Add spacing between any previous output
% 
%     %todo csv etc?

    %% Initialize screen stuff
    AssertOpenGL;

    screenNumber = p.Results.Screen;
    if screenNumber == -1 % Override if not specified
        screenNumber = max(Screen('Screens'));
    end

    [w, screenRect] = Screen('OpenWindow', screenNumber, [0 0 0]); %open a window

%     load('h3.mat','gammaTable')
%     gt = gammaTable;
%     clearvars gammaTable;
%     Screen('LoadNormalizedGammaTable', w, gt);

    screenWidth = screenRect(3); %in pixels
    screenHeight = screenRect(4); %in pixels

    xCenter = screenWidth/2; %screen middle x
    yCenter = screenHeight/2; %screen middle y

    maxGunLvl = WhiteIndex(w); % 255 on 8-bit
    minGunLvl = BlackIndex(w); % Should be 0

    %% Initialize Devices

    % Start listening to keyboard for ESC
    KbQueueCreate;
    KbQueueStart;

    DrawFormattedText(w, 'Connecting to spectroradiometer...', 'center', 'center', maxGunLvl);
    Screen('Flip',w);
    WaitSecs(1)

    if devNum == 0
        % Nothing
    elseif devNum == 1
        % Connect to PR655
        PRconnected = 4; %this number signifies model 655
        retval = PR655init(port);
        if ~strcmpi(retval,' REMOTE MODE')
            error('PR-655 requested, but connection failed. Restart if you''re having issues.')
            sca
        end

    elseif devNum == 2
        % Connect to i1Pro
        isConnected = I1('IsConnected');
        if ~isConnected; error('Check that i1Pro is connected. Restart if you''re having issues.'); end

        % Prompt user to set up i1Pro for calibration.
        %Screen('FillRect', w, maxGunLvl, [xCenter-10, yCenter-10, xCenter+10, yCenter+10]);
        DrawFormattedText(w,['Connection complete. Please place the ' ...
            'i1Pro over the calibration circle and hit any key.\n' ...
            'Be sure to avoid touching the white circle and ' ...
            'close the calibration door when finished.'], ...
            'center', 40, maxGunLvl);
        Screen('Flip',w);
        KbQueueFlush;
        KbQueueWait;

        % Calibrate
        I1('Calibrate');


        %         [~, k] = KbWait;
        %         if k == KbName('ESC')
        %             sca
        %             clear
        %             return
        %         end
    end
    if devNum == 0
        Screen('FillRect',w,maxGunLvl,[xCenter-10,yCenter-10,xCenter+10,yCenter+10]);
        Screen('DrawLines', w, [xCenter - 100, yCenter; xCenter + 100, yCenter; ...
            xCenter, yCenter - 100; xCenter, yCenter + 100]');
        DrawFormattedText(w,['Connection complete. Please position the ' ...
            'telescope on the center of your display.\n' ...
            'Put up a color-adjustable image (e.g. MS Paint fill) with the ' ...
            'correct color level as prompted.\n' ...
            'Press any key when ready.\n' ...
            'You may hit ESC to quit at any time.'], ...
            'center', 40, maxGunLvl);
        Screen('Flip',w);
    elseif devNum == 1
        % Prompt user to set up PR655 for measurement, next section
        Screen('FillRect',w,maxGunLvl,[xCenter-10,yCenter-10,xCenter+10,yCenter+10]);
        Screen('DrawLines', w, [xCenter - 100, yCenter; xCenter + 100, yCenter; ...
            xCenter, yCenter - 100; xCenter, yCenter + 100]');
        if manualMode
            DrawFormattedText(w,['Connection complete. Please position the ' ...
                'telescope on the center of your display.\n' ...
                'Put up a color-adjustable image (e.g. MS Paint fill) with the ' ...
                'correct color level as prompted.\n' ...
                'Press any key when ready.\n' ...
                'You may hit ESC to quit at any time.'], ...
                'center', 40, maxGunLvl);
        else
            DrawFormattedText(w,['Connection complete. Please position the ' ...
                'telescope so that it''s focused\non the white spot in the ' ...
                'center of the screen.\nPress any key when ready.\n'  ...
                'You may hit ESC to quit at any time.'], ...
                'center', 40, maxGunLvl);
        end
        Screen('Flip',w);


    elseif devNum == 2
        % Prompt user to set up i1Pro for measurement, next section
        Screen('FillRect',w,maxGunLvl,[xCenter-10,yCenter-10,xCenter+10,yCenter+10]);
        if manualMode
            DrawFormattedText(w,['Connection complete. Please place the ' ...
                'i1Pro over the display you wish to measure\n' ...
                'in the cradle and with the counterweight adjusted so the ' ...
                'cradle is flush with the screen.' ...
                '\nPress any key when ready, or ESC to quit.'], ...
                'center', 40, maxGunLvl);
        else

            DrawFormattedText(w,['Connection complete. Please place the ' ...
                'i1Pro over the center of the display you wish to measure\n' ...
                'in the cradle and with the counterweight adjusted so the ' ...
                'cradle is flush with the screen.' ...
                '\nPress any key when ready, or ESC to quit.'], ...
                'center', 40, maxGunLvl);
        end
        Screen('Flip',w);

    end
    KbQueueWait;
    KbQueueFlush;
    startTime = GetSecs;

    %% Declare variables

    nGuns = 3; % Probably never need to change this
    stepSize = (maxGunLvl + 1) / stepsPerGun;       % Will be 1-256 not 0-255
    intensityRange = stepSize:stepSize:maxGunLvl+1;
    lum = minGunLvl;

    rawOutput = NaN(stepsPerGun,nGuns);
    normOutput = NaN(stepsPerGun,nGuns);
    xyL = NaN(nGuns,3);
    XYZMatrix = NaN(nGuns,stepsPerGun, 3);
    CIEx = NaN(nGuns,1);
    CIEy = NaN(nGuns,1);
    gammaTable = NaN(256,nGuns);

    % Spectral recordings, new 2.x
    % Set spectral range, possible or necessary to automate?
    if devNum == 1
        x = 380:4:780;
        % IMPORTANT: see below when spectrum is measured
    elseif devNum == 2
        x = 380:10:730;
    end
    spect = NaN(size(x,2), nGuns, stepsPerGun);

    %% Measure monitor output

    for eachGun = 1:nGuns
        for intLvl = 1:stepsPerGun %intensity steps
            [~, kp] = KbQueueCheck();
            if ismember(KbName('Escape'), find(kp))
                warning('Program quit by user input.')
                sca
                close all
                return
            end
            i = intensityRange(intLvl);
            KbQueueFlush;
            
            % Draw background
            switch eachGun
                case 1
                    Screen('FillRect',w,[i 0 0]);
                case 2
                    Screen('FillRect',w,[0 i 0]);
                case 3
                    Screen('FillRect',w,[0 0 i]);
            end

            %display luminance and intensity level
            if manualMode
                DrawFormattedText(w,['Last luminance: ' num2str(lum) ' cd/m^2.'...
                    ' Now draw level ' num2str(i) ' of ' num2str(maxGunLvl) ...
                    ' (' num2str(i/(maxGunLvl+1)) ' of 1)\n' ...
                    'and hit key when ready'], 'center',...
                    screenHeight - 40, maxGunLvl);
            else
                DrawFormattedText(w,['Last luminance: ' num2str(lum) ' cd/m^2.'...
                    ' Level ' num2str(i) ' of ' num2str(maxGunLvl+1)], 'center',...
                    screenHeight - 40, maxGunLvl);
            end
            Screen('Flip',w);

            % Wait for ENTER before measuring if manual mode
            if manualMode
                WaitSecs(0.2);
                waiting = 1;
                beep
                while waiting
                    [~, kp] = KbQueueCheck();
                    if ismember(button, find(kp))
                        disp('Taking manual input...')
                        waiting = 0;
                    end
                end
            end
            %let the monitor get back to zero
            if intLvl == 0
                WaitSecs(5);
            end

            % Take a reading
            if devNum == 1
                XYZt = MeasXYZ(PRconnected)'; % Psychtoolbox function, make 1x3
                XYZMatrix(eachGun, intLvl, :) = XYZt;
                %             XYZtemp = MeasXYZ(PRconnected);
                %             XYZMatrix(eachGun,:) = XYZtemp'; %comes out as 3x1, we need 1x3
                lum = XYZt(2); %XYZMatrix(eachGun,intLvl, 2); %grab the luminance value
                rawOutput(intLvl,eachGun) = lum; %save it

                %spect(:, eachGun, intLvl) = PR655measspd;
                spect(:, eachGun, intLvl) = PR655measspd([380 4 101]);
                %spect(:, eachGun, intLvl) = PR655meas_4;
            
                % IMPORTANT: see below when spectrum is measured
                % PR-655 uses 4 nm steps, but Psychtoolbox function
                % PR655measspd() does 5 nm. Why? Can't say. Replaced with
                % PR655_meas_4()
            elseif devNum == 2
                %todo, have to use conversions below?
                I1('TriggerMeasurement'); % Just saves to device
                meas = I1('GetTristimulus');
                xyz = xyy2xyz(meas([2 3 1])); % Have to reorder Lxy > xyL
                XYZMatrix(eachGun, intLvl, :) = xyz;
                lum = xyz(2);
                rawOutput(intLvl, eachGun) = lum;
                spect(:, eachGun, intLvl) = I1('GetSpectrum');
            end

        end
    end

    %% Calculate gamma correction

    DrawFormattedText(w,'Calculating...','center','center',maxGunLvl);
    Screen('Flip',w);

    %normalize luminances by max output
    for eachGun = 1:nGuns
        normOutput(:,eachGun) = rawOutput(:,eachGun) ./ max(rawOutput(:,eachGun));
    end

    gammaTable = zeros(stepsPerGun,3);
    gammaVals = zeros(1,nGuns);
    %calculate inverse gamma function
    for eachGun = 1:nGuns
        lums = normOutput(:,eachGun); %one gun at a time
        int = intensityRange / maxGunLvl; %normalize intensity levels

        %function fitting
        % Ver 1: Requires Psychtoolbox

        %         gammaTable(:, eachGun) = ComputeGammaPow(int, lums')';
        % Simple gamma = x^(1/gamma), other options available in ptb

        % Ver 2: Requires Curve Fitting toolbox
        gf = fittype('x^gf');
        fittedmodel = fit(int',lums,gf);
        gammaVals(eachGun) = fittedmodel.gf; % Get the gamma value
        temp = ((([0:maxGunLvl]'/maxGunLvl))).^(1/fittedmodel.gf); %#ok<NBRAK>
        gammaTable(1:maxGunLvl+1,eachGun) = temp';
    end

    endTime = sprintf('%dm, %ds',floor((GetSecs - startTime)/60), floor(rem((GetSecs - startTime),60)));
    fprintf('\n');
    disp(['Ended at: ' num2str(endTime)]);
    endedAt = datestr(now,'local');

    %calculate xyL from XYZ
    for eachGun = 1:nGuns
        %xyL(eachGun,:) = ConvertColors('xyzxyl',XYZMatrix(eachGun,:)); %%?
        xyLt = xyz2xyy(squeeze(XYZMatrix(eachGun, stepsPerGun, :))');
        xyL(eachGun, :) = xyLt;
        CIEx(eachGun) = xyL(eachGun,1);
        CIEy(eachGun) = xyL(eachGun,2);
    end

    %% Create transformation matrices
    phos = [x' spect(:, :, stepsPerGun)]; % Phosphors aka max gun spectra
    [RGBtoXYZ, XYZtoRGB] = makeRGB_XYZtransform(CIEx, CIEy);%, [rawOutput(end,1) rawOutput(end,2) rawOutput(end,3)]);
    [RGBtoLMS, LMStoRGB] = makeRGB_LMStransform(phos);%, cfs);
    [XYZtoLMS, LMStoXYZ] = makeXYZ_LMStransform();
    %% Create calibration structure

    colorInfo2 = struct;

    % Import versioon from text file. Only need to update the text file
    % thereafter.
    versionFile = fopen(fullfile(pwd,'colorInfo2 version.txt'),'r');
    ci2ver = fscanf(versionFile, '%c');
    fclose(versionFile);
    colorInfo2.Version = ci2ver;

    colorInfo2.CalibrationDate = endedAt;
    colorInfo2.Monitor = monitorID;
    colorInfo2.ComputerUsed = computerID;
    colorInfo2.RefreshRate = Screen('FrameRate',w);
    colorInfo2.XYZ_Max = XYZMatrix;
    %colorInfo2.RGB_Max = inv(XYZMatrix);
    colorInfo2.CIEx = CIEx';
    colorInfo2.CIEy = CIEy';
    colorInfo2.MaxLuminance = [rawOutput(end,1) rawOutput(end,2) rawOutput(end,3)];
    colorInfo2.Resolution = [num2str(screenWidth) 'x' num2str(screenHeight)];
    colorInfo2.rawOutput = rawOutput;
    colorInfo2.normOutput = normOutput;
    colorInfo2.ReferenceWhite = sum(XYZMatrix);
    %colorInfo2.ColorMatchingFunctions = LoadColorMatchingFunctions();


    % New stuff
    colorInfo2.Wavelengths = x;
    colorInfo2.Spectrum = spect; % stepsPerGun x 3 for entire spectrum of levels
    colorInfo2.Phosphors = phos; % Max gun level, for conversions. Redundant
    colorInfo2.Lum = NaN; % Todo Empty space for MB conversions. todo Might be doable here?
    colorInfo2.DKL = [NaN NaN NaN]; % Todo Empty space for MB conversions
    %colorInfo2.FundamentalNames = strCfsToUse;
    %colorInfo2.Fundamentals = cfs; % Todo no reason to have separate cmf
    colorInfo2.ColorMatchingFunctions = cmf;
    colorInfo2.RecordingDevice = device;
    colorInfo2.Gamma = gammaVals;
    % Conversion matrices,
    colorInfo2.RGB_XYZMatrix = RGBtoXYZ;
    colorInfo2.XYZ_RGBMatrix = XYZtoRGB;
    colorInfo2.RGB_LMSMatrix = RGBtoLMS;
    colorInfo2.LMS_RGBMatrix = LMStoRGB;
    colorInfo2.XYZ_LMSMatrix = XYZtoLMS;
    colorInfo2.LMS_XYZMatrix = LMStoXYZ;

    Screen('CloseAll');

    %create axis variables
    axisR = interp1(intensityRange,normOutput(:,1),minGunLvl:maxGunLvl);
    axisG = interp1(intensityRange,normOutput(:,2),minGunLvl:maxGunLvl);
    axisB = interp1(intensityRange,normOutput(:,3),minGunLvl:maxGunLvl);

    % Plot gamma
    figure; hold on;
    plot(minGunLvl:maxGunLvl,axisR,'r');
    plot(minGunLvl:maxGunLvl,axisG,'g');
    plot(minGunLvl:maxGunLvl,axisB,'b');
    plot(minGunLvl:maxGunLvl,gammaTable(:,1),'r--');  %%%bad
    plot(minGunLvl:maxGunLvl,gammaTable(:,2),'g--');
    plot(minGunLvl:maxGunLvl,gammaTable(:,3),'b--');
    ylabel('Percent of gun maximum')
    xlabel('Levels of guns')
    title('Gun normalized luminances and their gamma inverse')
    axis square
    legend('Red gun','Green gun','Blue gun','Red gamma','Green gamma','Blue gamma','Location','SouthEast');

    % Plot spectra
    figure; hold on;
    plot(x, spect(:, 1, stepsPerGun), 'r'); % Plot max red
    plot(x, spect(:, 2, stepsPerGun), 'g'); % Plot max green
    plot(x, spect(:, 3, stepsPerGun), 'b'); % Plot max blue
    ylabel('w/sr/m^2')
    xlabel('Wavelength (nm)')
    title(sprintf('Phosphor spectra of %s', monitorID'))
    axis square

    saveName = input('Please choose a sensible name for your calibration file: ','s');
    save(saveName,'colorInfo2','gammaTable');

    if devNum == 1; PR655close; end
    disp('All done!');
    ShowCursor;
catch
    save emergency;
    if devNum == 1
        PR655close;
    elseif devNum == 2
        % NothingZ
    end
    warning('Program crashed. Any data that could be saved is in emergency.mat, but it is strongly recommend to debug and rerun.')
    Screen('CloseAll');
    psychrethrow(psychlasterror); %rethrow the error message
    ShowCursor;

    
end
end