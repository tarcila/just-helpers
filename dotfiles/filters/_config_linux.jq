{
    
    "debug": {
        "default": "launch",
        "launch": "launch:native",
        "launch:native": {
            "name": "(gdb) $name",
            "type": "cppdbg",
            "request": "launch",
            "program": "$program",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                },
                {
                    "description": "Set Disassembly Flavor to Intel",
                    "text": "-gdb-set disassembly-flavor intel",
                    "ignoreFailures": true
                },
                {
                    "description": "Make sure GDB does not spawn a new shell",
                    "text": "-gdb-set startup-with-shell off",
                    "ignoreFailures": false
                },
                {
                    "description": "Make sure GDB switch to child on fork",
                    "text": "-gdb-set follow-fork-mode child",
                    "ignoreFailures": false
                },
                {
                    "description": "Make sure GDB does not detach on fork",
                    "text": "-gdb-set detach-on-fork off",
                    "ignoreFailures": false
                }
            ]
        }
    }
}