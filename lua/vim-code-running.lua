local M = {}

local function compiler_list(filetype)
  local compilers = {
    ['c'] = 'gcc',
    ['cpp'] = 'clang++',
    ['java'] = 'javac',
    ['py'] = 'python3',
    ['go'] = 'go',
  }
  return compilers[filetype]
end

function M.build()
  local filetype = vim.bo.filetype
  local compiler = compiler_list(filetype)

  if compiler then
    local filename = vim.fn.expand('%:t:r')
    local executable = filename
    local command = string.format('%s -o %s %s -O2 -g -std=c++11', compiler, executable, vim.fn.expand('%'))
    vim.cmd('silent !' .. command)
  else
    print('No compiler found for this file type')
  end
end

function M.run()
  M.build()
  -- local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:t:r')
  local executable = filename
  local run = './' .. executable
  -- local regex = string.regex('term://.*/%s$', vim.pesc(run))

  vim.cmd('terminal' .. run)
  vim.cmd(string.format([[
  augroup DeleteCompiledFile
    autocmd!
    autocmd TermClose term://\.%s lua require('plugins.compiler').delete('%s')
  augroup END
]], executable, executable))
end

function M.delete(executable)
  local delete = 'rm -rf' .. executable
  vim.cmd('silent !' .. delete)
end

function M.setup()
  -- 添加自定义命令来调用编译函数
  vim.cmd('command! Compile :lua require(\'vim-code-running\').build()')
  vim.cmd('command! Run :lua require(\'vim-code-running\').run()')
end

return M
