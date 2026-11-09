-- `//> Name` and `//>> Name` section headings (hooklash fold markers) drawn as a tinted bar across the whole window,
-- the name at its start, rounded at both window edges. Closed folds sit on neutral Mantle pills instead
-- (plugins/ufo.lua). The cursor line shows the raw text on the bar.
-- plugins/statuscol.lua calls M.gutter to put the gutter of heading lines on the bar.
local M = {}

local ns = vim.api.nvim_create_namespace("section_headings")

local LEFT_CAP = "\u{E0B6}" -- Nerd Font rounded left half-circle
local RIGHT_CAP = "\u{E0B4}" -- Nerd Font rounded right half-circle

--- A blended toward B by T (0 keeps A), per 8-bit channel.
local function mix(a, b, t)
  local out = 0
  for shift = 0, 16, 8 do
    local ca = bit.band(bit.rshift(a, shift), 0xFF)
    local cb = bit.band(bit.rshift(b, shift), 0xFF)
    out = out + bit.lshift(math.floor(ca + (cb - ca) * t + 0.5), shift)
  end
  return out
end

-- Colors follow the theme: Title-colored text on a tint of Title; sub-headings a fainter tint.
local function set_hl()
  local accent = vim.api.nvim_get_hl(0, { name = "Title", link = false }).fg
  local base = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
  local styles = {
    { prefix = "SectionHeading", bar = mix(base, accent, 0.18) },
    { prefix = "SectionHeadingSub", bar = mix(base, accent, 0.08) },
  }
  for _, s in ipairs(styles) do
    vim.api.nvim_set_hl(0, s.prefix, { fg = accent, bg = s.bar, bold = true })
    vim.api.nvim_set_hl(0, s.prefix .. "Cap", { fg = s.bar })
  end
end

--- The rest of the bar filling Room cells, ending in the right cap.
local function bar_end(style, room)
  return { { string.rep(" ", math.max(room - 1, 0)), style }, { RIGHT_CAP, style .. "Cap" } }
end

--- Highlight prefix (`SectionHeading` or `SectionHeadingSub`), name and indent when Line is a heading; nil otherwise.
local function parse(line)
  local indent, arrows, name = line:match("^(%s*)//(>+) (.*)$")
  if not indent then return nil end
  if #arrows == 1 then return "SectionHeading", name, indent end
  return "SectionHeadingSub", name, indent
end

--- Statuscolumn for the heading line Lnum: Plain (statuscol's own column) on the bar, its first cell the left cap;
--- nil on other lines.
function M.gutter(lnum, plain)
  if vim.v.virtnum ~= 0 then return nil end
  local style = parse(vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or "")
  if not style then return nil end
  local unstyled = plain:gsub("%%#[^#]*#", ""):gsub("%%%*", "")
  return "%#" .. style .. "Cap#" .. LEFT_CAP .. "%#" .. style .. "#" .. unstyled:sub(2) .. "%*"
end

vim.api.nvim_set_decoration_provider(ns, {
  on_line = function(_, win, buf, row)
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
    local style, name, indent = parse(line)
    if not style then return end
    -- One cell short of the edge, so the inline tail never wraps.
    local text_width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff - 1

    -- Cursor line: the raw `//> Name` on the bar, then the same rest of the bar.
    if vim.api.nvim_win_get_cursor(win)[1] - 1 == row then
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, { end_col = #line, hl_group = style, ephemeral = true })
      vim.api.nvim_buf_set_extmark(buf, ns, row, #line, {
        virt_text = bar_end(style, text_width - vim.fn.strdisplaywidth(line)),
        virt_text_pos = "inline",
        ephemeral = true,
      })
      return
    end

    -- The bar also covers what the shorter label leaves showing of the `//> ` source.
    local label = indent .. " " .. name .. " "
    local virt_text = bar_end(style, text_width - vim.fn.strdisplaywidth(label))
    table.insert(virt_text, 1, { label, style })
    vim.api.nvim_buf_set_extmark(buf, ns, row, 0, { virt_text = virt_text, virt_text_pos = "overlay", ephemeral = true })
  end,
})

set_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

return M
