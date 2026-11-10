-- `//> Name` and `//>> Name` section headings (hooklash fold markers) drawn as a tinted bar across the whole window,
-- the name at its start, rounded at both window edges. Headings indented deeper than the buffer's shallowest one
-- (inside a function) are a Mantle capsule around the name only. Closed folds sit on neutral Mantle pills too
-- (plugins/ufo.lua), in plain text instead of bold. The cursor line shows the raw text on the bar or capsule.
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
  -- A Title tint looks muddy on dark backgrounds; use the catppuccin Surface0 there instead, half of it for sub-headings.
  local ok, palettes = pcall(require, "catppuccin.palettes")
  if ok and vim.o.background == "dark" then
    local surface0 = tonumber(palettes.get_palette().surface0:sub(2), 16)
    styles[1].bar = surface0
    styles[2].bar = mix(base, surface0, 0.5)
  end
  -- Capsules stay quiet: Subtext1 on Mantle, Comment text on a faint tint elsewhere.
  local pill = { prefix = "SectionHeadingPill", bar = mix(base, accent, 0.08),
                 fg = vim.api.nvim_get_hl(0, { name = "Comment", link = false }).fg }
  if ok then
    local palette = palettes.get_palette()
    pill.bar = tonumber(palette.mantle:sub(2), 16)
    pill.fg = palette.subtext1
  end
  table.insert(styles, pill)
  for _, s in ipairs(styles) do
    vim.api.nvim_set_hl(0, s.prefix, { fg = s.fg or accent, bg = s.bar, bold = true })
    vim.api.nvim_set_hl(0, s.prefix .. "Cap", { fg = s.bar })
  end
end

local min_indent_cache = {} -- buf -> { tick, indent }

--- Smallest indent width of any heading in Buf, cached per change.
local function min_indent(buf)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local cached = min_indent_cache[buf]
  if cached and cached.tick == tick then return cached.indent end
  local least = math.huge
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local indent = line:match("^(%s*)//>+ ")
    if indent and #indent < least then least = #indent end
  end
  min_indent_cache[buf] = { tick = tick, indent = least }
  return least
end

vim.api.nvim_create_autocmd("BufWipeout", { callback = function(ev) min_indent_cache[ev.buf] = nil end })

--- The rest of the bar filling Room cells, ending in the right cap.
local function bar_end(style, room)
  return { { string.rep(" ", math.max(room - 1, 0)), style }, { RIGHT_CAP, style .. "Cap" } }
end

--- Highlight prefix (`SectionHeading`, `SectionHeadingSub` or `SectionHeadingPill`), name and indent when Line of
--- Buf is a heading; nil otherwise.
local function parse(buf, line)
  local indent, arrows, name = line:match("^(%s*)//(>+) (.*)$")
  if not indent then return nil end
  if #indent > min_indent(buf) then return "SectionHeadingPill", name, indent end
  if #arrows == 1 then return "SectionHeading", name, indent end
  return "SectionHeadingSub", name, indent
end

--- Statuscolumn for the heading line Lnum: Plain (statuscol's own column) on the bar, its first cell the left cap;
--- nil on other lines.
function M.gutter(lnum, plain)
  if vim.v.virtnum ~= 0 then return nil end
  local style = parse(0, vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or "")
  if not style or style == "SectionHeadingPill" then return nil end
  local unstyled = plain:gsub("%%#[^#]*#", ""):gsub("%%%*", "")
  return "%#" .. style .. "Cap#" .. LEFT_CAP .. "%#" .. style .. "#" .. unstyled:sub(2) .. "%*"
end

vim.api.nvim_set_decoration_provider(ns, {
  on_line = function(_, win, buf, row)
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""

    -- `namespace x {` and `} // namespace` get a faint rule to the window edge, so scope boundaries stand out
    -- between the pills. Aliases (`namespace x = y;`) have no brace and stay plain.
    if line:match("^%s*namespace[%w_:%s]*{%s*$") or line:match("^%s*}%s*//%s*namespace") then
      local text_width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff - 1
      local rule = string.rep("─", text_width - vim.fn.strdisplaywidth(line) - 1)
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        virt_text = { { rule, "Comment" } },
        virt_text_pos = "eol",
        ephemeral = true,
      })
      return
    end

    local style, name, indent = parse(buf, line)
    if not style then return end
    local is_cursor_line = vim.api.nvim_win_get_cursor(win)[1] - 1 == row

    -- Capsule: left cap at the code's column, then the name padded by one space on each side, then right cap.
    if style == "SectionHeadingPill" then
      local start = #indent
      local gap = " "
      local cap = style .. "Cap"
      if is_cursor_line then
        vim.api.nvim_buf_set_extmark(buf, ns, row, start, {
          virt_text = { { LEFT_CAP, cap }, { gap, style } },
          virt_text_pos = "inline",
          ephemeral = true,
        })
        vim.api.nvim_buf_set_extmark(buf, ns, row, #indent, { end_col = #line, hl_group = style, ephemeral = true })
        vim.api.nvim_buf_set_extmark(buf, ns, row, #line, {
          virt_text = { { " ", style }, { RIGHT_CAP, cap } },
          virt_text_pos = "inline",
          ephemeral = true,
        })
        return
      end
      local label = gap .. name .. " "
      -- Blanks cover what the shorter label leaves showing of the `//> ` source.
      local rest = vim.fn.strdisplaywidth(line) - start - 2 - vim.fn.strdisplaywidth(label)
      vim.api.nvim_buf_set_extmark(buf, ns, row, start, {
        virt_text = { { LEFT_CAP, cap }, { label, style }, { RIGHT_CAP, cap }, { string.rep(" ", math.max(rest, 0)) } },
        virt_text_pos = "overlay",
        ephemeral = true,
      })
      return
    end

    -- One cell short of the edge, so the inline tail never wraps.
    local text_width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff - 1

    -- Cursor line: the raw `//> Name` on the bar, then the same rest of the bar.
    if is_cursor_line then
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

--- Virtual text chunks for Label on a SectionHeading bar Width cells wide, rounded at both ends.
function M.bar(label, width)
  local chunks = { { LEFT_CAP, "SectionHeadingCap" }, { label, "SectionHeading" } }
  return vim.list_extend(chunks, bar_end("SectionHeading", width - 1 - vim.fn.strdisplaywidth(label)))
end

set_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

return M
