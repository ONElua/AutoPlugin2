# Autoplugin 2
Autoplugin for PSVITA
This tool allows you to install/uninstall the following plugins with one click on ux0 or ur0 (ur0 for SD2VITA):

| Plugin | Author |
| ------ | ------ |
| [RemasteredControls](https://github.com/TheOfficialFloW/RemasteredControls) (Adrenaline) | [TheFlow](https://github.com/TheOfficialFloW) |
| [DownloadEnabler](https://github.com/TheOfficialFloW/VitaTweaks) | [TheFlow](https://github.com/TheOfficialFloW) |
| [NoNpDrm](https://github.com/TheOfficialFloW/NoNpDrm) | [TheFlow](https://github.com/TheOfficialFloW) |
| [MiniVitaTV](https://github.com/TheOfficialFloW/MiniVitaTV) | [TheFlow](https://github.com/TheOfficialFloW) |
| [NoPsmDrm](https://github.com/frangarcj/NoPsmDrm) | [frangarcj](https://github.com/frangarcj) |
| [PSVita-StorageMgr](https://github.com/CelesteBlue-dev/PSVita-StorageMgr) | [CelesteBlue](https://github.com/CelesteBlue-dev) |
| [Shellbat](https://github.com/nowrep/vita-shellbat) | [nowrep](https://github.com/nowrep) |
| [Shellsecbat](https://github.com/OperationNT414C/ShellSecBat) | [OperationNT414C](https://github.com/OperationNT414C) |
| [Oclockvita](https://github.com/frangarcj/oclockvita) | [frangarcj](https://github.com/frangarcj) |
| [NoTrophyMsg](https://github.com/TheOfficialFloW/VitaTweaks) | [TheFlow](https://github.com/TheOfficialFloW) |
| [NoLockScreen](https://github.com/TheOfficialFloW/VitaTweaks) | [TheFlow](https://github.com/TheOfficialFloW) |
| [Vitabright](https://github.com/devnoname120/vitabright) (only 3.60 and PSVITA) | [devnoname120](https://github.com/devnoname120) |
| [pngshot](https://github.com/xyzz/pngshot) | [xyz](https://github.com/xyzz) |
| [PSV-VSH MENU](https://github.com/joel16/PSV-VSH-Menu) | [joel16](https://github.com/joel16) |
| [Vflux](https://github.com/Applelo/vFlux) | [Applelo](https://github.com/Applelo) |
| [Repatch](https://github.com/dots-tb/rePatch-reDux0) | [dots-tb](https://github.com/dots-tb) |
| [LOLIcon](https://github.com/dots-tb/LOLIcon) | [dots-tb](https://github.com/dots-tb) |
| [NoAVLS](https://bitbucket.org/SilicaAndPina/noavls) | [SilicaAndPina](https://bitbucket.org/SilicaAndPina/) |
| [ds3vita](https://github.com/xerpi/ds3vita) | [xerpi](https://github.com/xerpi) |
| [ds4vita](https://github.com/xerpi/ds4vita) | [xerpi](https://github.com/xerpi) |
| [PSVita USB streaming! (UVC USB Video Class)](https://github.com/xerpi/vita-udcd-uvc) | [xerpi](https://github.com/xerpi) |
| [DSmotion](https://github.com/OperationNT414C/DSMotion) | [OperationNT414C](https://github.com/OperationNT414C) |
| [VitaGrafix](https://github.com/Electry/VitaGrafix) | [Electry](https://github.com/Electry) |
| [usbmc](https://github.com/yifanlu/usbmc) | [Yifan Lu](https://github.com/yifanlu) |
| [Custom Splash Boot](https://github.com/Princess-of-Sleeping/PSP2-CustomBootSplash) | [Princess of Sleeping](https://github.com/Princess-of-Sleeping) |
| [FuckPSSE](https://bitbucket.org/SilicaAndPina/fuckpsse) | [SilicaAndPina](https://bitbucket.org/SilicaAndPina/) |
| [PSMPatch](https://bitbucket.org/SilicaAndPina/psmpatch) | [SilicaAndPina](https://bitbucket.org/SilicaAndPina/) |
| [ITLS-Enso](https://github.com/SKGleba/iTLS-Enso) | [SKGleba](https://github.com/SKGleba)|
| [TropHAX](https://bitbucket.org/SilicaAndPina/trophax) | [SilicaAndPina](https://bitbucket.org/SilicaAndPina/) |
| [noPsmWhitelist](https://bitbucket.org/SilicaAndPina/nopsmwhitelist) | [SilicaAndPina](https://bitbucket.org/SilicaAndPina/) |
| [AnalogStickDisable](https://github.com/Hack-Usagi/AnalogStickDisable) | [Hack-Usagi](https://github.com/Hack-Usagi) |
| [reF00D](https://github.com/dots-tb/reF00D) | FAPS Team |
| [FreePSM](https://bitbucket.org/SilicaAndPina/freepsm/src/master/)  | [SilicaAndPina](https://bitbucket.org/SilicaAndPina/freepsm/src/master/) |
| [LOLITA 500/444](https://github.com/teakhanirons/lolita500)  | [teakhanirons](https://github.com/teakhanirons) |
| [NoPowerLimitsVita](https://github.com/Electry/NoPowerLimitsVita)  | [Electry](https://github.com/Electry) |
| [VGi](https://github.com/Electry/VGi)  | [Electry](https://github.com/Electry) |

# Optional settings
- Update plugins Online
- Update Languages Online
- Now you can check yhe readme file online for most of the included plugins
- Download/Install ITLS-Enso and Battery fixer (vpk)
- Set a Custom Image (Custom Boot Splash is required)
- Set a Custom Warning Message (Custom Warning is required)
- Set Level Transparent (Transparent Impose is required)

# Small note for Splash image
To load a custom image at boot, the image must be in png format sized to 960X544 named splash.png and it must be placed in the path ux0:CustomBootsplash/splash.png
You no longer need to add the line:
 "- load ur0: tai / custom_boot_splash.skprx"
# Small note for the translation of the languages using non-standard characters
Download the **font.pgf** file(here https://github.com/ONElua/Autoplugin2/blob/master/font/font.pgf ) and insert it in the path **ux0:data/Autoplugin2/font** (Remember if the font folder does not exist you have to create it) 
This fixes missing non-standard characters, not found at english charset. Those will show as "_" instead of the unusual letter.

### Changelog 1.08 ###
- Add MiniVitaTV by TheOfficialFloW beta 0.4
- Add more p lugins from CBPS: EmergencyMount, MAFUinput, TrophyShot, BootSound, ScoreHax, Sysident, DePlayEnabler.
- Add Persona 4 Golden HD plugin (Vita Plugins).
- Fix VitaGrafix PatchList.

### Changelog 1.07 ###
- Minnor fix sharpscale install.

### Changelog 1.06 ###
- Lib tai updated.
- Reimplemented the new tai library in all parts of the application.
- Re-implemented plugin manager.
- Added support to update plugins of PSP.
- Now the plugins will be installed in ur0 only.
- If you have a config.txt in some other partition, this will be unified with ur0.
- If you have a config.txt with any fault, such as an error of lowercase and capital letters or lack of parts of the system or absence of it, it will be repaired / written.

### Changelog 1.03 ###
+ Added support to install extra applications that require some plugins<br>

### Changelog 1.02 ###
- Fix missing string in Chinese and Turkish Systems<br>
- Update Russian by Yoti<br>
- Update Italian by TheHeroGAC<br>
- Update Chinese by yexun1995<br>

### Changelog 1.01 ###
- Chinese font download path error fixed<br>
- New option to switch between custom fonts<br>
- Fix missing config.txt for pkgj (no folder found) and removed line for PSM Games<br>
- New Languages:<br>
  Yoti/Aleksandr112 for translation in Russian<br>
  Chronoss09 for translation in French<br>
  Schn1ek3 for translation in German<br>
- Update Spanish by gvaldebenit<br>
- Update English by Gadgetoid<br>

# Credits:
 Thank you
- Team OneLua

	*([BaltazaR4](https://twitter.com/baltazarregala4)).*<br>
	*([HAM](https://twitter.com/holdandmodify)).*<br>
	*([Dev Devis](https://twitter.com/DevDavisNunez)).*<br>
	*([gdljjrod](https://twitter.com/gdljjrod)).*<br>
	*RG<br>

- HAM for new resources
- TheFloW
- yifanlu
- qwikrazor87
- CelesteBlue
- FAPS Team
- devnoname120
- bamhm182
- nowrep
- frangarcj
- xyzz
- xerpi
- Rinnegatamante
- Applelo
- joel16
- dots-tb
- Princess of sleeping
- Hack-Usagi
- SilicaAndPina
- OperationNT414C
- Electry
- SKGleba
- chronoss09
- Yoti
- teakhanirons
# Testers:
- *([NanospeedGamer](https://twitter.com/NanospeedGamer)).*<br>
- *([HAM](https://twitter.com/holdandmodify)).*<br>
- *([BaltazaR4](https://twitter.com/baltazarregala4)).*<br>
# Translators:
- HAM/NanospeedGamer/gvaldebenit for translation in Spanish
- Kouchan for translation in Japanese
- yexun1995 for translation in Chinese
- theheroGAC for translation in Italian
- Chronoss09 for translation in French
- Schn1ek3 for translation in German

## Donation ##
In case you want to support the work of the team on the vita, you can always donate for some coffee. Any amount is highly appreciated:

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://ko-fi.com/R6R6XDBE)
