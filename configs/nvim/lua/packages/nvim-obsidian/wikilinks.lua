local cmd = vim.cmd

-- markdownWikiLink is a new region
cmd('syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\\[\\[" end="\\]\\]" contains=markdownUrl keepend oneline concealends')

-- markdownLinkText is copied from runtime files with 'concealends' appended
cmd('syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\\=\\[\\%(\\%(\\_[^][]\\|\\[\\_[^][]*\\]\\)*]\\%( \\=[[(]\\)\\)\\@=" end="\\]\\%( \\=[[(]\\)\\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends')

-- markdownLink is copied from runtime files with 'conceal' appended
cmd('syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal')
