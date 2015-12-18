scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac

"Color(overwrite macvim).
set t_Co=256
colorscheme slate

"No problem with relativenumber fog gvim.
set relativenumber

"Key map.
nmap <Leader>ge :split $HOME/dotfiles/.gvimrc<CR>
nmap <Leader>vs :so $MYVIMRC<CR>:so $MYGVIMRC<CR>
" autocmd bufwritepost .gvimrc source $MYGVIMRC
nmap <C-W><C-S> :<C-u>call WinSidebyside()<CR>

nmap <F12> :let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) - 1)', '')<CR>
nmap <S-F12> :let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) + 1)', '')<CR>

if ( has('win32') || has('win64') )
    set list lcs=tab:»\ ,eol:¬,trail:·
        "Don't use a character which shows in double-width.
endif

"Fonts.
if has('mac')
    set guifont=Consolas:h14
    set guifontwide=Monaco:h14
elseif has('unix')
else
    " set guifont=MyricaM_M:h13
    " set guifontwide=MyricaM_M:h13
    set guifont=Consolas:h11
    set guifontwide=MS_Gothic:h11
endif

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
