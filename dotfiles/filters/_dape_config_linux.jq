{
    "debug": {
        "default": "launch",
        "launch": "launch:native",
        "launch:native": {
            "modes": ["c-mode", "c++-mode"],
            "command": "gdb",
            "command_args": ["--interpreter=dap"],
            "request_params": {
                "request": "launch",
                "cwd": "."
            }
        }
    }
}
