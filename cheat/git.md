# Git Cheat Sheet

## 戻す
    git checkout -- FILE
    git reset --hard ORIG_HEAD           ...pull(or merge)前へ

マージのdry run:
    git merge --no-commit --no-ff br1    ...してからの
    git reset --hard HEAD

## Diff
    git diff --name-only ..origin/br1      ...ファイル名のみ表示

## Branch
    git branch -r       ...リモートのブランチ
    git branch -a       ...全ブランチ
    git branch --delete br1

## Merge
    git merge --squash --no-commit br1   ...br1での複数のコミットをひとまとめで

## Remote
    git push --set-upstream origin br1   ...アップ追跡ブラを設定しつつpush
    git remote set-url origin git@github.com:gpsoft/othe.git   ...URL変更
    git push origin :br1           ...リモートリポジトリのbr1を削除
    git push --delete origin br1   ...リモートリポジトリのbr1を削除

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
    git stash pop stash@{NUMBER}              任意のstashを復帰
    git stash pop                             最後のstashを復帰
    git stash drop stash@{NUMBER}             任意のstashを廃棄

- popの代わりにapplyなら、stashから削除せずに復帰できる
- popでconflictしたら、ハンドで修正して、そのファイルをaddして、stashをdropしとけばいい

## Submodule
    cd ~/myproj
    git submodule add git://github.com/someone/somelib.git lib/somelib
                                              ...somelibの、そのコミットを取り込む
    git commit

    cd ~
    git clone myproj otherwork
    cd otherwork
    git submodule init                        ...cloneだけでは不十分
    git submodule update                      ...myprojのsomelibを取り込む

    誰かがsomelibに変更を加えてcommit&push

    cd ~/otherwork
    git pull
    git submodule update

    git submodule deinit lib/somelib           ...作業ディレクトリからsomelibを削除(init&updateすれば戻る)

    git rm lib/somelib                 ...リポジトリからsomelibを削除。
    git commit
    rm -rf .git/modules/lib/somelib

## Configuration
    git config --get-regexp "^user"
    git config --global color.branch.upstream "dim cyan"
                   ...normal, black, red, green, yellow, blue, magenta, cyan, or white
                   ...bold, dim, ul, blink, and reverse
    git config --global core.quotepath false  ...日本語ファイル名

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
    tag1^{commit}   ...tag1が指すコミット
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

