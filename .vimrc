" Encoding and format
" {{{
set encoding=utf-8
scriptencoding utf-8
set modeline
let g:vim_indent_cont=8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac
" }}}

" Local constants
" {{{
let g:vimrc_local_disabled_plugins = []
if filereadable(expand("~/.vimrc.constants.local"))
    source ~/.vimrc.constants.local
endif
" }}}

" Pathogen
" {{{
let g:pathogen_disabled = [
        \ "PHP-Indenting-for-VIm",
        \ "Align",
        \ "SQLUtilities",
        \ "dbext.vim",
        \ ] + g:vimrc_local_disabled_plugins
execute pathogen#infect()
execute pathogen#helptags()
syntax enable
filetype plugin indent on
" }}}

" Basic settings
" {{{
set t_Co=256
set background=dark
colorscheme slate
highlight ColorColumn ctermbg=magenta guibg=Magenta
call matchadd('ColorColumn', '\%82v', 1000)

set notitle
set noruler
set laststatus=2
set showmode
set textwidth=0
set number
" set relativenumber
"    Relativenumber can make scroll slow in terminal.

if ( has('win32') || has('win64') )
    set listchars=
    "    better to clear lcs before setting ambiwidth to auto or double;
    "    or you could get E834.
    set ambiwidth=auto
else
    set ambiwidth=double
    "    should be 'double' to show fullwidth chars(such as ■)
    "    correctly.
    set list lcs=tab:»\ ,eol:¬,trail:©
    "    can't use a char which shows in fullwidth.
endif

set autoindent
set smartindent
set smarttab
set backspace=indent,eol,start
set complete=.,w,b,u,t
set formatoptions+=j
set noautoread
set pastetoggle=<F2>

set wildmenu
set scrolloff=1
set sidescrolloff=3

set suffixesadd=.clj,.cljs,.rb  " for gf
set nrformats=                  " format for <C-A> or <C-X>
set hidden

set ignorecase
set smartcase
set infercase
set incsearch
set wrapscan

set noundofile
set backup
set noswapfile
if has('mac')
    set backupdir=/var/tmp/bak
    set backupskip=/tmp/*,/private/tmp/*
elseif has('unix')
    set backupdir=/var/tmp/bak
    set backupskip=/tmp/*
else
    if filereadable('c:\tmp\apptmp\nul')
        set backupdir=c:\tmp\apptmp\bak
        set directory=c:\tmp\apptmp\swp
    elseif filereadable('d:\tmp\apptmp\nul')
        set backupdir=d:\tmp\apptmp\bak
        set directory=d:\tmp\apptmp\swp
    else
        set nobackup
        set noswapfile
    endif
endif

"Block cursor in terminal.
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"
" set t_ve+=[?81;0;112c

" }}}

" IME
" {{{

" function! TurnOffIme()
"   call system('fcitx-remote -c')
" endfunction
" set noimdisable
" set iminsert=0
" set imsearch=-1
" inoremap <silent> <C-[> <ESC>:set iminsert=0<CR>:call TurnOffIme()<CR>

set noimcmdline
inoremap <silent> <C-[> <ESC>:set iminsert=0<CR>
if has('unix')
    function! ImeOff()
        exec system("fcitx-remote -c")
    endfunction
    autocmd! InsertLeave * call ImeOff()
endif

" }}}

" Tab
" {{{
set sw=4 sts=4 ts=4 et
augroup vimrc_tab
    autocmd!
    autocmd FileType go setlocal noet
    autocmd FileType xml setlocal noet
    autocmd FileType css setlocal noet
    autocmd FileType javascript setlocal noet
augroup END
" }}}

" FileType
" {{{
augroup vimrc_ft
    autocmd!
    autocmd BufNewFile,BufRead *.log set filetype=messages
    if has('mac')
        " MacVimでは、mdを開いた後でsplitするとfiletypeがmodula2に戻ってしまう。
        " しかたないのでvim本体を修正した。
        " /Applications/MacVim.app/Contents/Resources/vim/runtime/filetype.vim
    else
        autocmd BufNewFile,BufRead *.md set filetype=markdown
    endif

    autocmd FileType messages setlocal autoread
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType gitcommit setlocal spell
augroup END

    "autocmd bufwritepost .vimrc source $MYVIMRC
    autocmd bufwritepost *.md call previm#refresh()

    autocmd FileType text setlocal textwidth=0
    autocmd FileType vim setlocal textwidth=0
    "    Global setting doesn't work for some filetypes
" }}}

" FileType(php)
" {{{
augroup vimrc_php
    autocmd!
    autocmd BufNewFile,BufRead *.ctp set filetype=php
    autocmd FileType php setlocal foldmethod=indent | normal zR
    autocmd FileType php setlocal indentkeys=
            \ "0{,0},0),:,!^F,o,O,e,*<Return>,=?>,=>,=*/"

    autocmd FileType php setlocal autoindent
    autocmd FileType php setlocal smartindent
       "    indentation in php has been broken??
