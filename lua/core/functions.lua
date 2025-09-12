-- Reload neovim config
vim.api.nvim_create_user_command('ReloadConfig', function()
    for name, _ in pairs(package.loaded) do
        if name:match('^plugins') then
            package.loaded[name] = nil
        end
    end

    dofile(vim.env.MYVIMRC)
    vim.notify('Nvim configuration reloaded!', vim.log.levels.INFO)
end, {})

local function copy_to_clipboard(content, message)
    vim.fn.setreg('+', content)
    vim.notify('Copied "' .. content .. '" to the clipboard!', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('CopyRelativePath', function()
    local path = vim.fn.expand('%')
    copy_to_clipboard(path, 'Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command('CopyAbsolutePath', function()
    local path = vim.fn.expand('%:p')
    copy_to_clipboard(path, 'Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command('CopyRelativePathWithLine', function()
    local path = vim.fn.expand('%')
    local line = vim.fn.line('.')
    local result = path .. ':' .. line
    copy_to_clipboard(result, 'Copied "' .. result .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command('CopyAbsolutePathWithLine', function()
    local path = vim.fn.expand('%:p')
    local line = vim.fn.line('.')
    local result = path .. ':' .. line
    copy_to_clipboard(result, 'Copied "' .. result .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command('CopyFileName', function()
    local path = vim.fn.expand('%:t')
    copy_to_clipboard(path, 'Copied "' .. path .. '" to the clipboard!')
end, {})

-- Switch to git root or file parent dir
vim.api.nvim_create_user_command('RootDir', function()
    local bufname = vim.fn.expand('%:p')
    if vim.fn.filereadable(bufname) == 0 then
        return
    end

    local parent = vim.fn.fnamemodify(bufname, ':h')
    local git_root = vim.fn.systemlist('git -C ' .. vim.fn.fnameescape(parent) .. ' rev-parse --show-toplevel')
    local root = ''
    if #git_root > 0 and git_root[1] ~= '' then
        root = git_root[1]
    else
        root = parent
    end

    if root ~= '' then
        vim.cmd('lcd ' .. vim.fn.fnameescape(root))
        vim.notify('Changed directory to ' .. root, vim.log.levels.INFO)
    end
end, {})

