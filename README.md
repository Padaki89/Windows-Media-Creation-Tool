![CodeQL Badge](https://img.shields.io/badge/CodeQL-003B4F?style=for-the-badge&logo=github-actions&logoColor=white)
![Batchfile](https://img.shields.io/badge/Batchfile-100.0%25-brightgreen)

# Universal MediaCreationTool Wrapper Script

This script is an enhanced fork of [AveYo/MediaCreationTool.bat](https://github.com/AveYo/MediaCreationTool.bat). It is not only a sophisticated wrapper for the MediaCreationTool but also a comprehensive automation utility for deploying Windows 10 and 11. The enhancements include robust support for business editions and additional deployment features.

![Preview](preview.png)

*If you have encountered issues with previous versions, this latest update should address them.*

## Features

### Presets

1. **Auto Upgrade**
   - **Purpose:** Facilitates direct OS upgrades using detected media.
   - **Options:**
     - Retain files and apps even if the OS edition does not match the target edition.
     - Switch the detected edition by appending `EditionID` to the script name.
     - Troubleshoot upgrade failures by appending `no_update` to the script name.
     - Defaults to Windows 11; to target Windows 10, include the version in the script name, e.g., `auto 21H2 MediaCreationTool.bat`.

2. **Auto ISO**
   - **Purpose:** Creates an ISO using detected media in the current folder (or `C:\ESD` if running from a zip).
   - **Options:**
     - Override detected media by specifying edition name, language, and architecture in the script name.
     - Example: `21H1 Education en-US x86 iso MediaCreationTool.bat`.

3. **Auto USB**
   - **Purpose:** Creates bootable media on a specified USB drive.
   - **Note:** Manual USB drive selection is required in the GUI for data safety.

4. **Select**
   - **Purpose:** Manually select Edition, Language, and Architecture (x86, x64, or both) for a specified target.
   - **Options:** Includes setup override files by default (can be disabled by appending `def` to the script name).

5. **MCT Defaults**
   - **Purpose:** Executes without user intervention, creating media without modifying the script.
   - **Note:** Passes `products.xml` to the MediaCreationTool and exits without altering the media.

### Media Modifications

Presets 1-4 will modify the created media as follows:
- Write `auto.cmd` for on-demand auto-upgrade with edition switching and TPM skipping.
- Copy `$ISO$` folder content (if present) to the media root. If using `$OEM$` content, place it in `$ISO$\sources\$OEM$`.
- Write `sources\PID.txt` to preselect the edition at boot or within Windows (if configured).
- Write `sources\EI.cfg` to prevent product key prompts on Windows 11 consumer media.
- Write `AutoUnattend.xml` in `boot.wim` to enable local accounts on Windows 11 Home.
- Patch `winsetup.dll` in `boot.wim` to bypass Windows 11 setup checks when booting from media.

To disable these modifications, append `def` to the script name to create default, untouched MCT media.

### Simple Deployment

The **auto.cmd** file is utilized in the ***Auto Upgrade*** preset via the GUI. Rename the script to `auto MediaCreationTool.bat` for fully unattended operation. This facilitates upgrades while preserving files and apps, even when OS editions differ. It supports upgrades from various editions, including Ultimate, PosReady, Embedded, LTSC, or Enterprise Eval.

The generated script is included in the media for future use. It detects available editions in `install.esd`, selects a suitable index, and adjusts the `EditionID` in the registry. For Windows 11, it attempts to skip setup checks (this behavior can be modified). It also configures recommended setup options to minimize upgrade issues.

**Examples:**
- **Upgrade from Enterprise LTSC 2019 to Business Media:** `auto.cmd` selects the Enterprise index and adjusts the `EditionID` to Enterprise.
- **Switch Edition:** Rename the script to `ProfessionalWorkstation MediaCreationTool.bat` to switch to ProfessionalWorkstation.
- **Upgrade Multiple PCs:** Use a script name like `auto 21H2 Pro MediaCreationTool.bat` to upgrade multiple PCs to the latest 10 version with Pro edition.

**Additional Features:**
- Add VL/MAK/retail product keys as needed.
- The script also manages `$ISO$` folders for branding, configuration, and tweaks.

### Discuss

For further discussion, visit the [MDL Forums](https://forums.mydigitallife.net/threads/universal-mediacreationtool-wrapper-script-create-windows-11-media-with-automatic-bypass.84168/).
