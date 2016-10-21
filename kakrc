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
map global normal <c-a> '"_/-?\d+<ret>|read; echo "$((++REPLY))"<ret>'
map global normal <c-x> '"_/-?\d+<ret>|read; echo "$((--REPLY))"<ret>'

map global user a "|gawk 'match($0, /(.*)([0-9]+)(.*)/, a) {i+=1; print a[1] a[2]+i a[3]}'<ret>"
map global user x "|gawk 'match($0, /(.*)([0-9]+)(.*)/, a) {i-=1; print a[1] a[2]+i a[3]}'<ret>"

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