augroup END

let php_htmlInStrings=1
let php_sql_query=1
let php_baselib=1
let php_parent_error_close=1
" let php_folding=1   " it may slow vim down

" function! s:PhpIndent() range
"     let t = &filetype
"     let &filetype='php'
"     execute a:firstline . ',' .a:lastline . 'normal! =='
"     let &filetype = t
" endfunction
" command! -range PhpIndent <line1>,<line2>call s:PhpIndent()
" vmap g= :PhpIndent<CR>
" }}}

" FileType(Clojure)
" {{{
augroup vimrc_clj
    autocmd!
    autocmd BufNewFile,BufRead *.cljs set filetype=clojure
    autocmd BufNewFile,BufRead *.boot set filetype=clojure

    autocmd FileType clojure setlocal lispwords+=
            \ "defproject,provided,tabular,domonad,with-monad,defmonad,deftask"
    " autocmd FileType clojure setlocal iskeyword-=/
    " autocmd FileType clojure setlocal iskeyword-=.

    autocmd FileType clojure call EnableClojureFolding()
    function! GetClojureFold()
        if getline(v:lnum) =~ '^('
            return ">1"
        else
            return "="
        endif
    endfunction
    function! EnableClojureFolding()
        setlocal foldexpr=GetClojureFold()
        setlocal foldmethod=expr
        setlocal nofoldenable
    endfunction

    autocmd VimEnter clojure RainbowParenthesesToggle
    autocmd Syntax clojure RainbowParenthesesLoadRound
    autocmd Syntax clojure RainbowParenthesesLoadSquare
    autocmd Syntax clojure RainbowParenthesesLoadBraces
augroup END

"let g:clojure_fold = 1
let g:clojure_highlight_references = 1
let g:clojure_align_multiline_strings = 0
    
" }}}

" Plugins
" {{{
" NETRW
" let g:netrw_keepdir=0
let g:netrw_keepj="keepj"
" let g:netrw_liststyle=3
" let g:netrw_silent=1

" MATCHIT
runtime macros/matchit.vim

" VIM-CLOJURE-STATIC
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = [
        \ '^\(future-\)\?facts\?$',
        \ '^prerequisites\?$'
        \ ]
let g:clojure_maxlines = 300

" MRU
let MRU_Max_Entries = 100
let MRU_Exclude_Files = "^crontab\."

" VIM-JSON
let g:vim_json_syntax_conceal = 0

" UltiSnips
let g:UltiSnipsSnippetsDir=expand("$HOME/dotfiles/vimfiles/UltiSnips")
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" Tagbar
let g:tagbar_width=50
let g:tagbar_type_php={
        \ 'ctagsargs': '--php-kinds=cdf -f -',
        \ 'kinds': [
        \ 'c:classes',
        \ 'd:constant definitions:0:0',
        \ 'f:functions']}

" BufExplorer
let g:bufExplorerShowDirectories=0
let g:bufExplorerShowNoName=0
let g:bufExplorerShowUnlisted=0
let g:bufExplorerSortBy='fullpath'

" Open-Browser & previm
" let g:netrw_browsex_viewer="firefox-bin"
" if exists('g:vimrc_local_browser')
"     execute 'let g:previm_open_cmd="'.g:vimrc_local_browser.'"<CR>'
" endif

" SQLUtilities
let g:sqlutil_load_default_maps = 0
let g:sqlutil_align_where = 0
let g:sqlutil_align_comma = 1

