clear
load('parameter_options.mat');

colorsRGB = [0.355447380130204	0.135780626402820	0.170998219763508
0.236280437809734	0.148986740073062	0.279441926201508
0.0732695046206601	0.200437236460179	0.167959466092611
0.192373131332485	0.187291802369260	0.0589631084563573
0.343280078768431	0.138575758090486	0.170867246946076
0.234387766031767	0.150640611789682	0.269976596522450
0.0854252534049770	0.197657580409730	0.168090454842657
0.194265564734861	0.185643320353852	0.0685270369093829
0.331113053661449	0.141370049141153	0.170736273416890
0.232495104042095	0.152294212742173	0.260508913056720
0.0975821138687420	0.194877341228279	0.168221442869023
0.196158009944352	0.183994619992967	0.0780814803923225
0.318946314951713	0.144163516663550	0.170605299175396
0.230602451920299	0.153947545957799	0.251038788987292
0.109739946910024	0.192096510345963	0.168352430172281
0.198050466847192	0.182345699271418	0.0876276213799530
0.306779873555255	0.146956177088604	0.170474324221040
0.228709809747267	0.155600614397354	0.241566130870986
0.121898644438273	0.189315078939168	0.168483416753002
0.199942935331784	0.180696556136750	0.0971663803804474
0.294613741253741	0.149748046208844	0.170343348553267
0.226817177605224	0.157253420957319	0.232090837850603
0.134058120027533	0.186533037919119	0.168614402611754
0.201835415288642	0.179047188498200	0.106698494372552];

% colorsRGB=[  0.6104    0.4353    0.4911
%     0.5211    0.4534    0.6117
%     0.3268    0.5147    0.4872
%     0.4643    0.4993    0.3104];

load('illuminants.mat')
wps = fieldnames(si);



%load('417aDPP_new')
%load('home_redo2.mat');
%load('417A_DPP_allinone');
load('h3_f.mat')
%load('BiosemiDPP_PR655.mat');
nColors = size(colorsRGB,1);
currRGB = 1;
debug = 0
manual = 0;
if debug; manual = 1; end
bkgd = [.5 .5 .5];
bkgdLMS = rgb2lms(bkgd);
%% Predfine
XYZ = [];
RGBm = [NaN NaN NaN];
xyY = [NaN NaN NaN];
% LMS = [NaN NaN NaN];
RGBm2 = [NaN NaN NaN];
DKL = [NaN NaN NaN];
% t = table();
XYZz = [];
RGB = struct();
RGB.None = [];
RGB.Gamma = [];
RGB.sRGB = [];
RGB.L = [];
LMS = struct();
LMS.Default = [];
LMS.Old = [];
LMS.MB1 = [];
LMS.OldMB1 = [];
port = 'COM3';
textcolor = [1 1 1];
%% Init PR-655
if ~debug
    PRconnected = 4; %this number signifies model 655
    retval = PR655init(port);
    if ~strcmpi(retval,' REMOTE MODE')
        error('PR-655 requested, but connection failed. Restart if you''re having issues.')
        sca
    end
end

%% PTB
screenNum = max(Screen('Screens'));
win = Screen('OpenWindow', screenNum, bkgd .* 256);

% Screen('LoadNormalizedGammaTable', win, gammaTable);
PsychDefaultSetup(2);
Screen('ColorRange', win, 1, [], 1);

%% Kb
KbName('UnifyKeyNames');
quitKey = KbName('Escape');
measureKey = KbName('Space'); % For testing, MRI does the actual triggering
leftKey = KbName('leftarrow');
rightKey = KbName('rightarrow');
%RestrictKeysForKbCheck([quitKey, measureKey, leftKey, rightKey]); % Only allow these
KbQueueCreate()
KbQueueStart;

