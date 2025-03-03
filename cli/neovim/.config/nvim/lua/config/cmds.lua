vim.api.nvim_create_user_command("TypstPin", function(opts)
  local file_path = opts.args ~= "" and opts.args or vim.api.nvim_buf_get_name(0)

  if file_path == "" then
    vim.notify("No valid file path provided!", vim.log.levels.ERROR)
    return
  end

  local max_attempts = 5
  local attempt = 1
  local tinymist_id = nil

  -- Function to check for LSP client and attempt pinning
  local function check_lsp()
    -- Try finding the LSP client
    for _, client in pairs(vim.lsp.get_clients()) do
      if client.name == "tinymist" then
        tinymist_id = client.id
        break
      end
    end

    if tinymist_id then
      -- Client found, perform pinning
      local client = vim.lsp.get_client_by_id(tinymist_id)
      if client then
        client.request("workspace/executeCommand", {
          command = "tinymist.pinMain",
          arguments = { file_path },
        }, function(err)
          if err then
            vim.notify("Error pinning: " .. err, vim.log.levels.ERROR)
          else
            vim.notify("Successfully pinned: " .. file_path, vim.log.levels.INFO)
          end
        end, 0)
      end
    elseif attempt < max_attempts then
      -- Retry after 1 second if client isn't found
      attempt = attempt + 1
      vim.defer_fn(check_lsp, 1000) -- Retry after 1 second
    else
      vim.notify("tinymist not running after " .. max_attempts .. " attempts!", vim.log.levels.ERROR)
    end
  end

  -- Start the check for the LSP client
  check_lsp()
end, {
  nargs = "?",
  complete = "file",
})