" Easymotion
"let g:EasyMotion_use_migemo = 1
let g:EasyMotion_do_mapping=0

" }}}

" Plugins(Lightline)
" {{{
let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component': {
        \   'readonly': '%{&readonly?"\u2b64":""}',
        \ },
        \ 'component_function': {
        \   'fugitive': 'MyFugitive',
        \ },
        \ 'component_visible_condition': {
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
        \ },
        \ 'mode_map': {
        \   'n' : 'N',
        \   'i' : 'I',
        \   'R' : 'R',
        \   'v' : 'V',
        \   'V' : 'VL',
        \   'c' : 'C',
        \   "\<C-v>": 'VB'},
        \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
        \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
        \ }
function! MyFugitive()
    if exists("*fugitive#head")
        let _ = fugitive#head()
        return strlen(_) ? "\u2b60"._ : ''
    endif
    return ''
endfunction
function! AlterWombat()
    "Inactive status line is too dark, let's lighten it up a bit.
    hi! LightLineLeft_inactive_0
            \ ctermbg=243 ctermfg=234 guibg=#808080 guifg=#000000
    hi! LightLineLeft_inactive_0_1
            \ ctermbg=238 ctermfg=243 guibg=#444444 guifg=#808080
    hi! LightLineMiddle_inactive
            \ ctermbg=238 guibg=#444444
    hi! LightLineRight_inactive_1_2
            \ ctermbg=238 ctermfg=238 guibg=#444444 guifg=#444444
endfunction
augroup vimrc_ll
    autocmd!
    autocmd VimEnter * call AlterWombat()
    autocmd WinEnter * call AlterWombat()
augroup END
call AlterWombat()
" }}}

" Plugins(Ctrlp)
" {{{
" let g:ctrlp_map = '<Nop>'
" let g:ctrlp_max_files  = 5000
" let g:ctrlp_max_depth = 6
" let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:8,results:30'
let g:ctrlp_working_path_mode = 'wra'
let g:ctrlp_by_filename = 0
let g:ctrlp_prompt_mappings = {
        \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>', '<c-q>'],
        \ }
let g:ctrlp_custom_ignore = '\v(out|target)/*'
" }}}