while 1
    % Limits
    %fprintf('RGB = (%3.2f, %3.2f, %3.2f\n', currRGB)
    if currRGB < 1; currRGB = 1; beep; end
    if currRGB > nColors; currRGB = 1; beep; end

    %Draw full screen
    Screen('FillRect', win, colorsRGB(currRGB,:));

    %     DrawFormattedText(win, sprintf(['Requested RGB = (%3.2f, %3.2f, %3.2f)\n', ...
    %         'MeasuredXYZ = (%3.2f, %3.2f, %3.2f)'], ...
    %                 colorsRGB(currRGB,:), XYZ), 10, 50, [1 1 1]);

    %         'MeasuredRGB = (%3.2f, %3.2f, %3.2f)\n' ...
    %         'MeasuredLMS = (%3.2f, %3.2f, %3.2f)\n' ...
    %         'MeasuredLMSRGB = (%3.2f, %3.2f, %3.2f)\n' ...
    %         'MeasuredDKL = (%3.2f, %3.2f, %3.2f)'], ...
    %     if colorsRGB(currRGB,:) == [1 1 1]
    textcolor = [0 0 0];
    %     else
    %         textcolor = [1 1 1];
    %     end
    DrawFormattedText(win, sprintf('Requested RGB = (%3.2f, %3.2f, %3.2f)\n', ...
        colorsRGB(currRGB,:)), ...
        10, 50, textcolor);
%     DrawFormattedText(win, sprintf(['Requested RGB = (%3.2f, %3.2f, %3.2f)\n' ...
%         'MeasuredXYZ = (%3.2f, %3.2f, %3.2f)\n' ...
%         'MeasuredRGB = (%3.2f, %3.2f, %3.2f)\n' ...
%         'MeasuredLMS = (%3.2f, %3.2f, %3.2f)\n' ...
%         'MeasuredLMSRGB = (%3.2f, %3.2f, %3.2f)\n' ...
%         'MeasuredDKL = (%3.2f, %3.2f, %3.2f)\n'], ...
%         colorsRGB(currRGB,:), XYZ, RGBm, LMS, RGBm2, DKL), ...
%         10, 50, textcolor);
    Screen('Flip', win);

    if manual
    [~, ~, ~, kc] = KbQueueCheck;
    if kc(leftKey)
        disp('L')
        currRGB = currRGB - 1;
    elseif kc(rightKey)
        disp('r')
        currRGB = currRGB + 1;
    elseif kc(measureKey)
        disp('m')
        %XYZ = [0.1771, 0.0864, 0.5860];
        if ~debug
            XYZ = MeasXYZ(PRconnected)';
            %XYZ = XYZ./100;
            XYZz = [XYZz; XYZ];
            %RGBB = [];
            [~,~,RGBm] = xyz2rgb(XYZ,'Linearizing', 'none');%, 'primaries','srgb');
            RGB.None = [RGB.None; RGBm];
            %RGBB = [RGBB; RGBm];
            [~,~,RGBm] = xyz2rgb(XYZ,'Linearizing', 'srgb');%, 'primaries','srgb');
            RGB.sRGB = [RGB.sRGB; RGBm];
            %RGBB = [RGBB; RGBm];
            [~,~,RGBm] = xyz2rgb(XYZ,'Linearizing', 'gamma');%, 'primaries','srgb');
            RGB.Gamma = [RGB.Gamma; RGBm];
            %RGBB = [RGBB; RGBm];
            [~,~,RGBm] = xyz2rgb(XYZ,'Linearizing', 'l');%, 'primaries','srgb');
            RGB.L = [RGB.L; RGBm];
            %RGBB = [RGBB; RGBm];

            xyY = xyz2xyy(XYZ);
            LMSm = xyz2lms(XYZ);
            LMS.Default = [LMS.Default; LMSm];
            LMSm = xyz2lms(XYZ,'cat','old');
            LMS.Old = [LMS.Old; LMSm];
            LMSm = xyz2lms(XYZ,'mbscale',[1 1 1]);
            LMS.MB1 = [LMS.MB1; LMSm];
            LMSm = xyz2lms(XYZ,'cat','old','mbscale',[1 1 1]);
            LMS.OldMB1 = [LMS.OldMB1; LMSm];
            %[~,~,RGBm2] = lms2rgb(LMS);
           %DKL = lms2dkl(LMS, bkgdLMS);
        end
        disp('man')

        %   responded = 1;
        %             trialsRand.Responses(t) = 1;
        %             trialsRand.RespTimes(t) = s-stt;
    elseif kc(quitKey)

        %
        responded = 1;
        warning('Program quit by user.')
        ShowCursor;
        break
        %sca
    end

    elseif manual == 0 || debug == 0
        XYZt = MeasXYZ(PRconnected)';
        XYZ = [XYZ; XYZt];
        currRGB = currRGB + 1;
        if currRGB > nColors; break; end
    end
end
KbQueueStop;
WaitSecs(1);
if ~debug; PR655close; end
sca
%gammaReset(2);
