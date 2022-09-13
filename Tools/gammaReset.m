function gammaReset(screen)
%GAMMARESET Fix unrestored monitor gamma
if nargin == 0
    screen = 0;
end

w=Screen('OpenWindow', screen);
DrawFormattedText(w, 'Resetting gamma, please wait...','center','center',[0 0 0]);
Screen('Flip', w);
Screen('LoadNormalizedGammaTable', w, [linspace(0,1,256); linspace(0,1,256); linspace(0,1,256)]');
WaitSecs(2);
sca
end