" Plugins(Rainbow-paren)
" {{{
"RAINBOW-PAREN
let g:rbpt_colorpairs = [
        \ ['brown',       'RoyalBlue3'],
        \ ['Darkblue',    'SeaGreen3'],
        \ ['darkgray',    'DarkOrchid3'],
        \ ['darkgreen',   'firebrick3'],
        \ ['darkcyan',    'RoyalBlue3'],
        \ ['darkred',     'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['brown',       'firebrick3'],
        \ ['gray',        'RoyalBlue3'],
        \ ['black',       'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['Darkblue',    'firebrick3'],
        \ ['darkgreen',   'RoyalBlue3'],
        \ ['darkcyan',    'SeaGreen3'],
        \ ['darkred',     'DarkOrchid3'],
        \ ['red',         'firebrick3'],
        \ ]
let g:rbpt_max = 8
let g:rbpt_loadcmd_toggle = 0
" }}}

" Plugins(Vim-sexp)
" {{{
let g:sexp_mappings = {
        \ 'sexp_round_head_wrap_list':      '<Leader><Leader>(',
        \ 'sexp_round_tail_wrap_list':      '<Leader><Leader>)',
        \ 'sexp_square_head_wrap_list':     '<Leader><Leader>[',
        \ 'sexp_square_tail_wrap_list':     '<Leader><Leader>]',
        \ 'sexp_curly_head_wrap_list':      '<Leader><Leader>{',
        \ 'sexp_curly_tail_wrap_list':      '<Leader><Leader>}',
        \ 'sexp_round_head_wrap_element':   '<Leader><Leader>e(',
        \ 'sexp_round_tail_wrap_element':   '<Leader><Leader>e)',
        \ 'sexp_square_head_wrap_element':  '<Leader><Leader>e[',
        \ 'sexp_square_tail_wrap_element':  '<Leader><Leader>e]',
        \ 'sexp_curly_head_wrap_element':   '<Leader><Leader>e{',
        \ 'sexp_curly_tail_wrap_element':   '<Leader><Leader>e}',
        \ 'sexp_insert_at_list_head':       '<Leader><Leader>h',
        \ 'sexp_insert_at_list_tail':       '<Leader><Leader>l',
        \ 'sexp_splice_list':               '<Leader><Leader>@',
        \ 'sexp_raise_list':                '<Leader><Leader>o',
        \ 'sexp_raise_element':             '<Leader><Leader>O',
        \ }

"let g:sexp_enable_insert_mode_mappings = 0
" }}}

" Plugins(Dbext)
" {{{
let g:dbext_map_prefix = '<Leader>q'
let g:dbext_default_profile_hoge =
        \ 'type=MYSQL:host=192.168.1.100:user=mysql:passwd=mysql:dbname=hoge'
let g:dbext_default_profile_fuga =
        \ 'type=MYSQL:host=192.168.1.100:user=mysql:passwd=mysql:dbname=fuga'
let g:dbext_default_MYSQL_extra = '--default-character-set=utf8'
let g:dbext_default_profile = 'hoge'
let g:dbext_default_buffer_lines = 20
let g:dbext_default_always_prompt_for_variables=0
" }}}

" Custom commands
" {{{

" :Repl
" Clojure REPL.
if has('mac')
    function! Repl(dir)
        let script = "!osascript"
                \ . " -e 'tell application \"iTerm\"'"
                \ . " -e '  make new terminal'"
                \ . " -e '  tell the current terminal'"
                \ . " -e '    activate current session'"
                \ . " -e '    launch session \"Default session\"'"
                \ . " -e '    tell the last session'"
                \ . " -e '      write text \"cd " . a:dir . "; lein repl\"'"
                \ . " -e '    end tell'"
                \ . " -e '    end tell'"
                \ . " -e 'end tell'"
        execute script
    endfunction
    command! Repl silent! call Repl(expand("%:p:h"))
elseif has('unix')
else
    command! Repl !start cmd.exe /c cd /d "%:h"&& lein.bat repl
endif

" :Piggie
" ClojureScript REPL
function! Brepl()
    execute 'Piggieback (adzerk.boot-cljs-repl/repl-env)'
endfunction
command! Piggie silent! call Brepl()

" :Dos
" Command prompt for Windows.
if ( has('win32') || has('win64') )
    command! Dos !start cmd.exe /k cd /d "%:h"
endif

" :Marks
" List marks and jump to one.
function! s:Marks()
    marks
    echo 'Jump to mark: '
    let marks = nr2char(getchar())
    redraw
    execute 'normal! `' . marks
endfunction
command! Marks call s:Marks()

" s:VSetSearch()
" Search selected text
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" :ToggleSyntax
" Toggle syntax on/off.
function! s:ToggleSyntax()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunction
command! ToggleSyntax call s:ToggleSyntax()

" :Qargs
" Set arglist to files in quickfix list.
" Thanks to Drew Neil
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
    let buffer_numbers = {}
    for quickfix_item in getqflist()
        let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" :Sql
" Open Dbext
fu! OpenTabForSql()
    let f = 'C:\Users\gpsoft\sql\scratchpad.sql'
    let bn = bufwinnr(f)
    if bn > 0
        :exe bn.'wincmd w'
    else
        silent execute('tabe '.f.' | normal gg,qlt')
    endif
endfunc
command! Sql call OpenTabForSql()

" TortoiseSVN
fu! TortoiseCommand(com, others)
    let filename = expand("%")
    let svn = 'C:\Progra~1\TortoiseSVN\bin\TortoiseProc.exe'
    silent execute('!'.svn.' /command:'.a:com.' /path:"'.filename.'" /notempfile '.a:others)
endfunc
fu! TortoiseBlame()
    let filename = expand("%")
    let linenum = line(".")
    let others = '/line:'.linenum.' /closeonend'
    call TortoiseCommand('blame', others)
endfunc

" }}}

" Experimental
" {{{


" html
" let g:html_indent_script1="inc"
" let g:html_indent_style1="inc"
" let g:html_indent_inctags="html,body,head"

" haskell
"let g:haskell_conceal = 0
" }}}

" Key mappings
" {{{

let mapleader = ","
noremap \ ,

" File system
nnoremap <C-Q> :q<CR>
nnoremap <C-T> :w<CR>
nnoremap <Leader>E :Ex<CR>
nnoremap <Leader>S :Sex<CR>
nnoremap <Leader>V :Vex<CR>
nmap <Leader>ve :split $HOME/dotfiles/.vimrc<CR>
nmap <Leader>vs :so $MYVIMRC<CR>:RainbowParenthesesActivate<CR>
"After re-loading .vimrc rainbow paren gets off.
nmap <Leader>m :MRU<CR>
nmap <Leader>l :BufExplorerHorizontalSplit<CR>
nmap <Leader>o :CtrlPMixed<CR>
nmap <Leader>cs :split ~/dotfiles/cheat<CR>
nmap <Leader>cv :split ~/dotfiles/cheat/vim.md<CR>
nmap <Leader>cg :split ~/dotfiles/cheat/git.md<CR>
if exists('g:vimrc_local_path_notes')
    execute 'nmap <Leader>n :Ex' g:vimrc_local_path_notes.'<CR>'
endif
nnoremap <Leader>a :A<CR>
nnoremap <Leader>aa :A<CR>
nnoremap <Leader>av :AV<CR>
nnoremap <Leader>as :AS<CR>
nnoremap <Leader>at :AT<CR>

" Moving around
nmap <C-F> <Leader><Leader>f
nmap <Leader><Leader>f <Plug>(easymotion-overwin-f)
nmap <Leader>t :TagbarOpenAutoClose<CR>
nmap <Leader>T :echo tagbar#currenttag('[%s]', '')<CR>

" Searching
nmap <Leader>gg :vim //j %%**<CR>:copen<CR><C-w>J
nmap <Leader>gG :vim //j %%../**<CR>:copen<CR><C-w>J
nnoremap * :let @/="\\<".expand("<cword>")."\\>" \| :call histadd('search', @/) \| set hlsearch<CR>
nnoremap g* :let @/=expand("<cword>") \| :call histadd('search', @/) \| set hlsearch<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
" nnoremap & :&&<CR>

" Replacing
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Git(fugitive)
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gd :Gdiff<CR>
" nmap <Leader>gc :Gcommit<CR>
nmap <Leader>gb :Gblame<CR>
nmap <Leader>gl :Glog<CR>:copen<CR><C-w>J
nmap <Leader>gR :Gread<CR>
nmap <Leader>gW :Gwrite<CR>
"nmap <Leader>gp :Git push<CR>

" Indentation
nnoremap <Leader>F migg=G`izz
nnoremap <Leader>f mi=i}`izz

" Pasting
nnoremap gp "+gp
nnoremap gP "+gP
nmap <F2> :set invpaste<CR>

" Folding
nnoremap <Space> zA
nnoremap g<Space> zR

" Arrange windows
nnoremap <C-k> :res +3<CR>
" nnoremap <C-j> :res -3<CR>

" Misc
nnoremap <Leader>q :copen 10<CR><C-w>J
nmap <Leader>r :OverCommandLine<CR>%s/
nmap <Leader>p :PrevimOpen<CR>
" nmap <Leader>b :silent! !%:p<CR>
nmap <Leader>s :setlocal spell! spelllang=en_us,cjk<CR>:ToggleSyntax<CR>
nmap <Leader>` :Marks<CR>

" Insert mode
inoremap <C-w> <Nop>
inoremap <C-u> <Nop>
inoremap <C-t> <Esc><C-t>

" Command Window
cnoremap <expr> %% getcmdtype()==':' ? expand('%:h').'/' : '%%'
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Visual mode
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

" for Fireplace
nnoremap cpP :Eval<CR>

" for Tortoise svn
nnoremap <Leader>td : call TortoiseCommand('diff', '')<CR>
nnoremap <Leader>tl : call TortoiseCommand('log', '')<CR>
nnoremap <Leader>tc : call TortoiseCommand('commit', '')<CR>
nnoremap <Leader>tb : call TortoiseBlame()<CR>

" }}}

" Local config
" {{{
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
" }}}

" vim:fdm=marker:fmr={{{,}}}:fdl=0:sw=4:sts=4:ts=4:et:
