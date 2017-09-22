" Encoding and format
" {{{
set encoding=utf-8
scriptencoding utf-8
set modeline
let g:vim_indent_cont=8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac
" }}}

" Basic settings
" {{{
set t_Co=256

" Slate
" set background=dark
" colorscheme slate

" Solarized
set background=light
colorscheme solarized
highlight! SpecialKey guifg=grey guibg=#fdf6e3
highlight! WarningMsg guifg=white guibg=lightred
highlight! MatchParen guifg=red guibg=#FBD6D0
let g:solarized_menu=0

highlight ColorColumn ctermbg=magenta guibg=Magenta

set relativenumber
set guioptions-=m
set guioptions-=T

if ( has('win32') || has('win64') )
    set list lcs=tab:»\ ,eol:¬,trail:·
        "Don't use a character which shows in double-width.
endif
" }}}

" Font
" {{{

" Should be overwritten in gvimrc.local
if has('mac')
    set guifont=Consolas:h14
elseif has('unix')
    set guifont=Consolas\ 13
else
    set guifont=Consolas:h11
    set guifontwide=MS_Gothic:h11
endif
" }}}

" Cursor
" {{{

highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=i-ci:ver30-iCursor-blinkon0
" set guicursor+=i-ci:ver30-iCursor-blinkwait300-blinkon300-blinkoff100
" set guicursor+=n-v-c:blinkon0
" set guicursor+=i-ci:blinkon0
" set guicursor+=i-ci:blinkwait300-blinkon300-blinkoff300
" set guicursor+=i-ci:ver50-iCursor-blinkwait300-blinkon200-blinkoff150

" }}}

" Custom commands
" {{{

function! InitPlacement()
    if ( !exists('g:gvimrc_local_init_placement') )
        return
    endif
    let l:placement = g:gvimrc_local_init_placement
    execute 'set lines='.l:placement[2] 'columns='.l:placement[3]
    execute 'winpos' l:placement[0] l:placement[1]
endfunction
function! SidebysidePlacement()
    if ( !exists('g:gvimrc_local_sbs_placement') )
        return
    endif
    let l:placement = g:gvimrc_local_sbs_placement
    execute 'winpos' l:placement[0] l:placement[1]
    execute 'set lines='.l:placement[2] 'columns='.l:placement[3]
endfunction
function! WinSidebyside()
    call SidebysidePlacement()
    if expand('#')!='' && winnr('$')==1
        vsplit #
    endif
    wincmd =
endfunction

" }}}
"
" Key mappings
" {{{

" File system
nnoremap <Leader>ge :split $HOME/dotfiles/.gvimrc<CR>
nnoremap <silent> <Leader>vs :so $MYVIMRC<CR>:so $MYGVIMRC<CR>

" Arrange windows
nnoremap <silent> <C-W><C-S> :<C-u>call WinSidebyside()<CR>
nnoremap <silent> <F12> :let &guifont = substitute(&guifont, '\v([0-9.]+)$', '\=(string(str2float(submatch(1))+0.5))', '')<CR>
nnoremap <silent> <S-F12> :let &guifont = substitute(&guifont, '\v([0-9.]+)$', '\=(string(str2float(submatch(1))-0.5))', '')<CR>
" }}}

" Local config
" {{{
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif
" }}}

call InitPlacement()

" vim:fdm=marker:fmr={{{,}}}:sw=4:sts=4:ts=4:et:
