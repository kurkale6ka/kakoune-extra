# List of things I miss from Vim

## TODO:
- [ ] proper language to do extensions. https://mywiki.wooledge.org/BashPitfalls (sh way worse)
- [ ] snippets
- [ ] help
- [ ] history
- [ ] `<c-l>` in cmdline
- [ ] yank ring
- [ ] `gd`
- [ ] auto indent + signs (repeat start dash/comment on next line)
- [ ] `gm`
- [ ] `gR`
- [ ] Vim's `3r<ret>`?
- [ ] `<c-d>` when using :e to list all things
- [ ] `<c-u>` in cmdline
- [ ] surround: `cs"'`, `dsb`
- [ ] `c<up>` `d<down>` to modify 2 lines
- [ ] `.` vs `[^\n]` in regexes
- [ ] right click to extend selection
- [ ] `gv`
- [ ] `<c-l>` to clear highlighting
- [ ] arrows to move in menus (`<right>` to confirm could be replaced with `<down>`)
- [ ] `<c-c>` in cmdline
- [ ] mouse click to move around in insert mode
- [ ] `\z` to squeeze
- [ ] number of lines in statusline
- [ ] `]}`, `])` - example: delete a closing `}` and then there is no easy way to go to the previously matching brace
- [ ] File marks (`` `A`` in Vim)
- [ ] Folds (specifically expression ones)
- [ ] sudo Write
- [ ] write part of a file to another file (``:`<,`>w/path/to/other/file``)
- [ ] Paste with indent (`[p`, `]p` in Vim)
- [ ] Go to end of modif `` `]``
- [ ] `<c-x>n` to continue completing
- [ ] Beam cursor in --INSERT--
- [ ] My `<c-ret>` map
- [ ] Open in insert mode (for git commit messages)
- [ ] `]<space>` from unimpaired
- [ ] `{` for navigation
- [ ] `ga` or `:Unicode`
- [ ] `^wv`, `^ws`
- [ ] `gr` go to most recent after a few undos
- [ ] Go to line begin (`^` in Vim)
- [ ] Omit `*~` files when completing on `:e` (`:h'wig` in Vim)
- [ ] wrap long lines
- [ ] Vim's `^gj` in insert mode
- [ ] `:r`
- [ ] `:put`
- [ ] tag objects
- [ ] something similar to `}` in visual block mode (<=> enough `C`s to get to the end of the paragraph)
- [ ] `[[`, `]]` to move between functions
- [ ] ignore `.file~`s in `:e`

## Good:
- [x] proper `<c-a>`, `<c-x>`, `g<c-a>`, `g<c-x>`
- [x] `<c-v>` (multiple `C`s)
- [x] Repeat previous `:command` (`@:` in Vim)

## Almost good:
- [x] `<c-y/e>` in insert mode (edge cases when on EOL)
- [x] spell checker (`]s` missing)
- [x] comments
- [x] jump to last modification when opening a file
