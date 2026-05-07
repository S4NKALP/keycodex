local M = {}

-- Define sources outside the function to avoid re-allocation
local SOURCES = {
	gl = "https://gitlab.com/",
	cb = "https://codeberg.org/",
	gh = "https://github.com/",
}

--- Resolves a shorthand URL or full URL to its canonical form.
local function resolve_url(url)
	if not url or url:match("^https?://") then
		return url
	end

	-- Extract prefix if present (e.g., 'gl:user/repo')
	local prefix, rest = url:match("^(%w+):(.+)$")
	if prefix and SOURCES[prefix] then
		return SOURCES[prefix] .. rest
	end

	-- Default to GitHub if no prefix or unknown prefix
	return SOURCES.gh .. url
end

--- Normalizes a plugin specification.
local function normalize_spec(spec)
	if type(spec) == "string" then
		return resolve_url(spec)
	elseif type(spec) == "table" and spec.src then
		spec.src = resolve_url(spec.src)
		return spec
	end
	return spec
end

--- Global helper to add plugins to the package manager.
--- Supports shorthand for GitHub (default), GitLab (gl:), and Codeberg (cb:).
---
--- Examples:
---   add("user/repo")               --> https://github.com/user/repo
---   add("gl:user/repo")            --> https://gitlab.com/user/repo
---   add("cb:user/repo")            --> https://codeberg.org/user/repo
---   add({ "user/repo", version = "main" })
---   add({ "user/repo", "gl:other/repo" })
---
_G.add = function(specs)
	-- Normalize input to a table if a single spec is provided
	local list = type(specs) == "table" and (specs.src or not specs[1]) and { specs } or specs
	if type(list) ~= "table" then
		list = { specs }
	end

	local resolved = {}
	for _, spec in ipairs(list) do
		local normalized = normalize_spec(spec)
		if normalized then
			table.insert(resolved, normalized)
		end
	end

	if #resolved > 0 then
		-- Wrap in pcall to handle potential vim.pack errors gracefully
		local ok, err = pcall(vim.pack.add, resolved)
		if not ok then
			vim.notify("vim.pack.add failed: " .. tostring(err), vim.log.levels.ERROR, { title = "Pack Helper" })
		end
	end
end

return M
