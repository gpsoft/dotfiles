# Vim Cheat Sheet

## コマンド

### 色見本
    :so $VIMRUNTIME/syntax/colortest.vim
    :so $VIMRUNTIME/syntax/hitest.vim

### rootで書く
    :w !sudo tee % >/dev/null

### 一括操作
    :g /{pattern}/ {command}

### FileFormat/Encodingを指定して開き直す
    :e ++ff=dos
    :e ++enc=utf-16le

## キー

### 移動
    H  M  L  {  }       画面の上 | 中 | 下 | 段落の上 | 下
    <C-E>  <C=Y>  zz    スクロール | 現在行を画面中央
    `{letter}  `.  `^   マークへ | 直前の変更点へ | 挿入点へ
    g;  g,              変更点をナビ

### バッファ/ウィンドウ
    gf <C-W>f           カーソル下のファイル
    <C-W>n              splitで新ファイル
    :only               他を閉じる
    q:                  コマンドラインウィンドウ
    <C-^>               トップ2をトグル
    <C-W>=              ウィンドウサイズ均等
    N<C-W>_  N<C-W>|    高さN行 | 幅N文字

### ビジュアル
    gv                  選択範囲を復活
    o                   端点をトグル

### 編集
    gcc  gc{motion}     コメントをトグル
    C  S  I  gi         $までc | ^から$までc | ^でi | `^でi

### Vim-Sorround
    S{delimiter}        選択範囲を囲む
    ys{text-obj}{delim} テキストオブジェクトを囲む
    cs{d1}{d2}  cst{d2} デリミタ/タグを変更
    ds{d1}{d2}  dst{d2} デリミタ/タグを削除
    sample: cs"'      " => '
            cst"      <tab> => "
            cs'<p>    <' => <p>
            ds"
            ysiw]     [xxx]
            yss)      sentence
            S{        { xxx }

### レジスタ
    "0  "1  "+  "%      ヤンク | 削除 | CB | 現在バッファのパス

### テキストオブジェクト/モーション
    b  B  t  s  p       () | {} | タグ | 文 | 段落
    gn  gN              次のマッチまで | 前のマッチまで

### 範囲指定
    .  $  %             現在行 | 最終行 | ファイル全体
    /{pattern}/         マッチまで
    .+5  .,$

### Netrw(with Vim-Vinegar)/ヘルプ
    -                   :Ex
    I                   ガイダンスを表示/非表示
    cg ~                ここへcd | $HOMEへ
    u U                 ディレクトリ履歴のナビ
    %  d                新ファイル | 新ディレクトリ
    K                   単語をhelp
    <C-]>  <C-T>        タグジャンプ | 戻る

### 検索/置換
    &  g&               ここで再置換 | バッファ全体で再置換
    \c \C %(...)        ignore case | case sense | no capture
    \v \V               very magic | very nomagic
    :s /{pattern}/~/&   同じreplacement、同じフラグ

### MISC
    ga                  文字コード


