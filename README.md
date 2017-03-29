# FontReplace

FontReplace is a plugin for replacing the system fonts on macOS 10.12 Sierra, by any other font installed on the system.

![Screenshot](screenshot.png)

### Getting started
* System Integrity Protection must be disabled in order for this to work.
* Move eu.rensbr.FontReplace.settings.plist to /Library/Preferences
* Move libFontReplace.dylib to /Library
* Use the following command to load the plugin:
```bash
launchctl setenv DYLD_INSERT_LIBRARIES /Library/libFontReplace.dylib
```
* Move eu.rensbr.FontReplace.launch.plist to /Library/LaunchAgents to automatically load the plugin at login.

### How it works
This library overwrites the CTFontCreateWithFontDescriptor() function of the Core Text Framework, the function most frequently used to create a CTFont. It then checks and if necessary replaces the font name in the CTFontDescriptor.

### Changing fonts
The property list eu.rensbr.FontReplace.settings.plist is a dictionary with the system fonts as keys, and the fonts they should be replaced with as strings. Font names should be given as their Postscript names.

```plist
<key>System-Fontname</key>
<string>Replace-Fontname</string>
```

### For developers
CTFontDescriptorCreateForUITypeOverride (private API) seems like a better function to overwrite when replacing the system font, as it simply returns the CTFontDescriptor for a given UI element type. However, unfortunately this method is not used for all system text drawing. In particular, column and list view in Finder don't use this function.
