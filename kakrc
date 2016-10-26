colorscheme desertex

# Help on everything
set global autoinfo command|onkey|normal

set global tabstop 4
set global scrolloff 2,0
set global grepcmd 'ag -S --hidden --ignore=.git --ignore=.hg --ignore=.svn'
set global modelinefmt '{title}%val{bufname}{StatusLine} %val{cursor_line}:%val{cursor_char_column} [{StatusLineValue}%opt{filetype}{StatusLine}]'

map global normal '#' :comment-line<ret>

map global user q ':quit<ret>'
map global user f ':set buffer filetype '
map global user o ':echo %opt{'

# Case insensitive search
map global normal / '/(?i)'
map global normal <a-/> '<a-/>(?i)'
map global normal ? '?(?i)'
map global normal <a-?> '<a-?>(?i)'

# Copy/paste interactions with the system clipboard
map global user y '<a-|>xclip -f | xclip -selection clipboard<ret>'
map global user P '!xclip -o<ret>'
map global user p '<a-!>xclip -o<ret>'
map global user R '|xclip -o<ret>'

# Buffer/file shortcuts
map global user k ':e ~/.config/kak/kakrc<ret>'
map global user <space> ':b *'
map global user s ':edit -scratch *scratch*<ret>'

def toggle_debug %{%sh{
    if [ "$kak_bufname" = '*debug*' ]
    then
        printf '%s\n' 'exec "<c-o>"'
    else
        printf '%s\n' 'buffer *debug*'
    fi
}}
map global user d ':toggle_debug<ret>'

alias global help doc

# Increment/decrement numbers
map global normal <c-a> 'h"_/\d<ret><a-i>na+1<esc>|bc<ret>'
map global normal <c-x> 'h"_/\d<ret><a-i>na-1<esc>|bc<ret>'

map global user a 'a+<c-r>#<esc>|bc<ret>'
map global user x 'a-<c-r>#<esc>|bc<ret>'

# Visual block selection
def -hidden vblock %{%sh{
    sel_start="${kak_selection_desc%,*}"
    sel_end="${kak_selection_desc#*,}"
    line_start="${sel_start%.*}"
    line_end="${sel_end%.*}"
    col_start="${sel_start#*.}"
    col_end="${sel_end#*.}"
    if [ "$line_end" -gt "$line_start" ]
    then
        count=$((line_end-line_start))
        printf '%s\n' "select $line_start.$col_start,$line_start.$col_end; exec ${count}C<a-:><ret>"
    else
        count=$((line_start-line_end))
        printf '%s\n' "select $line_end.$col_start,$line_end.$col_end; exec ${count}C<a-:><ret>"
    fi
}}
map global normal <c-v> ':vblock<ret>'

#def -hidden star %{%sh{
#    if [ "$kak_selection" = ? ]
#    then
#        printf '%s\n' 'exec "<a-i>w*"'
#    else
#        printf '%s\n' 'exec "*"'
#    fi
#}}
#map global normal * ':star<ret>'

# cd to current file's working directory
def c %{%sh{ echo "cd '${kak_buffile%/*}'" }}

# Goto next grep/make
hook global BufOpenFifo '\*grep\*' %{ map -- global normal - ':grep-next<ret>' }
hook global BufOpenFifo '\*make\*' %{ map -- global normal - ':make-next<ret>' }

def spell-replace %{%sh{
    suggestions=$(echo "$kak_selection" | aspell -a | grep '^&' | cut -d: -f2)
    menu=$(echo "${suggestions#?}" | awk -F', ' '
    {
        for (i=1; i<=NF; i++)
            printf "%s", "%{"$i"}" "%{exec -itersel c"$i"<esc>be}"
    }
    ')
    printf '%s\n' "try %{ menu -auto-single $menu }"
}}
map global user = '<a-i>w:spell-replace<ret>'

hook global WinCreate .* %{

    # <ret>: move downwards, on the first non-blank character
    %sh{ bash -c '[[ $kak_buffile == */* ]] && echo "map buffer normal <ret> jI<esc>"' }

    # {}, <>, ...
    addhl show_matching

    # 1 lorem ipsum
    addhl number_lines -hlcursor -separator ' '

    # Highlight column 81 in red
    addhl regex ^[^\n]{80}\K. 0:default,red

    map global normal <c-g> ':echo %val{buffile}<ret>'

    addhl dynregex '%reg{/}' 0:default,rgb:373b41

    # auto indent
    hook window InsertChar \n %{ exec -draft -itersel K<a-&> }

    # Auto expand tabs into spaces
    hook window InsertChar \t %{ exec -draft -itersel h@ }
}

hook global WinSetOption filetype=sh %{
    set buffer lintcmd 'shellcheck -fgcc -Cnever'
    lint-enable
}

hook global WinSetOption filetype=puppet %{
    set buffer lintcmd 'puppet-lint --log-format "%{filename}:%{line}:%{column}: %{kind}: %{message} [%{check}]"'
    lint-enable
}

hook global WinSetOption filetype=cpp %{
    set buffer lintcmd 'cppcheck --enable=all --template="{file}:{line}:1: {severity}: {message}" 2>&1'
    lint-enable
}

map global user n ':lint-next<ret>'

def remove_spaces %{ try %{ exec -draft '%s\h+$<ret>d' } }

hook global BufWritePre .* %{

    remove_spaces
}

hook global BufWritePre .*\.(?:z|ba|c|k)?sh(?:rc|_profile)?|.*\.pp %{

    lint
}

# Local settings
%sh{
if [ -f "$XDG_CONFIG_HOME"/kak/extra.kak ]
then
    echo "source '$XDG_CONFIG_HOME/kak/extra.kak'"
fi
}
