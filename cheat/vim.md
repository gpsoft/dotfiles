# Vim Cheat Sheet

## コマンド

    vim -u essential.vim -U NONE
    vim --remote-silent
    :help starting
----
    :so $VIMRUNTIME/syntax/colortest.vim
    :so $VIMRUNTIME/syntax/hitest.vim
----
    :w !sudo tee % >/dev/null
    :[range]normal {command}
    :g/{pattern}/{command}
----
    :e ++ff=dos
    :e ++enc=utf-16le

## キー

    `^                  直前の挿入点へ
    {  }                段落の上 | 下
    gn  gN              次のマッチを選択 | 前の
    <C-W>n              splitで新ファイル
    N<C-W>_  N<C-W>|    高さN行 | 幅N文字
    gI                  0でi
    o                   端点をトグル(visual)
    <C-O>               一瞬normalへ(insert)
    <C-R><C-W>          wordを挿入(command line)

## Fireplace(Clojure)
    cpr                     require
    cpp cp{motion}          eval
    cmm cm{motion}          macroexpand
    c1mm c1{motion}         macroexpand-1
----
    :Eval :{range}Eval      eval
    :Require :Require! ns   require | :reload-all
    :Piggieback {port-no}   cljs.repl.browser
    cqp                     1行REPL(Quasi-REPL)
    cqc cq{motion}          コマンドラインウィンドウ
----
    c!! c!{motion}          評価結果をバッファへ
    :{range}Eval!
    :Eval! {expr}
    <C-R>(expr)
----
    gf <C-W>f               nsへ
    ]<C-D> <C-W>d           定義へ
    :Djump sym :Dsplit      定義へ
    ]d                      ソース表示
    :A :AS :AV :AT          テストファイルへ
----
    :Doc :FindDoc :Source   doc find-doc source
    :Javadoc :Apropos       公式サイト | apropos
    K [d                    docstring | source
    :lopen :Last :{n}Last   例外のスタックトレース | 評価結果履歴
----
    :Connect nrepl://host:port
    :make clear             lein clear

## Sexp

    W B E gE            要素間の移動
    ]] [[               トップレベルフォーム間の移動
    ) (                 カッコへ
----
    <e >e               要素入れ替え
    <f >f               フォーム入れ替え
----
    == =-               カレントフォームのインデント | トップレベルフォーム
----
    <I >I               先頭要素を挿入 | 最後
----
    <( >)               slurpage
    >( <)               barfage
    <LL>@               splice
    <LL>o <LL>O         このフォームだけ残す | 要素
    <LL>( <LL>)         フォームを()で囲んで先頭要素を挿入 | 最後
    <LL>[ <LL>]         フォームを[]で囲んで先頭要素を挿入 | 最後
    <LL>{ <LL>}         フォームを{}で囲んで先頭要素を挿入 | 最後
    <LL>e( <LL>e)       要素を()で囲んで先頭要素を挿入 | 最後
    <LL>e[ <LL>e]       要素を[]で囲んで先頭要素を挿入 | 最後
    <LL>e{ <LL>e}       要素を{}で囲んで先頭要素を挿入 | 最後


## 卒業
    :only <C-W>o        他を閉じる
    q: q/               コマンドラインウィンドウ
    <C-^>               トップ2をトグル
    gv                  選択範囲を復活
    gcc  gc{motion}     コメントをトグル
    ga                  文字コード
    <C-V> <C-V>u1234    as-is | in codepoint(insert)
    <C-K>               digraph(insert)
    <C-W>T              別タブへ
    H  M  L  {  }       画面の上 | 中 | 下 | 段落の上 | 下
    <C-E>  <C-Y>  zz    スクロール | 現在行を画面中央
    `{letter}  `.  `^   マークへ | 直前の変更点へ | 挿入点へ
    g;  g,              変更点をナビ
    gj gk               論理行で上下
----
    b  B  t  l s  p     () | {} | タグ | 文字 | 文 | 段落
----
    gf <C-W>f           カーソル下のファイル
    <C-W>n              splitで新ファイル
    <C-W>=              ウィンドウサイズ均等
    :tabe :tabonly
    :tabm 0             タブを先頭へ移動
----
    s                   xしてi
    C  S  I  gI gi      $までc | ^から$までc | ^でi | 0でi | `^でi
----
----
    "0  "1  "+  "%      ヤンク | 削除 | CB | 現在バッファのパス
    ": "/ "=            :コマンド | 検索 | Vimscript式
    @:                  直前の:コマンドを繰り返す
----
    .  $  %             現在行 | 最終行 | ファイル全体
    /{pattern}/         マッチまで
    .+5  .,$
    /<html>/+1,/<\html>/-1
----
    :&&  g&             ここで再置換 | バッファ全体で再置換
    \c \C %(...)        ignore case | case sense | no capture
    \v \V               very magic | very nomagic
    :s /{pattern}/~/&   同じreplacement、同じフラグ
----
    S{delimiter}        選択範囲を囲む
    ys{text-obj}{delim} テキストオブジェクトを囲む
    cs{d1}{d2}  cst{d2} デリミタ/タグを変更
    ds{d1}  dst{d1} デリミタ/タグを削除
    sample: cs"'        " => '
            cst"        <tab> => "
            cs'<p>      <' => <p>
            ds"
            ysiw]       [xxx]
            yss)        sentence
            S{          { xxx }
----
    -                   :Ex
    i                   表示モード切り替え
    I                   ガイダンスを表示/非表示
    cg ~                ここへcd | $HOMEへ
    u U                 ディレクトリ履歴のナビ
    %  d                新ファイル | 新ディレクトリ
    K                   単語をhelp
    <C-]>  <C-T>        タグジャンプ | 戻る
    :bp :bn             バッファ移動(<C-O>や<C-I>の代替)
