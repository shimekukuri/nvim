--[[local status, n = pcall(require, "neosolarized")
if (not status) then return end

n.setup({
  comment_italics = true,
})

local cb = require('colorbuddy.init')
local Color = cb.Color
local colors = cb.colors
local Group = cb.Group
local groups = cb.groups
local styles = cb.styles

Color.new('black', '#000000')
Group.new('CursorLine', colors.none, colors.base03, styles.NONE, colors.base1)
Group.new('CursorLineNr', colors.yellow, colors.black, styles.NONE, colors.base1)
Group.new('Visual', colors.none, colors.base03, styles.reverse)

local cError = groups.Error.fg
local cInfo = groups.Information.fg
local cWarn = groups.Warning.fg
local cHint = groups.Hint.fg

Group.new("DiagnosticVirtualTextError", cError, cError:dark():dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextInfo", cInfo, cInfo:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextWarn", cWarn, cWarn:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextHint", cHint, cHint:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticUnderlineError", colors.none, colors.none, styles.undercurl, cError)
Group.new("DiagnosticUnderlineWarn", colors.none, colors.none, styles.undercurl, cWarn)
Group.new("DiagnosticUnderlineInfo", colors.none, colors.none, styles.undercurl, cInfo)
Group.new("DiagnosticUnderlineHint", colors.none, colors.none, styles.undercurl, cHint)]]--

-- Define a custom highlight group for letters and symbols
--Symbol_pattern = ".*"  -- Match one or more characters that are not whitespace
--Symbol_group = "LettersAndSymbols"

-- Set the syntax highlighting for the custom group
function ColorsMyPencils(color)
    color = color or "catppuccin"
    vim.cmd.colorscheme(color)

    --vim.cmd(string.format("syntax match %s /%s/", Symbol_group, Symbol_pattern))
    --vim.cmd(string.format("highlight %s guibg=black", Symbol_group))

    vim.api.nvim_set_hl(0, "Normal", {bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloats", {bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    --vim.api.nvim_set_hl(0, "Symbol_group", { bg = "black" })
end

ColorsMyPencils()

--vim.cmd([[
--    augroup MyCustomColors
--        autocmd!
--        autocmd BufEnter * lua ColorsMyPencils()
--    augroup END
--]])
