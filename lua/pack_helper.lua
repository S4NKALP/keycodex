--- @class PackHelper
local M = {}

-- Shorthands: gh (default), gl: (GitLab), cb: (Codeberg)
local SOURCES = setmetatable({
	gl = "https://gitlab.com/",
	cb = "https://codeberg.org/",
	gh = "https://github.com/",
}, {
	__index = function(t, k) return rawget(t, k) or t.gh end,
})

local function resolve(url)
	if not url or url:match("^https?://") then return url end
	local prefix, rest = url:match("^(%w+):(.+)$")
	return (prefix and SOURCES[prefix] or SOURCES.gh) .. (rest or url)
end

--- Examples: add("user/repo"), add("gl:user/repo"), add({ "user/repo", version = "main" })
_G.add = function(specs)
	local list = (type(specs) == "table" and (specs.src or not specs[1])) and { specs } or specs
	local res = {}
	for _, s in ipairs(type(list) == "table" and list or { list }) do
		local n = type(s) == "string" and resolve(s) or (type(s) == "table" and s.src and (function()
			s.src = resolve(s.src)
			return s
		end)() or s)
		table.insert(res, n)
	end
	if #res > 0 then pcall(vim.pack.add, res) end
end

return M
