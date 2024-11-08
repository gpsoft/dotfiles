" Encoding and format
" {{{
set encoding=utf-8
scriptencoding utf-8
set modeline
let g:vim_indent_cont=8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac
" }}}

" Color settings
" {{{
" set t_Co=256

" Solarized
augroup gvimrc_color
    autocmd!
    autocmd ColorScheme solarized highlight! SpecialKey guifg=grey guibg=#fdf6e3
    autocmd ColorScheme solarized highlight! WarningMsg guifg=white guibg=lightred
    autocmd ColorScheme solarized highlight! MatchParen guifg=red guibg=#FBD6D0
    autocmd ColorScheme solarized highlight! Comment gui=NONE
augroup END
let g:solarized_menu=0

highlight ColorColumn guibg=#ffcfcf

" Should be overwritten in gvimrc.local
set background=light
colorscheme solarized

" }}}

" Basic settings
" {{{
set relativenumber
set guioptions-=m
set guioptions-=T
set mouse=c

if ( has('win32') || has('win64') )
    set list lcs=tab:»\ ,eol:¬,trail:∙
        "Don't use a character which shows in double-width.
endif
" }}}

" Font
" {{{

" Should be overwritten in gvimrc.local
if has('mac')
    set guifont=Consolas:h14
elseif has('unix')
    " set guifont=Consolas\ 13
    set guifont=Ricty\ Diminished\ 13
else
    set guifont=Consolas:h11
    set guifontwide=MS_Gothic:h11
endif
" }}}

" Cursor
" {{{

highlight iCursor guifg=white guibg=steelblue
" set guicursor=n-v-c:block-Cursor-blinkon0
" set guicursor+=i-ci:ver30-iCursor-blinkon0
" set guicursor+=i-ci:ver30-iCursor-blinkwait300-blinkon300-blinkoff100
" set guicursor+=n-v-c:blinkon0
" set guicursor+=i-ci:blinkon0
" set guicursor+=i-ci:blinkwait300-blinkon300-blinkoff300
" set guicursor+=i-ci:ver50-iCursor-blinkwait300-blinkon200-blinkoff150

" }}}

" Custom commands
" {{{

function! InitPlacement(only_move)
    if ( !exists('g:gvimrc_local_init_placement') )
        return
    endif
    let l:placement = g:gvimrc_local_init_placement
    if ( a:only_move == 0 )
        execute 'set lines='.l:placement[2] 'columns='.l:placement[3]
    endif
    execute 'winpos' l:placement[0] l:placement[1]
endfunction
function! SidebysidePlacement()
    if ( !exists('g:gvimrc_local_sbs_placement') )
        return
    endif
    let l:placement = g:gvimrc_local_sbs_placement
    " winpos should be after resizing because
    " gvim moves window after resizing
    execute 'set lines='.l:placement[2] 'columns='.l:placement[3]
    execute 'winpos' l:placement[0] l:placement[1]
endfunction
function! WinSidebyside()
    call SidebysidePlacement()
    if expand('#')!='' && winnr('$')==1
        vsplit #
    endif
    wincmd =
endfunction

function! s:incFontSize(delta)
    let &guifont=substitute(&guifont, '\v([0-9.]+)$',
            \ '\=(string(str2float(submatch(1))+'
            \ . string(a:delta) . '))', '')
endfunction
" }}}
"
" Key mappings
" {{{

" File system
nnoremap <Leader>ge :split $HOME/dotfiles/gvimrc<CR>
nnoremap <silent> <Leader>vs :so $MYVIMRC<CR>:so $MYGVIMRC<CR>:call InitPlacement(0)<CR>

" Arrange windows
nnoremap <silent> <C-W><C-S> :<C-u>call WinSidebyside()<CR>
nnoremap <silent> <F12> :call <SID>incFontSize(0.5)<CR>
nnoremap <silent> <S-F12> :call <SID>incFontSize(-0.5)<CR>
" }}}

" Local config
" {{{
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif
" }}}

augroup gvimrc_last
    autocmd!
    autocmd GUIEnter * call InitPlacement(0)
    " autocmd VimResized * call InitPlacement(1)
    " autocmd WinEnter * call InitPlacement(1)
augroup END

" vim:fdm=marker:fmr={{{,}}}:sw=4:sts=4:ts=4:et:
