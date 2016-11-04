colorscheme desertex

# Help on everything
set global autoinfo command|onkey|normal

set global tabstop 4
set global scrolloff 2,0
set global grepcmd 'ag -S --hidden --ignore=.git --ignore=.hg --ignore=.svn'
set global modelinefmt '{title}%val{bufname}{StatusLine} %val{cursor_line}:%val{cursor_char_column} [{StatusLineValue}%opt{filetype}{StatusLine}]'

map global normal '#' :comment-line<ret>

alias global help doc

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

# Copy from above/below
# map global insert <c-y> '<c-o><a-;>:exec -draft -itersel kyjP<ret>'
hook global InsertKey <c-y> %{ exec <c-o>; exec -draft -itersel kyjP }
hook global InsertKey <c-e> %{ exec <c-o>; exec -draft -itersel jykP }

# Buffer/file shortcuts
map global user k ':e ~/.config/kak/kakrc<ret>'
map global user <space> ':b *'
map global user s ':edit -scratch *scratch*<ret>'

# ,s to switch to *debug* and back
def -hidden toggle_debug %{%sh{
    if [ "$kak_bufname" = '*debug*' ]
    then
        printf '%s\n' 'exec "<c-o>"'
    else
        printf '%s\n' 'buffer *debug*'
    fi
}}
map global user d ':toggle_debug<ret>'

# @: to repeat last :command (:exec @ to get the default behaviour)
map global normal @ ':onkey k %{%sh{ [ "$kak_reg_k" = : ] && echo "exec :<lt>up><lt>ret>" }}<ret>'

# Increment/decrement numbers
# inc count operator(-/+) serie(true/false)
def -hidden -params 3 inc %{%sh{
    if [ "$1" = 0 ]
    then
        count=1
    else
        count="$1"
    fi
    if [ "$3" = false ]
    then
        printf '%s%s\n' 'exec h"_/\d<ret><a-i>na' "$2($count)<esc>|bc<ret>"
    else
        printf '%s%s\n' 'exec h"_/\d<ret><a-i>na' "$2($((count)))*<c-r>#<esc>|bc<ret>"
    fi
}}
map global normal <c-a> ':inc %val{count} + false<ret>'
map global normal <c-x> ':inc %val{count} - false<ret>'

map global user a ':inc %val{count} + true<ret>'
map global user x ':inc %val{count} - true<ret>'
# Problem with the below: a count can't be used
# # g<c-a/x> - goto pending mode => <esc> to go back to normal
# map global goto <c-a> '<esc>:inc %val{count} + true<ret>'
# map global goto <c-x> '<esc>:inc %val{count} - true<ret>'

# Visual block selections
def -hidden vblock %{%sh{
    printf '%s\n' "${kak_selections_desc}" | tr ':' '\n' | { while read -r sel
    do
        sel_start="${sel%,*}"
        sel_end="${sel#*,}"
        line_start="${sel_start%.*}"
        line_end="${sel_end%.*}"
        col_start="${sel_start#*.}"
        col_end="${sel_end#*.}"
        if [ "$line_end" -gt "$line_start" ]
        then
            line="$line_start"
            line_last="$line_end"
        else
            line="$line_end"
            line_last="$line_start"
        fi
        while [ "$line" -le "$line_last" ]
        do
            selections="$selections":"$line"."$col_start","$line"."$col_end"
            true $((line++))
        done
    done
    printf '%s\n' "select ${selections#?}; exec <a-:>"
    }
}}
map global normal <c-v> ':vblock<ret>'

# cd to current file's working directory
def c %{%sh{ echo "cd '${kak_buffile%/*}'" }}

# Goto next grep/make
hook global BufOpenFifo '\*grep\*' %{ map -- global normal - ':grep-next<ret>' }
hook global BufOpenFifo '\*make\*' %{ map -- global normal - ':make-next<ret>' }

# Spell check with ,=
map global user = '<a-i>w:spell-replace<ret>'

hook global WinCreate .* %{

    # <ret>: move downwards, on the first non-blank character (don't map for *buffers*)
    %sh{ [ -f $kak_buffile ] && echo 'map buffer normal <ret> jI<esc>' }

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

hook global WinSetOption filetype=python %{
    set buffer lintcmd 'flake8 --filename=* --format="%(path)s:%(row)d:%(col)d: error: %(text)s" 2>&1'
    lint-enable
}

map global user n ':lint-next<ret>'

def remove_spaces %{ try %{ exec -draft '%s\h+$<ret>d' } }

hook global BufWritePre .* %{

    remove_spaces
    %sh{ sqlite3 $XDG_DATA_HOME/kakoune/info.db "INSERT or REPLACE into recent (file, pos, stamp) values ('$kak_buffile', '$kak_selections_desc', '$(date)');" }
}

hook global BufOpen .* %{

    %sh{
    if [ -f "$kak_buffile" ]
    then
        selections=$(sqlite3 "$XDG_DATA_HOME"/kakoune/info.db "SELECT pos from recent where file = '$kak_buffile';")
        [ -n "$selections" ] && printf '%s\n' "select $selections"
    fi
    }
}

hook global BufWritePre .*\.(?:z|ba|c|k)?sh(?:rc|_profile)?|.*\.pp|.*\.py %{

    lint
}

# Local settings
%sh{
if [ -f "$XDG_CONFIG_HOME"/kak/extra.kak ]
then
    echo "source '$XDG_CONFIG_HOME/kak/extra.kak'"
fi
}

# TODO: *, <a-*> without having to select the word
# def -hidden star %{%sh{
#     if [ "$kak_selection" = ? ]
#     then
#         printf '%s\n' 'exec "<a-i>w*"'
#     else
#         printf '%s\n' 'exec "*"'
#     fi
# }}
# map global normal * ':star<ret>'
