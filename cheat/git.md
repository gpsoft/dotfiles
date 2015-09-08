# Git Cheat Sheet

## 戻す
    git checkout -- FILE
    git reset HEAD^                      ...commit前へ
    git reset --hard ORIG_HEAD           ...pull(or merge)前へ
    git commit --amend                   ...直前のコミットを上書きする感じ

マージのdry run:
    git merge --no-commit --no-ff br1    してからの
    git reset --hard HEAD

## 無視する
    git update-index --assume-unchanged a-file-must-be-edited-locally
    git ls-files -v |grep ^h
    git update-index --no-assume-unchanged a-file-must-be-edited-locally

## 探す
    git branch --contains 8d7baf8
    git show :/^BUGFIX        ...メッセージがBUGFIXで始まる最後のコミット

## Diff
    git diff --name-only ..origin/br1      ...ファイル名のみ表示

## Branch
    git branch -r       ...リモートのブランチ
    git branch -a       ...全ブランチ
    git checkout -b br1 origin/br1       ...初めてのリモ追跡ブラをベースに作業する
    git branch --delete br1
    git branch -m br1 br1_trial   ...リネーム
    git branch -m br1_trial       ...カレントをリネーム
    git branch -d -r origin/br1       ...リモ追跡ブラを削除
                                      ...リモートのブランチを削除するわけではないし、追跡ブラとアップ追跡ブラの関係が切れるわけでもない

## Merge
    git merge --squash --no-commit br1   ...br1での複数のcommitオブジェクトをひとまとめで

## Remote
    git push --set-upstream origin br1   ...アップ追跡ブラを設定しつつpush
    git remote set-url origin git@github.com:gpsoft/othe.git   ...URL変更
    git push origin :br1           ...リモートリポジトリのbr1を削除
    git push --delete origin br1   ...リモートリポジトリのbr1を削除
    git branch --unset-upstream br1   ...br1の追跡設定を解除

## Cherry-pick
    git cherry-pick --no-commit 8d7baf8
    git cherry-pick br1           ...br1のtipのコミットだけをpick


## Stash
シンプルに:
    git stash
    work, work, work...
    git stash pop

いろいろ:
    git stash save "hoge hoge hoge"
    work, work, work...
    git stash save "fuga fuga"
    work, work, work...
    git stash list
    git stash show stash@{NUMBER}
    git stash pop stash@{NUMBER}              任意のstashを復帰
    git stash pop                             最後のstashを復帰
    git stash drop stash@{NUMBER}             任意のstashを廃棄
    git checkout stash@{NUMBER} foo.txt       一部のファイルだけ作業ツリーへ

- popの代わりにapplyなら、stashから削除せずに復帰できる
- popでconflictしたら、ハンドで修正して、そのファイルをaddして、stashをdropしとけばいい

## Submodule
### submoduleの追加
    cd ~/myproj
    git submodule add git://github.com/someone/somelib.git lib/somelib
                                       ...somelibの、現時点のブランチヘッドを取り込む
    git commit
    git push

### submodule付きのリポをclone
    cd ~
    git clone myproj otherwork
    cd otherwork
    git submodule init                 ...cloneだけでは不十分
    git submodule update               ...myprojのsomelibを取り込む
    あるいは、`clone`時に`--recursive`を付けるだけでもOK。

ここで取り込まれるsomelibは、sumelibの、submodule addした時点のブランチヘッド。そのミットは、cloneした時点では、既にブランチヘッドではないかもしれない。その場合、cloneしたローカルのsomelibのHEADはDETACHED状態である。

### submoduleをpull
    cd ~/myproj/lib/somelib
    git pull
    cd ..
    git commit
    git push

全submoduleをpullしたいなら以下。

    cd ~/myproj
    git submodule foreach git pull
    git commit
    git push

### submodule付きのリポをpull
    cd ~/otherwork
    git pull                           ...pullだけでは不十分
    git submodule init
    git submodule update

submoduleが増えている可能性もあるので、initが必要。あるいは以下でもOK。

    cd ~/otherwork
    git pull
    git submodule update --init

### submoduleの削除
    git submodule deinit lib/somelib   ...作業ディレクトリからsomelibを削除(init&updateすれば戻る)

    git rm lib/somelib                 ...リポジトリからsomelibを削除。
    git commit
    rm -rf .git/modules/lib/somelib

### submodule tips
Vimのプラグインをsubmoduleで管理していると、プラグインを使っているだけなのにsubmoduleの作業ツリーがdirtyになってしまうことがある。この場合、.gitmodulesを修正して、submoduleのuntrackedなファイルをignoreさせると良い。

    [submodule "vimfiles/bundle/vim-clojure-static"]
    path = vimfiles/bundle/vim-clojure-static
    url = https://github.com/guns/vim-clojure-static.git
    ignore = untracked

### submodule まとめ
gitは、.gitmodulesに、submoduleのurlとディレクトリの一覧を持つ。そこに登録するのがaddで、削除するのがdeinit。また、initによりリモートとローカルの.gitmodulesを同期し、updateにより.gitmodules内のsubmoduleをローカルに持ってくる。よってリモートに新しいsubmoduleが追加されたら、ローカルで再init&updateが必要。

## Configuration
    git config --get-regexp "^user"
    git config --global color.branch.upstream "dim cyan"
                   ...normal, black, red, green, yellow, blue, magenta, cyan, or white
                   ...bold, dim, ul, blink, and reverse
    git config --global core.quotepath false  ...日本語ファイル名

## 用語

- gitオブジェクト              ...commit, tag, tree, blobのどれか。ハッシュで識別する
- Ref                          ...gitオブジェクトを参照するポインタ(ハッシュ値)

- ブランチ                     ...枝。ブランチヘッドから遡れるcommitオブジェクトすべて
- ブランチヘッド               ...ブランチの先端。refs/heads/br1が参照しているcommitオブジェクト。単にブランチと呼ぶことも多い
- HEAD                         ...通常、カレントブランチのブランチヘッドを指す
- DETACHEDなHEADとは           ...ブランチヘッドでないcommitオブジェクトをcheckoutした状態。commitできない
- bareなリポジトリとは         ...作業ツリーを持たないリポジトリ。リモートリポジトリがbareでない場合、そのカレントブランチへローカルからpushすることはできない

- リモート(の)ブランチ         ...rm1のfugaとか
- リモート追跡ブランチ         ...ローカルのrm1/hogeとか。fetchするとこれが更新される。リモ追跡ブラ
- 追跡ブランチ                 ...ローカルのbr1が、リモートのブランチを追跡しているときのbr1のこと。追跡ブラ
- アップストリーム追跡ブランチ ...ローカルのbr1が、リモートのブランチを追跡しているときのリモ追跡ブラのこと。アップ追跡ブラ

      ローカル               　　リモート(rm1)
      -------------------        --------------
      br1 <====> rm1/hoge <====> fuga
      ↑追跡ブラ  ↑アップ追跡ブラ

- Refspec                      ...fetch, pull, pushにおいて、from(src)とto(dst)を指示するための引数。from:to、または+from:toと表記。+を付けるとffじゃなくてもto(dst)を更新する
- fast-forward                 ...マージにおいて、単にブランチヘッドを先へ進めるだけで済ませること。ff

## Ref

### 基準
    master
    br1
    ref/heads/br1

### designated
    HEAD
    FETCH_HEAD
    ORIG_HEAD
    MERGE_HEAD
    CHERRY_PICK_HEAD

### 履歴
    master@{yesterday}
    HEAD@{5 minutes ago}
    HEAD@{1 month 20 days ago}
    HEAD@{2015-03-15 13:00:00}

    br1@{2}   ...refs/heads/br1の2つ前の値
    @{2}      ...カレントブランチの2つ前の値
    @{-2}     ...2つ前にcheckoutしたやつ

### dereference
    br1@{upstream}  ...br1のupstream
    @{u}            ...カレントブランチのupstream
    tag1^{commit}   ...tag1が指すcommitオブジェクト
    tag1^{tree}
    tag1^{tag}
    tag1^{}         ...タグ以外のオブジェクトに行き着くまでderefする

    HEAD^      ...最初のparent
    HEAD^1     ...最初のparent
    HEAD^2     ...2番目のparent
    HEAD^2^    ...2番目のparentの最初のparent
    tag1^0     ...tag1^{commit}
    br1~3      ...br1^^^

### 検索
    br1^{/pattern}   ...コメントがマッチするyoungest commit
    :/pattern        ...どのrefからでもOK

### ツリーの一部
    HEAD:foo.txt
    br1@{2}:main.txt

### 競合ファイル
- stage0: 競合なし
- stage1: 共通の親
- stage2: merge先
- stage3: merge元


    :1:foo.txt    ...stage1
    :2:foo.txt    ...stage2
    :0:foo.txt    ...stage0
    :foo.txt      ...stage0

## Range
    master          ...masterから到達できる親
    ^origin/master  ...origin/masterから到達できる親は除く
    br1..br2        ...br2 ^br1
    br1...br2       ...br1かbr2のどちらか一方から到達できる親
    br1^@           ...br1の全ての祖先(自分は含まない)
    br1^!           ...br1 ^br1^ ^br1^2 ^br1^3(br1の親が3つあるとして)

## Hookスクリプト
### push禁止
    #!/bin/sh

    while read local_ref local_sha remote_ref remote_sha
    do
        echo $remote_ref
        if ! expr "${remote_ref##refs/heads/}" : "topic_.*$" >/dev/null; then
            echo "*** You can push topic branch only. ***"
            exit 1
        fi
    done

    exit 0

