-- ============================================================
-- General Options
-- ============================================================
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50

-- Filetype detection + indent plugins
vim.cmd("filetype plugin indent on")

-- ============================================================
-- Filetype Overrides
-- ============================================================
vim.api.nvim_create_augroup("nix_indent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "nix_indent",
    pattern = "nix",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- ============================================================
-- C Development
-- ============================================================

-- Compile and run current file with F5
vim.keymap.set("n", "<F5>", function()
    local file = vim.fn.expand("%")
    vim.cmd("split | terminal gcc " .. file .. " -o /tmp/nvim_out && /tmp/nvim_out")
    vim.cmd("resize 12")
end, { desc = "Compile and run C file" })

-- Compile only with F6 (shows errors without running)
vim.keymap.set("n", "<F6>", function()
    local file = vim.fn.expand("%")
    vim.cmd("!gcc -Wall -Wextra -g " .. file .. " -o /tmp/nvim_out")
end, { desc = "Compile C file (with warnings)" })

-- Open terminal split at the bottom
vim.keymap.set("n", "<leader>t", function()
    vim.cmd("split | terminal")
    vim.cmd("resize 12")
end, { desc = "Open terminal split" })

-- Exit terminal mode easily with Escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
