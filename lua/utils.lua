local M = {}

function M.CloseAllButCurrentBuffer()
    local current_buf = vim.api.nvim_get_current_buf()
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') and buf ~= current_buf then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    require('lualine').refresh({
        scope = 'tabpage',
        place = { 'tabline' }
    })
end

return M
