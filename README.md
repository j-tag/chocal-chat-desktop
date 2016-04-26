# Chocal Chat Desktop Client
This repository contains desktop client for Chocal Chat application that supports Linux, Mac and Windows operating systems.

![Chocal Chat](https://puresoftware.org/images/chocal-chat/github/chocal-desktop.png)

# First Things First
You need to run Chocal Chat Server application on your local network. You can take it from here: https://github.com/J-TAG/chocal-chat-server

# Requirements
In order to run Chocal Chat desktop client you need to install Qt development environment.

1. Install Qt: https://qt.io
2. Run Chocal Server: https://github.com/J-TAG/chocal-chat-server
3. Clone Chocal Desktop
4. Use `lrelease` to generate translation `qm` files. For example if Qt bin directory is in your PATH environment variable you can run `lrelease-qt5 ChocalChat.pro` or if it is not you can run `path/to/qt/bin/lrelease ChocalChat.pro` or in a Windows environmet run `C:\Qt\Qt5.6.0\5.6\msvc2015_64\bin\lrelease.exe ChocalChat.pro`. Note that because `qm` files are supposed to be bundled in a `.qrc` file, so you SHOULD do this step, otherwise the build operation will fail.

# How It Works?
Please refer to Chocal Server `README.md` file to find out how Chocal API is working.
