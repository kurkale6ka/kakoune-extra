# List of things I miss from Vim

## TODO:
- [ ] proper language to do extensions (not UNIX tools/shells). https://mywiki.wooledge.org/BashPitfalls (and `sh` is way worse)
- [ ] snippets: https://github.com/SirVer/ultisnips
- [ ] help (`:help`)
- [ ] history/ies (`:help q:`)
- [ ] `<c-l>` in cmdline (`:help c_^l`)
- [ ] yank ring
- [ ] `gd` (`:help gd`)
- [ ] auto indent (`:help 'ai`) + signs (repeat start dash/comment on next line: (`:help fo-table`))
- [ ] `gm` (`:help gm`)
- [ ] `gR` (`:help gR`)
- [ ] Vim's `3r<ret>` (`replace 3 chars with a single line break`)
- [ ] `<c-d>` when using :e to list all things (`:help c_^d`)
- [ ] `<c-u>` in cmdline (`:help c_^u`)
- [ ] surround: `cs"'`, `dsb`: https://github.com/tpope/vim-surround
- [ ] `c<up>` `d<down>` to modify 2 lines (`:help c`, `:help d`)
- [ ] `.` vs `[^\n]` in regexes
- [ ] right click to extend selection
- [ ] `gv`, visual reselect (`:help gv`)
- [ ] `<c-l>` to clear highlighting (`nnoremap <silent> <c-l> :nohlsearch<cr><c-l>`, `:help :hls`)
- [ ] arrows to move in menus (`<right>` to confirm could be replaced with `<down>`)
- [ ] `<c-c>` in cmdline
- [ ] mouse click to move around in insert mode
- [ ] `\z` to squeeze: https://github.com/kurkale6ka/vim/blob/master/autoload/squeeze.vim
- [ ] number of lines in statusline
- [ ] `]}`, `])` - example: delete a closing `}` and then there is no easy way to go to the previously matching brace (`:help ]}`)
- [ ] File marks (`` `A`` in Vim, `:help file-marks`)
- [ ] Folds (specifically expression ones), (`:help folding`)
- [ ] sudo Write (`command! WriteSudo write !sudo tee % >/dev/null`)
- [ ] write part of a file to another file (``:`<,`>w/path/to/other/file``, `:help :w_f`)
- [ ] Paste with indent (`[p`, `]p` in Vim, `:help [p`)
- [ ] Go to end of modif `` `]`` (``:help `]``)
- [ ] `<c-x><c-n>` to continue completing (`:help ins-completion`, `:help i^x^n`)
- [ ] Beam cursor in `--INSERT--` mode
- [ ] My `<c-ret>` map (`imap <c-cr> <esc>o`, `:help o`)
- [ ] Open in insert mode (for git commit messages, `:help :startinsert`)
- [ ] `]<space>` from unimpaired: https://github.com/tpope/vim-unimpaired
- [ ] `{` for navigation (`:help {`)
- [ ] something similar to `}` in visual block mode (<=> enough `C`s to get to the end of the paragraph) (`:help }`)
- [ ] `ga` or `:Unicode` (`:help ga`)
- [ ] windows splits: `^wv`, `^ws` (`:help ^wv`)
- [ ] `gr` go to most recent after a few undos (`nnoremap gr :later 9999<cr>`, `:help :later`)
- [ ] Go to line begin (`^` in Vim) (`:help ^`)
- [ ] Omit `*~` files when completing on `:e` (`:help 'wig` in Vim)
- [ ] wrap long lines (`:help 'wrap`)
- [ ] Vim's `^gj` in insert mode (`:help i^gj`)
- [ ] read a file `:r`, (`:help :r`)
- [ ] `:put` (`:help :put`)
- [ ] tag objects (`:help at`)
- [ ] `[[`, `]]` to move between functions (`:help [[`)
- [ ] https://github.com/tpope/vim-abolish
- [ ] https://github.com/tpope/vim-commentary
- [ ] https://github.com/tpope/vim-endwise
- [ ] https://github.com/tpope/vim-repeat
- [ ] https://github.com/tpope/vim-surround
- [ ] https://github.com/tpope/vim-unimpaired
- [ ] https://github.com/godlygeek/csapprox
- [ ] https://github.com/SirVer/ultisnips
- [ ] https://github.com/honza/vim-snippets
- [ ] https://github.com/jszakmeister/vim-togglecursor
- [ ] https://github.com/neomake/neomake
- [ ] https://github.com/junegunn/vim-easy-align
- [ ] https://github.com/junegunn/fzf.vim
- [ ] https://github.com/junegunn/vim-plug

## Almost good:
- [x] `<c-y/e>` in insert mode (edge cases when on EOL)
- [x] spell checker (`]s` missing)
- [x] comments: https://github.com/tpope/vim-commentary
- [x] jump to last modification when opening a file

## Good:
- [x] proper `<c-a>`, `<c-x>`, `g<c-a>`, `g<c-x>`
- [x] `<c-v>` (multiple `C`s)
- [x] Repeat previous `:command` (`@:` in Vim)
