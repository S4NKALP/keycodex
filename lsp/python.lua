return {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'py', 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' },
    settings = {
        python = {
            analysis = {
                -- autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                -- useLibraryCodeForTypes = true,
            },
        },
    },
    init_options = {
        hostInfo = 'neovim',
    },
}
