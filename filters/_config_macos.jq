{
    "debug": {
        "default": "native",
        "native": {
            "name": "<name>",
            "type": "cppdbg",
            "request": "launch",
            "program": "<program>",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "externalConsole": false,
            "MIMode": "lldb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for lldb",
                    "text": "settings set target.show-hex-variable-values-with-leading-0x false",
                    "ignoreFailures": true
                },
                {
                    "description": "Make sure LLDB switch to child on fork",
                    "text": "settings set target.process.follow-fork-mode child",
                    "ignoreFailures": false
                }
            ]
        }
    }
}