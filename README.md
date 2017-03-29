# FontReplace

FontReplace is a plugin for replacing the system fonts on macOS 10.12 Sierra, by any other font installed on the system.

![Screenshot](screenshot.png)

### Getting started
* System Integrity Protection must be disabled in order for this to work.
* Move FontReplace.settings.plist to /Library/Preferences
* Move libFontReplace.dylib to /Library
* Use the following command to load the plugin:
```
launchctl setenv DYLD_INSERT_LIBRARIES /Library/libFontReplace.dylib
```
* Move FontReplace.launch.plist to /Library/LaunchAgents to automatically load the plugin at login.

### How it works
This library overwrites the CTFontCreateWithFontDescriptor() function of the Core Text Framework, the function most frequently used to create a CTFont. It then checks and if necessary replaces the font name in the CTFontDescriptor.

### Changing fonts
The property list eu.rensbr.FontReplace.settings.plist is a dictionary with the system fonts as keys, and the fonts they should be replaced with as strings. Font names should be given as their Postscript names.

```plist
<key>System-Fontname</key>
<string>Replace-Fontname</string>
```
