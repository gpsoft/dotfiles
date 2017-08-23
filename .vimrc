scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac

"Not necessary if you use 'vimfiles' instead of '.vim'.
"if ( (has('win32') || has('win64')) &&
"     !exists("g:loaded_pathogen"))
"    "Add .vim to runtime path for Win.
"    "But this causes a problem when re-loading rc(pathogen can't find plagins?),
"    "so do it only first load.
"    set runtimepath=~/.vim,$VIMRUNTIME
"endif

"Pathogen.
let g:pathogen_disabled = [
    \ "paredit.vim",
    \ "PHP-Indenting-for-VIm",
    \ "Align",
    \ "SQLUtilities",
    \ "dbext.vim",
    \ "vim-projectionist"
    \ ]  "Plugins you want to disable temporalily.
execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype plugin indent on

if filereadable(expand("~/.vimrc.constants.local"))
  source ~/.vimrc.constants.local
endif

"Auto commands.
augroup vimrc
    autocmd!

    "Tab.
    autocmd FileType vim setlocal sw=4 sts=4 ts=4 et
    autocmd FileType ruby setlocal sw=2 sts=2 ts=2 et
    autocmd FileType go setlocal sw=4 sts=4 ts=4 noet
    autocmd FileType markdown setlocal sw=2 sts=2 ts=2 et
    autocmd FileType java setlocal sw=4 sts=4 ts=4 et
    autocmd FileType javascript setlocal sw=4 sts=4 ts=4 et
    autocmd FileType yaml setlocal sw=4 sts=4 ts=4 et
    autocmd FileType json setlocal sw=4 sts=4 ts=4 et
    autocmd FileType php setlocal sw=4 sts=4 ts=4 et
    autocmd FileType html setlocal sw=4 sts=4 ts=4 et
    autocmd FileType sh setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xml setlocal sw=4 sts=4 ts=4
    autocmd FileType css setlocal sw=4 sts=4 ts=4 et

    "Map file extension to file type.
    autocmd BufNewFile,BufRead *.ctp set filetype=php
    autocmd BufNewFile,BufRead *.log set filetype=messages
    autocmd BufNewFile,BufRead *.cljs set filetype=clojure
    autocmd BufNewFile,BufRead *.boot set filetype=clojure
    if has('mac')
        " MacVimでは、mdを開いた後でsplitするとfiletypeがmodula2に戻ってしまう。
        " しかたないのでvim本体を修正した。
        " /Applications/MacVim.app/Contents/Resources/vim/runtime/filetype.vim
    else
        autocmd BufNewFile,BufRead *.md set filetype=markdown
    endif

    autocmd FileType messages setlocal autoread
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType clojure setlocal lispwords+=defproject,provided,tabular,domonad,with-monad,defmonad,deftask
    " autocmd FileType clojure setlocal iskeyword-=/
    " autocmd FileType clojure setlocal iskeyword-=.
    autocmd FileType gitcommit setlocal spell
    autocmd FileType clojure let g:paredit_leader=',,'
    autocmd FileType clojure let g:paredit_electric_return=0
    autocmd FileType php setlocal foldmethod=indent | normal zR
    autocmd FileType php setlocal indentkeys="0{,0},0),:,!^F,o,O,e,*<Return>,=?>,=>,=*/"

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

    "autocmd bufwritepost .vimrc source $MYVIMRC
    autocmd bufwritepost *.md call previm#refresh()
augroup END

"--------------------------------- Plugins ---------------------------------
"NETRW
" let g:netrw_keepdir=0
let g:netrw_keepj="keepj"
" let g:netrw_liststyle=3
" let g:netrw_silent=1

"MATCHIT
runtime macros/matchit.vim

"MRU
let MRU_Max_Entries = 100
let MRU_Exclude_Files = "^crontab\."

"LIGHTLINE
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
    "Inactive line is too dark, let's lighten it up a bit.
    hi LightLineLeft_inactive_0 ctermbg=248 ctermfg=234 guibg=#a0a0a0 guifg=#000000
    hi LightLineLeft_inactive_0_1 ctermbg=238 ctermfg=248 guibg=#444444 guifg=#a0a0a0
    hi LightLineMiddle_inactive ctermbg=238 guibg=#444444
    hi LightLineRight_inactive_1_2 ctermbg=238 ctermfg=238 guibg=#444444 guifg=#444444
endfunction
autocmd VimEnter * call AlterWombat()
            "It doesn't work in CUI; too early.
autocmd BufRead * call AlterWombat()

"VIM-CLOJURE-STATIC
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^\(future-\)\?facts\?$', '^prerequisites\?$']
let g:clojure_maxlines = 300

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
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces

"CTRLP
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

"VIM-JSON
let g:vim_json_syntax_conceal = 0

"UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

"Vim-sexp
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

"Tagbar
let g:tagbar_width=50
let g:tagbar_type_php={
            \ 'ctagsargs': '--php-kinds=cdf -f -',
            \ 'kinds': [
            \ 'c:classes',
            \ 'd:constant definitions:0:0',
            \ 'f:functions']}

"BufExplorer
let g:bufExplorerShowDirectories=0
let g:bufExplorerShowNoName=0
let g:bufExplorerShowUnlisted=0
let g:bufExplorerSortBy='fullpath'

"Open-Browser & previm
"let g:netrw_browsex_viewer="firefox-bin"
" if exists('g:vimrc_local_browser')
"     execute 'let g:previm_open_cmd="'.g:vimrc_local_browser.'"<CR>'
" endif

"SQLUtilities
let g:sqlutil_load_default_maps = 0
let g:sqlutil_align_where = 0
let g:sqlutil_align_comma = 1

"dbext
let g:dbext_map_prefix = '<Leader>q'
let g:dbext_default_profile_hoge = 'type=MYSQL:host=192.168.1.100:user=mysql:passwd=mysql:dbname=hoge'
let g:dbext_default_profile_fuga = 'type=MYSQL:host=192.168.1.100:user=mysql:passwd=mysql:dbname=fuga'
let g:dbext_default_MYSQL_extra = '--default-character-set=utf8'
let g:dbext_default_profile = 'hoge'
let g:dbext_default_buffer_lines = 20
let g:dbext_default_always_prompt_for_variables=0

"--------------------------------- Options ---------------------------------
set t_Co=256
colorscheme slate

"Block cursor in terminal.
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"
" set t_ve+=[?81;0;112c

set notitle
set suffixesadd=.clj,.cljs,.rb  "for gf
set nrformats=            "format for <C-A> or <C-X>
set hidden
set ignorecase
set smartcase
set infercase
set incsearch
"set nowrapscan

let mapleader = ","
noremap \ ,

set noundofile
set backup
set noswapfile
if has('mac')
    set backupdir=/var/tmp/bak
    set backupskip=/tmp/*,/private/tmp/*
elseif has('unix')
    set backupdir=/var/tmp/bak
    set backupskip=/tmp/*,/private/tmp/*
else
    if filereadable('c:\tmp\apptmp\nul')
        set backupdir=c:\tmp\apptmp\bak
        set directory=c:\tmp\apptmp\swp
    else
        set backupdir=d:\tmp\apptmp\bak
        set directory=d:\tmp\apptmp\swp
    endif
endif

set pastetoggle=<F2>
set showmode

set tw=0
autocmd FileType text setlocal tw=0
        "Global setting doesn't work for text filetype?

highlight ColorColumn ctermbg=magenta guibg=Magenta
call matchadd('ColorColumn', '\%82v', 100)

set number
"Relativenumber can make scroll slow in terminal.
" set relativenumber

if ( has('win32') || has('win64') )
    set listchars=    " better to clear lcs before setting ambiwidth to auto or double; or you could get E834.
    set ambiwidth=auto
    "Moved list setting to .gvimrc.
    "set list lcs=tab:»\ ,eol:¬,trail:·
else
    set ambiwidth=double
    "set list lcs=tab:»\ ,eol:¬,trail:·
    set list lcs=tab:»\ ,eol:¬,trail:©
    " .bash_profile
    " export VTE_CJK_WIDTH=1
endif

set laststatus=2

set noimdisable
set iminsert=0
set imsearch=-1
set noimcmdline
inoremap <silent> <C-[> <ESC>:set iminsert=0<CR>
if has('unix')
    function! ImeOff()
        exec system("fcitx-remote -c")
    endfunction
    autocmd! InsertLeave * call ImeOff()
endif

"--------------------------------- Custom commands -------------------------
"Clojure REPL.
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

"ClojureScript REPL
function! Brepl()
    execute 'Piggieback (adzerk.boot-cljs-repl/repl-env)'
endfunction
command! Piggie silent! call Brepl()

"Command prompt for Windows.
if ( has('win32') || has('win64') )
    command! Dos !start cmd.exe /k cd /d "%:h"
endif

"--------------------------------- Experimental ----------------------------
let php_htmlInStrings=1
let php_sql_query=1
" let php_folding=1   " it may slow vim down

let g:html_indent_script1="inc"
let g:html_indent_style1="inc"
let g:html_indent_inctags="html,body,head"

"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

":Qargs
"to set arglist to files in quickfix list.
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
    let buffer_numbers = {}
    for quickfix_item in getqflist()
        let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

"let g:EasyMotion_use_migemo = 1
let g:EasyMotion_do_mapping=0
nmap <C-F> <Leader><Leader>f
nmap <Leader><Leader>f <Plug>(easymotion-overwin-f)

"let g:sexp_enable_insert_mode_mappings = 0

"let g:haskell_conceal = 0

"let g:clojure_fold = 1
let g:clojure_highlight_references = 1
let g:clojure_align_multiline_strings = 0

nmap <C-Q> :q<CR>
nmap <C-T> :w<CR>

function! s:PhpIndent() range
    let t = &filetype
    let &filetype='php'
    execute a:firstline . ',' .a:lastline . 'normal! =='
    let &filetype = t
endfunction
command! -range PhpIndent <line1>,<line2>call s:PhpIndent()
vmap g= :PhpIndent<CR>

function! s:Marks()
    marks
    echo 'Jump to mark: '
    let marks = nr2char(getchar())
    redraw
    execute 'normal! `' . marks
endfunction
command! Marks call s:Marks()
nmap <Leader>` :Marks<CR>

function! s:ToggleSyntax()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunction
command! ToggleSyntax call s:ToggleSyntax()

"--------------------------------- Keymaps ---------------------------------
nmap <Leader>E :Ex<CR>
nmap <Leader>S :Sex<CR>
nmap <Leader>V :Vex<CR>
nmap <Leader>q :copen 10<CR><C-w>J
nmap <Leader>ve :split $HOME/dotfiles/.vimrc<CR>
nmap <Leader>vs :so $MYVIMRC<CR>:RainbowParenthesesActivate<CR>
                   "After re-loading .vimrc rainbow paren gets off.
nmap <Leader>m :MRU<CR>
nmap <Leader>l :BufExplorerHorizontalSplit<CR>
nmap <Leader>o :CtrlPMixed<CR>
nmap <Leader>r :OverCommandLine<CR>%s/
nmap <Leader>p :PrevimOpen<CR>
nmap <Leader>t :TagbarOpenAutoClose<CR>
nmap <Leader>T :echo tagbar#currenttag('[%s]', '')<CR>
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gd :Gdiff<CR>
" nmap <Leader>gc :Gcommit<CR>
nmap <Leader>gb :Gblame<CR>
nmap <Leader>gl :Glog<CR>:copen<CR><C-w>J
nmap <Leader>gR :Gread<CR>
nmap <Leader>gW :Gwrite<CR>
"nmap <Leader>gp :Git push<CR>
nmap <Leader>gg :vim //j %%**<CR>:copen<CR><C-w>J
nmap <Leader>gG :vim //j %%../**<CR>:copen<CR><C-w>J
nmap <Leader>b :silent! !%:p<CR>
nnoremap <Leader>F migg=G`izz
nnoremap <Leader>f mi=i}`izz
" nnoremap <Leader>* *``zz
nnoremap * :let @/="\\<".expand("<cword>")."\\>" \| :call histadd('search', @/) \| set hlsearch<CR>
nnoremap g* :let @/=expand("<cword>") \| :call histadd('search', @/) \| set hlsearch<CR>

nnoremap gp "+gp
nnoremap gP "+gP

nnoremap <Space> zA

nmap <F2> :set invpaste<CR>

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap & :&&<CR>

nmap <Leader>s :setlocal spell! spelllang=en_us,cjk<CR>:ToggleSyntax<CR>

nnoremap <C-k> :res +3<CR>
" nnoremap <C-j> :res -3<CR>

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

imap <C-w> <Nop>
imap <C-u> <Nop>
imap <C-t> <Esc><C-t>

cnoremap <expr> %% getcmdtype()==':' ? expand('%:h').'/' : '%%'
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
" xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
" function! s:VSetSearch()
"     let temp = @s
"     norm! gv"sy
"     let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
"     let @s = temp
" endfunction

"for special directories.
nmap <Leader>cs :split ~/dotfiles/cheat<CR>
nmap <Leader>cv :split ~/dotfiles/cheat/vim.md<CR>
nmap <Leader>cg :split ~/dotfiles/cheat/git.md<CR>
if exists('g:vimrc_local_path_notes')
    execute 'nmap <Leader>n :Ex' g:vimrc_local_path_notes.'<CR>'
endif

nmap cpP :Eval<CR>

" for projectionist
nnoremap <Leader>a :A<CR>
nnoremap <Leader>aa :A<CR>
nnoremap <Leader>av :AV<CR>
nnoremap <Leader>as :AS<CR>
nnoremap <Leader>at :AT<CR>

" for ebext
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

" for tortoise svn
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
nnoremap <Leader>td : call TortoiseCommand('diff', '')<CR>
nnoremap <Leader>tl : call TortoiseCommand('log', '')<CR>
nnoremap <Leader>tc : call TortoiseCommand('commit', '')<CR>
nnoremap <Leader>tb : call TortoiseBlame()<CR>

