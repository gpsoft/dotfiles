"for Windows
"  fsutil hardlink create FROM TO
"  or "mklink FROM TO" should be better.
"for Mac/Linux
"  ln -s TO FROM

" COLOR TEST
" :so $VIMRUNTIME/syntax/colortest.vim
" :so $VIMRUNTIME/syntax/hitest.vim

" CHEAT SHEET ========================================
" :w !sudo tee % >/dev/null
" :g /{pattern}/ {command}
" Moving Around ======================================
" H  M  L  {  }       画面の上 | 中 | 下 | 段落の上 | 下
" <C-E>  <C=Y>  zz    スクロール | 現在行を画面中央
" `{letter}  `.  `^   マークへ | 直前の変更点へ | 挿入点へ
" <C-]>  <C-T>        タグジャンプ | 戻る
" g;  g,              変更点をナビ
" ,,s{letter}         EasyMotion
" Buffers/Windows ====================================
" gf <C-W>f           カーソル下のファイル
" <C-W>n              splitで新ファイル
" :only               他を閉じる
" q:                  コマンドラインウィンドウ
" <C-^>               トップ2をトグル
" <C-W>=              ウィンドウサイズ均等
" N<C-W>_  N<C-W>|    高さN行 | 幅N文字
" Visual mode ========================================
" gv                  選択範囲を復活
" o                   端点をトグル
" 
" ga                  文字コード
" "0  "1  "+  "%      ヤンク | 削除 | CB | 現在バッファのパス
"
" Make some editing ==================================
" gcc  gc{motion}     コメントをトグル
" S{delimiter}        選択範囲を囲む
" ys{text-obj}{delim} テキストオブジェクトを囲む
" cs{d1}{d2}  cst{d2} デリミタ/タグを変更
" ds{d1}{d2}  dst{d2} デリミタ/タグを削除
" <C-A>  <C-X>        inc | dec
" C  S  I  gi         $までc | ^から$までc | ^でi | `^でi
" <C-H>  <-CW>  <C-U> Backspace | 前のwをdel | ^か0までdel
" %%                  現在バッファのパス
" Text object ========================================
" b  B  t  s  p       () | {} | タグ | 文 | 段落
" gn  gN              次のマッチまで | 前のマッチまで
" Range/Address ======================================
" .  $  %             現在行 | 最終行 | ファイル全体
" /{pattern}/         マッチまで
" .+5  .,$
" NETRW ==============================================
" :e.                 カレントディレクトリで
" %  d                新ファイル | 新ディレクトリ
" Search/Replace =====================================
" &  g&               ここで再置換 | バッファ全体で再置換
" \c \C %(...)        ignore case | case sense | no capture
" \v \V               very magic | very nomagic
" :s /{pattern}/~/&   同じreplacement、同じフラグ
" Surround ===========================================
" motion: c/d/y + s or just S in visual mode
"         c(change/replace), d(delete), y(add)
" sample: cs"'      " => '
"         cst"      <tab> => "
"         cs'<p>    <' => <p>
"         ds"
"         ysiw]     [xxx]
"         yss)      sentence
"         S{        { xxx }

" to re-open the current buffer with different format or encoding.
" :e ++ff=dos
" :e ++enc=utf-16le

