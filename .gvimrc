scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac

"Color(overwrite macvim).
set t_Co=256
"Slate
set background=dark
colorscheme slate
set background=light
"Solarized
autocmd ColorScheme * highlight SpecialKey guifg=grey guibg=#fdf6e3
autocmd ColorScheme * highlight WarningMsg guifg=white guibg=lightred
colorscheme solarized
let g:solarized_menu=0

"No problem with relativenumber fog gvim.
set relativenumber

"No toolbar.
set guioptions-=T

"Key map.
nmap <Leader>ge :split $HOME/dotfiles/.gvimrc<CR>
nmap <Leader>vs :so $MYVIMRC<CR>:so $MYGVIMRC<CR>
" autocmd bufwritepost .gvimrc source $MYGVIMRC
nmap <C-W><C-S> :<C-u>call WinSidebyside()<CR>

nmap <F12> :let &guifont = substitute(&guifont, '\v([0-9.]+)$', '\=(string(str2float(submatch(1))+0.5))', '')<CR>
nmap <S-F12> :let &guifont = substitute(&guifont, '\v([0-9.]+)$', '\=(string(str2float(submatch(1))-0.5))', '')<CR>

if ( has('win32') || has('win64') )
    set list lcs=tab:»\ ,eol:¬,trail:·
        "Don't use a character which shows in double-width.
endif

"Fonts.
if has('mac')
    set guifont=Consolas:h14
    " set guifontwide=Monaco:h14
elseif has('unix')
    set guifont=Consolas\ 13
else
    " set guifont=MyricaM_M:h13
    " set guifontwide=MyricaM_M:h13
    set guifont=Consolas:h11
    set guifontwide=MS_Gothic:h11
endif

highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=i-ci:ver30-iCursor-blinkon0
" set guicursor+=i-ci:ver30-iCursor-blinkwait300-blinkon300-blinkoff100
" set guicursor+=n-v-c:blinkon0
" set guicursor+=i-ci:blinkon0
" set guicursor+=i-ci:blinkwait300-blinkon300-blinkoff300
" set guicursor+=i-ci:ver50-iCursor-blinkwait300-blinkon200-blinkoff150

"Window placement.
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

call InitPlacement()

set guioptions-=m
set guioptions-=T

if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif

set autoindent
