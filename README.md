# ColorConversions

## 1. Description

The Color Conversion Toolbox is primarily used for conversion between color spaces
used in vision science. An example is an experiment that responds to user input by changing
a stimulus' color in a working or opponent space such as DKL or Lab, and then converting the
new color to a computer-usable space such as RGB. Additionally, this toolbox is intended to
implement conversions based on the Stockman & Sharpe (2000) cone fundamentals which are more
physiologically accurate than the standard CIE standards previously used to build the color spaces.

Usage Notes:
The conversions are intended to work with recorded spectra specific to the monitor you will
be using for your experiment. The function measureDisplay() is used to automatically measure
a display and save a structure (colorInfo2) containing the necessary data for accurate color
conversions. measureDisplay() is intended to work with either Photo Research PR-655 or X-Rite i1Pro
spectroradiometers.
If you do not have a spectroradiometer or just wish to test code, previously recorded monitor data
is available in the \Recorded monitor phosphors\ folder. For example: MSS310_crt_phosphors.mat
is recorded from an experimental CRT monitor (todo). Using these default files will not be valid
for actual experimental recording but will allow debugging experimental code before measuring your
monitor.

Once a colorInfo2 structure is loaded into the Workspace, it will be accessed by the various functions.
See the help for each function, but generally they are set up to run with scaled color trivalues in the
0:1 double range, or the signed double range of opponent color spaces. By default, most functions can be
run with just this color info, and optionals are assumed (e.g. Stockman & Sharpe as opposed to other CIE
standards). If options need to be changed, they are specified with paired 'Property', ValueToSetTo
options.

## 2. How to use - Description

You will need a few things to run an experiment:
  1. These functions, download/clone from Github for the latest version
  2. A .mat file, of any name, that contains the structure colorInfo2. This is obtained through
the measureDisplay() function. If you are using a new monitor, a spectroradiometer is necessary, either a
Photo Research PR-655 or a X-Rite i1Pro.  See **spectro_setup.txt** for instructions on how to install drivers
and use these.
  3. If you do not have access to a spectroradiometer or haven't measured the monitor you will be using, the
folder ** \Saved colorInfo2\ ** has some previously recorded data. Note that these will be inaccurate for
experimental purposes unless you use the same monitor, but monitors of the same type
(e.g. Cambridge Research Systems Display++) may be similar.

## 3. How to use - examples

The first step to running an experiment using these conversions is to load the appropriate files. The easiest way
is to load the Project file *ConvertColors.prj* To automate this, you can edit the startup.m contained in your
Psychtoolbox directory \PsychInitialize\ folder (don't use *startup.m* in the MATLAB folders). Edit the file and add the line:
*uiopen(PATH_TO_CONVERSIONS\cc\ConvertColors.prj',1)*
and it will load next startup. If you are using an older version of MATLAB or wish to avoid loading this every time, you can
instead add to the top of your code:
*addpath(genpath(PATH_TO_CONVERSIONS))*
*load('parameter_options.mat')*

## 4. Conversions implemented - WIP

Implemented spaces
                        TO SPACE  
                RGB LMS DKL MB  XYZ xyY Luv Lab HSV C02  
            RGB  x   o   o       o   o   o   o   o  
            LMS  o   x   o       o   o   o   o  
            DKL  o   o   x       .   .   .   .  
 FROM       MB               x  
            XYZ  o   o   x       x   o   o   o  
            xyY  o   o   .       o   x   .   .  
            Luv  o   o   .       o   .   x  
            Lab  o   o   .       o   .       x  
            HSV  o  
            C02  

x - n/a  
o - implemented, in debug  
. - not working, in progress

todo: check RGB saturation
Illuminants appear correct, but issues with D50?

C02 = CIECAM02, in progress and awful

## 5. What are the color spaces?

- Spaces used by computers
  - RGB: monitor [Red, Green, Blue] gun percentages  
	Monitor gamuts are greatly constrained vs. full color spaces.  
	In the context of these functions, value luminances are defined by recorded monitor gamuts.
	Monitors typically do not use a linear output, so a companding function is needed to adjust luminance
	to correspond with candelas. Default uses the recorded monitor gamma.
  - HSV: Cylindrical system optionally used by most computer drawing programs, where
    H = hue in 0:360 degree hue angles, S = 0:1 saturation or distance from white, and
    V = value or distance from black/brightness
  - HSL? Hue Saturation Lightness
  
- Physiological spaces
  - LMS: Human cone photoreceptor sensitivites at [Long, Medium, Short] wavelengths
  - DKL: DKL space based on Derrington, Krauskopf, Lennie (1984) recorded from macaque
    LGN. Based on target on background stimulus, so a background color is required.
	Default is [L-M, S-LM, Luminance] values, though this can be adjusted for different standards
  - MB: MacLeod-Boynton (1979) [Long, Medium, Short] sensitivites. L and S are necessary,
    where M == (1 - L) but is included for consistency.
	
- CIE standards
  - XYZ: The base CIE 1931 [X, Y, Z] color space based on human psychophysics. When using fundamentals
	or color matching functions such as Stockman & Sharpe, this is an "XYZ-like" space.
  - xyY: CIE 1931 [x, y, Y] chromaticity coordinates,  where xyY(3) == XYZ(2) and represents
    luminance of a color.
  - Luv: CIE 1976 [L*, u*, v*] space. A rescaling of xyY that allows for equal
    discriminability of colors across the color space as long as [x, y] change is the
    same. L represents the Luminance and is relative to a standard illuminant loaded from
    the illuminants.mat file, D65 natural daylight is default.
  - uv: CIE 1976 u' v' chromaticity coordinates, convertible from L*u*v*
  - Lab: CIE 1976 [L, a, b] opponent color space where:  
    +a is more red / -a is more green  
    +b is more yellow / -b is more blue.  
    L is the same as in Luv and is D65 by default.
	
    Both Luv and Lab can optionally be output in LCHuv or LCHab cylindrical values instead of
    Cartesian Luv/Lab, where L == L, C == chroma or saturation, and H == hue angle
  - CIECAM02 - 2002 update of CIECAM97. This CAM - Color Appearance Model - accounts for
    the appearance as observed by humans rather than low-level physiology. This includes
    models of adaptation, simultaneous contrast, etc. The direct step is a conversion from
    XYZ

## 6. Future Plans

Need:
1. Priority: color picker separate app ("I want dkl coordinates x,y at C candelas, show me the color patch")
2. DKL -> WP, axis scaling
3. CIECAM02
4. HSL?

Could add:
Color temperature
Estimated dominant/complementary wavelength?

## 7. Folder structure and use

### \Functions\DirectConversions\  

These functions contain the calculations needed to convert from one space to another.  

**LMS conversions**  
- rgb2lms.m  
- lms2rgb.m

**XYZ conversions**  
*Call with rgb2xyz/xyz2rgb, which overrides built-in functions*  
- rgb2xyz.m  
- xyz2rgb.m  
- rgbTOxyz.m  
- xyzTOrgb.m

- lms2xyz.m
- xyz2lms.m

**xyY conversions**  
- xyz2xyy.m  
- xyy2xyz.m

**MacLeod-Boynton conversions**  
- lms2mb.m  
- mb2lms.m

**DKL conversions**  
- lms_dkl.m - *Simplifies code by combining both conversions, but use lms2dkl/dkl2lms to call this*  
- lms2dkl.m  
- dkl2lms.m  

- mb2dkl.m  
- dkl2mb.m

**Webster lab (rescaling of DKL) conversions**  
- dkl2mw.m  
- mw2dkl.m

- mw2mb.m  
- mb2mw.m

**Luv conversions**  
- xyz2luv.m - optional second output returns u' v'  
- luv2xyz.m  

*These convert between Luv and u' v' chromaticity, given a fixed L*  
- luv2luvchrom.m  
- luvchrom2luv.m

**Convert xy <> u'v' chromaticities, luminance unspecified**  
- uv2xy.m  
- xy2uv.m

**Lab conversions**  
*Call with lab2xyz/xyz2lab, which overrides built-in functions*  
- lab2xyz.m  
- xyz2lab.m  
- labTOxyz.m  
- xyzTOlab.m

**Luminance conversions**  
*Converts between Y and L\*, without chromaticity info*  
- l2y.m  
- y2l.m


**HSV coversions**  
*Call with rgb2hsv/hsv2rgb, which overrides built-in functions*	 
- rgb2hsv.m  
- rgbTOhsv.m  
- hsv2rgb.m  
- hsvTOrgb.m

### \Functions\WrapperFunctions\

These functions are convenience wrappers for conversion between more distant spaces, making the actual steps
opaque to the user.

- dkl2rgb.m  
- dkl2xyz.m  
- lab2lms.m  
- lab2rgb.m  
- labTOrgb.m  
- lms2lab.m  
- lms2luv.m  
- lms2xyy.m  
- luv2lms.m  
- luv2rgb.m  
- mb2rgb.m  
- mb2xyz.m  
- mw2lms.m  
- mw2rgb.m  
- mw2xyz.m  
- rgb2dkl.m  
- rgb2lab.m  
- rgb2luv.m  
- rgb2mb.m  
- rgb2mw.m  
- rgb2xyy.m  
- rgbTOlab.m  
- xyy2lms.m  
- xyy2luv.m  
- xyy2rgb.m  
- xyz2dkl.m  
- xyz2mb.m  
- xyz2mw.m
	
### \Functions\Shared\

Important functions used by many other functions  

- iparse.m - parses almost all conversion input, allowing for simplified code and sharing of optional parameters  
- liveLabLuv.m - helper for Lab and Luv conversions  
- loadCI.m - load colorInfo2 file from main workspace to function  
- loadFundamentals.m - load a different cone fundamental from cfs.mat  
- loadWhitePoint.m - load a white point XYZ value from illuminants.mat. Optionally convert from xyY to another space. Default = D65 2-degree  
- rescaleRange.m - some spaces like XYZ can be specified so that Y is either in the 0:1 or 0:100 range. This attempts to convert between these, if output is off by a large factor consider manually implementing this
		
### \Functions\Measurements\

- measureDisplay.m - measure a monitor or other light display with PR-655 or i1Pro, with optional  
parameters for manual measurement, step sizes, etc.  
- test_colors.m - work in progress, for testing calculations and measuring the actual output
	
### \Functions\ObjectClasses\

- trival.m - classdef to create trivalues for most color spaces. Declare using:  
 *myVal = trival('SpaceName', [3 values], Luminance)* (or cell array) where:  
'SpaceName' - arbitrary value for the color space currently used  
[3 values] - Nx3 trivalues you want to use  
Luminance - luminance in cd/m^2, may be redundant with third trivalue but should always be included  
- spectrum.m - WIP for spectral data, first column is wavelength or specified separately

### \Functions\ShapeConversions\

Convert within spaces to different shapes or reorderings
- ajustAngles.m - adjust DKL or MW space luminances given experimentally-derived individual minimum motion settings
	
*Convert DKL or MW between spherical degrees (default order: [Elevation/Luminance, Angle/Hue, Radius/Contrast]) and Cartesian radians [L-M/red-green X-axis, S-LM/blue-yellow Y-axis, Luminance/Z-axis]*  
*Other functions mostly expect Cartesian radians*  
- dkl2cart.m - spherical to Cartesian  
- dkl2sph.m - Cartesian to spherical
		
*Convert Lab<>LCHab and Luv<>LCHuv*  
- fromCylindrical.m  
- toCylindrical.m
	
*Implemented in individual conversions, may be removed in the future* 
DKL_flip.m  
DKL_reorder.m  
DKL_working_space.m

### \Functions\Transforms\

Generate 3x3 matrices for converting between two spaces
- makeRGB_LMStransform.m - between RGB and LMS
- makeRGB_XYZtransform.m - between RGB and XYZ
- makeXYZ_LMStransform.m - between LMS and XYZ, derived from RGB/LMS and RGB/XYZ

- chromaticAdaptation.m - convert XYZ in a given white point to XYZ values relative to another,	included in xyz<>rgb conversions to match source and monitor white points.
	
- makeCVDmatrix.m - matrix simulating color vision deficiencies, per Kaiser & Boynton pg.~557
	
	
### \Functions\SpectralConversions\

- interpolateRange.m - interpolate discrete range of spectral data to default 1-nm steps using spline interpolation. Legacy; Sprague should generally be used instead.
- interpolateSprague.m - interpolate discrete range of spectral data to default 1-nm steps using Sprague interpolation as recommended by CIE.
- truncRange.m - takes two separate spectra and removes non-overlapping wavelengths. This should be run after interpolation.

*Companding functions - apply appropriate function to convert to/from linear RGB values and RGB requested of monitor.*  
*E.g. [0.5, 0, 0] should be half as bright (cd/m^2) than [1 0 0] but won't be on typical monitors. Function allows you to specify 0.5 output and still get the correct luminance.*  
- gammaCompanding.m - default, uses gamma saved in colorInfo2 or user-specified gamma
- sRGBCompanding.m - sRGB appropriate for CRT and some other monitors, uses 2 different curves for regular range and very dim colors.
- LCompanding.m - L* luminance companding, useful in some cases

- setLum.m - adjusts monitor gun percents to better control for correct luminance, should be ON in most cases as default.
- sRGBgamma.m - applies gamma on-the-fly. Not necessary in most cases, use Psychtoolbox **LoadNormalizedGammaTable()** instead

### \Functions\Tools\

Tools used by various functions
- addGamma.m = generate gamma from colorInfo2 if not already recorded. For legacy **measureDisplay()** calculations.
- doNothing.m - does nothing!
- gammaReset.m - restores gamma using PTB **LoadNormalizedGammaTable()**, useful if program crashes etc.
- isEquallySpaced.m - checks that a spectrum has equally-spaced wavelengths
- overloadConversion.m - overloads MATLAB functions such as rgb2xyz()
- tester.m - WIP spectral tester. Remove?

### \Functions\Aliases\

These do nothing on their own, but are for convenience in allowing a flipped name
- makeLMS_RGBtransform.m - alias for makeRGB_LMStransform.m 
- makeLMS_XYZtransform.m - alias for makeXYZ_LMStransform.m
- makeXYZ_RGBtransform.m - alias for makeRGB_XYZtransform.m
- resetGamma.m - alias for gammaReset.m

### \Functions\Verification\

- checkSaturation.m - Checks if an RGB value is saturated. Returns 3 outputs:
1) RGB - RGB values truncated to 0:1 range
2) satFlag - Flags indicating whether values were too high or too low to display on a given monitor
) unclampedRGB - RGB values, original numbers  
User may decide what to do with this information, there is no standard response. An example might be:  


    if all(satFlat,'all') == 1  
        warning('Some RGB values cannot be reproduced on this monitor.');  
        % Decide what to do, crash, ignore, etc.  
    end
	
			
- equateLuminances.m - may not be used much, if an experiment needs to equate luminances between R, G, B guns, this tells you how much green you can get out of a maxed red gun, or how much green or red you can get out of a maxed blue gun, as G > R > B in most cases.
- restoreLumXYZ.m - some conversions or measurements arbitrarily scales the XYZ Y luminance component, this restores it	based on the trival() Luminance value.
-checkMB.m - check MB format, may become obsolete after implementation of trival class.
	
### \Functions\GamutPlots\

Gamut range creation and plotting functions. Many are WIP  
*Find maximum DKL gamut for a given monitor, using iterative (slow) method*  
- dklGamut.m - scale other two axes based on smallest allowed axis
- dklGamut_ind.m - scale three axes independently
	
- mwGamut.m - Webster lab gamut
- plotRGB.m - Plot patches of Nx3 colors
	
# 8. Coding and Contributing to this project
--------------------------------------------
##  - I noticed a bug/I have a request/want to code

You can use the "Issues" tab on Github or report these through email seano@unr.edu
If you'd like to make you own changes, keep everyone in the loop but the project can
be contributed to individually as well. Check out GitHub tutorials first, and you
can use command line Git or integrate with MATLAB using the instructions in
"Using Git with MATLAB.txt"


Approximation of CMFs
https://3dz2.com/minerals/spectrum2color/
