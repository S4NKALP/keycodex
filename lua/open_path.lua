-- Resolve the file under the cursor and open it.
--
-- Understands:
--   * plain paths          lua/keys.lua, ./src/main.rs, "lib/foo.ts"
--   * path with a line     lua/keys.lua:42
--   * Python modules       utils.helpers  ->  utils/helpers.py
--                          .models        ->  models.py next to the buffer
--                          ..shared.x    ->  one directory up, then shared/x.py
--                          pkg            ->  pkg.py or pkg/__init__.py
--
-- Python resolution only runs in python buffers, so a sentence containing
-- "config" does not accidentally open config.py.

local M = {}

local function readable(path)
    return vim.fn.filereadable(path) == 1
end

local function dir_exists(path)
    return vim.fn.isdirectory(path) == 1
end

-- Nearest directory above `start` that looks like a project root
local function project_root(start)
    local markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }
    local dir = start
    while dir ~= '' do
        for _, marker in ipairs(markers) do
            local candidate = dir .. '/' .. marker
            if readable(candidate) or dir_exists(candidate) then
                return dir
            end
        end
        local parent = vim.fn.fnamemodify(dir, ':h')
        if parent == dir then
            break
        end
        dir = parent
    end
    return nil
end

-- `utils.helpers` -> { <root>/utils/helpers.py, <root>/utils/helpers/__init__.py }
local function module_candidates(word, bufdir)
    local dots = word:match('^%.+') or ''
    local rest = word:sub(#dots + 1)
    if rest == '' then
        return {}
    end

    local module = rest:gsub('%.', '/')
    local roots = {}

    if #dots > 0 then
        -- n leading dots = n-1 levels up from the buffer's directory
        local up = bufdir
        for _ = 2, #dots do
            up = vim.fn.fnamemodify(up, ':h')
        end
        table.insert(roots, up)
    end

    table.insert(roots, bufdir)
    table.insert(roots, project_root(bufdir))
    table.insert(roots, vim.fn.getcwd())

    local candidates = {}
    for _, root in ipairs(roots) do
        if root and root ~= '' then
            table.insert(candidates, root .. '/' .. module .. '.py')
            table.insert(candidates, root .. '/' .. module .. '/__init__.py')
        end
    end
    return candidates
end

-- Clean quotes/brackets/commas that wrap the word in prose or code
local function clean(word)
    return (word:gsub('^[%(%[{<"\']+', ''):gsub('[%]%)}>"\',;]+$', ''))
end

--- @param word string
--- @param bufdir string
--- @return string|nil path, integer|nil line
function M.resolve(word, bufdir)
    word = clean(word)
    if word == '' then
        return nil
    end

    local path, line = word:match('^(.+):(%d+)$')
    path = path or word
    line = line and tonumber(line)

    local candidates = {
        path,
        bufdir .. '/' .. path,
        vim.fn.getcwd() .. '/' .. path,
    }

    if vim.bo.filetype == 'python' or word:find('%.') then
        vim.list_extend(candidates, module_candidates(path, bufdir))
    end

    for _, candidate in ipairs(candidates) do
        if readable(candidate) then
            return candidate, line
        end
    end

    return nil
end

function M.open()
    local bufdir = vim.fn.expand('%:p:h')
    if bufdir == '' then
        bufdir = vim.fn.getcwd()
    end

    -- `<cfile>` drops a trailing `:line`, so start from the WORD
    local word = vim.fn.expand('<cWORD>')

    local path, line = M.resolve(word, bufdir)
    if not path then
        if clean(word) == '' then
            vim.notify('No file under cursor', vim.log.levels.WARN, { title = 'File Under Cursor' })
        else
            vim.notify(
                'No file found for "' .. clean(word) .. '"',
                vim.log.levels.WARN,
                { title = 'File Under Cursor' }
            )
        end
        return
    end

    vim.cmd.edit(vim.fn.fnameescape(path))
    if line and vim.fn.line('$') >= line then
        vim.api.nvim_win_set_cursor(0, { line, 0 })
    end
end

return M
