# GIT

{ghstars}`git/git` is a distributed version control system.

READ: https://www.atlassian.com/git/tutorials/git-log
[So You Think You Know Git - FOSDEM 2024](https://www.youtube.com/watch?v=aolI_Rz0ZqY)

## Configuration

The configuration is made out of [four files](git:git-config#FILES):

- `$(prefix)/etc/gitconfig`
- `$XDG_CONFIG_HOME/git/config`
- `~/.gitconfig`
- `$GIT_DIR/config`

Add credential cache (timed out daemon) when not using ssh authentication:

```bash
git config --global credential.helper cache
# Set the timeout to 300s instead 900s (defaut)
git config --global credential.helper 'cache --timeout=300'
# To explicitly exits the daemon
git credential-cache exit
```
### Conditional includes

Configurations can be conditionaly included with the [`includeIf`](git:git-config#_conditional_includes) directive. Conditions can be based on the project directory, the git version or the OS. 

```ini
[IncludeIf "gitdir:~/work/"]
    path = ~/work/gitconfig
[includeIf "gitdir:~/work/" and "gitversion:2.20.0"]
    path = ~/work/gitconfig-v2.20
```


## Commands : Porcelan and Plumbing

145 commandas are available in git, they are traditionally divided into [two categories](git:https:Git-Internals-Plumbing-and-Porcelain): *porcelain* and *plumbing*.

PORCELAIN (82)
    44 main commands (add, commit, push, pull, ...)
    11 manipulators (config, reflog, replace, ...)
    17 interrogators (blame, fsck, rerere, ...)
    10 interactors (send-email, p4, svn, ...)

PLUMBING (63)
    19 manipulators (apply, commit-tree, update-ref, ...)
    21 interrogators (cat-file, for-each-ref, ...)
    5 syncing (fetch-pack, send-pack, ...)
    18 internal (check-attr, sh-il8n, ...)

## Branches

### Create branches

Branches can be explicitly created with:

- `git branch <branch>` 

Implicit creation is done with:
- `git checkout -b <branch>`: creates the branch and checkout.
- `git switch -c <branch>`: Creates the branch and switch.

### Delete branches

Local branches can be deleted `git branch -d <branch>` or `git branch -D
<branch>` for a forced deletion. 
Remote branches can be deleted with `git push origin --delete <branch>`.

On Gitlab, an [API](https://docs.gitlab.com/ee/api/branches.html) is available to manage branches.

- branch protection can be unset with the `glab` command: 
    `glab api -X DELETE "/projects/:id/protected_branches/:name"`


## Revision selection

### Individual commit selection

#### SHA1 selection

Git allows selection of a single commit by its full 40 char. SHA1-hash.

- `git log <OPTIONS>` to display and locate commits. Ouptut format can be heavily customized.
- `git reflog` show local editions
- `git show <COMMIT>` to inspect a specific commit, for reflog specific entries, `@{<n>}` can be used to display history, e.g. `git show HEAD@{5}` will show the fifth entry of your reflog
- `git rev-parse <OPTIONS>`, belonging to *plumbing* tools can be used to investigate revisons at a lower lever


#### Ancestry selection

An ancestry can be selected by adding a `^` (caret) at the end of a reference, e.g. `HEAD^` to select the element's parent. Several carets can be used to select the parent in direct line or `~` (tilde). A parent sibling branch is selected by using a number next to the caret.

### Range selection

#### Double dot

Enable to see commits between two history points that can be on different branches, e.g.:

::::{admonition} Examples 
:class: dropdown m-0 p-0

```bash
:class: m-0 p-0
# Show what is beeing pulled (what's between HEAD and origin/master)
git log --pretty=oneline -n 10 HEAD..origin/master

# Show a branch history (master to parent's commit o new_branch)
git log master..new_branch^
```
::::

### Exclude reachable commit

This can be done with `^` before the commit or branch or by using thee `--not` syntax. e.g. to see all commits reachable from `refA` and `refB` but not `refC`:

:::{admonition} Examples 
:class: dropdown p-0 m-0

```bash
# Usage are equivalent
git log revA revB ^revC
git log revA revB --not revC

# Usage are equivalent
git log revA..revB
git log ^revA revB
git log rebB --not revA
```
:::

### Mutualy exclution: triple dot

Specify commits that are reachabel either by both references


### Examples

:::::{admonition} Examples
:class: dropdown

::::{tab-set}
:class: p-0 m-0 

:::{tab-item} Loeliger notation

```
    G   H   I   J
     \ /     \ /
      D   E   F
       \  |  / \
        \ | /   |
         \|/    |
          B     C
           \   /
            \ /
             A
```

:::

:::{tab-item} Ancestry selection

```
    G   H   I   J   |     A =      = A^0
     \ /     \ /    |     B = A^   = A^1     = A~1
      D   E   F     |     C = A^2  = A^2
       \  |  / \    |     D = A^^  = A^1^1   = A~2
        \ | /   |   |     E = B^2  = A^^2
         \|/    |   |     F = B^3  = A^^3
          B     C   |     G = A^^^ = A^1^1^1 = A~3
           \   /    |     H = D^2  = B^^2    = A^^^2  = A~2^2
            \ /     |     I = F^   = B^3^    = A^^3^
             A      |     J = F^2  = B^3^2   = A^^3^2
```

:::

:::{tab-item} Extended selection

```
    G   H   I   J   |      Args     |  Expanded arguments  |  Selected commits
     \ /     \ /    |     ----------|----------------------|------------------
      D   E   F     |       D       |                      | G H D
       \  |  / \    |       D F     |                      | G H I J D F
        \ | /   |   |       ^G D    |                      | H D
         \|/    |   |       ^D B    |                      | E I J F B
          B     C   |       ^D B C  |                      | E I J F B C
           \   /    |       C       |                      | I J F C
            \ /     |       B..C    |  = ^B C              | C
             A      |       B...C   |  = B ^F C            | G H D E B C
                    |       B^-     |  = B^..B             |
                    |               |  = ^B^1 B            | E I J F B
                    |       C^@     |  = C^1               |
                    |               |  = F                 | I J F
                    |       B^@     |  = B^1 B^2 B^3       |
                    |               |  = D E F             | D G H E F I J
                    |       C^!     |  = C ^C^@            |
                    |               |  = C ^C^1            |
                    |               |  = C ^F              | C
                    |       B^!     |  = B ^B^@            |
                    |               |  = B ^B^1 ^B^2 ^B^3  |
                    |               |  = B ^D ^E ^F        | B
                    |       F^! D   |  = F ^I ^J D         | G H D F
```
:::

::::

:::::

## Submodules

### Commands

`status` prints the SHA1 status of checked submodules. Prefixed with:

- **-** if the submodule is not initialized
- **+** in case of conflicts between current subdmodule and the index of the containing directory
- **U** in case of merge conflicts

### Remove a submodule

A submodule can be deleted by running `git rm <submodule path> && git commit`. `$GIT_DIR/modules/<name>` delete the submodule completly. Util then, deletion can be undone using `git revert`.

Alternative method:

Remove the submodule entry from .git/config
```
git submodule deinit -f path/to/submodule
```

Remove the submodule directory from the superproject's .git/modules directory
```
rm -rf .git/modules/path/to/submodule
```

Commit the changes
```
 git commit-m "Removed submodule "
```

Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
```
git rm -f path/to/submodule
```

### Updating submodule url and branch

The [submodule configuration](https://git-scm.com/docs/git-config#Documentation/git-config.txt-submoduleltnamegturl) can be displayed with `git config`:
```shell
git config -l
```
A specific config file can be given to `git config` with the `--file` [flag](https://git-scm.com/docs/git-config#Documentation/git-config.txt---fileconfig-file):

```shell
git config -l --file=.gitmodules

```

Url, branch and [other parameters](https://git-scm.com/docs/git-config#Documentation/git-config.txt-submoduleltnamegturl) can be configured via `git config`

```shell
git config --file=.gitmodules submodule.<submodule_name>.url <git@github.com:username/repository.git>
git config --file=.gitmodules submodule.<submodule_name>.branch <branch_name>
```

Synchronization adn update of the submodules are done with:

```shell
git submodule sync
git submodule update --init --recursive --remote --merge
# ! If --merge option is missing, HEAD will be detached
```

### Tags

Get the most recent tag:

```shell
git describe --tags --abbrev=0
```

## Git diff

Git diff can be displayed side by side with delta as a pager
<badge-stars repo='dandavison/delta'></badge-stars> <badge-doc
href='https://github.com/dandavison/delta#configuration'></badge-doc>

```ini
[core]
    pager = delta
```

Open all files with git merge conflicts.

```shell
git diff --name-only | uniq | xargs vim
```

Vim has a powerfull diff mode <badge-doc
href='https://vimhelp.org/diff.txt.html' logo='vim'></badge-doc>.

Jumping to diff, backwards/forewargs: `[c`, `]c`.

## List files

### Tree modifications

```{eval-rst}
.. role:: bash(code)
   :language: bash

.. role:: console(code)
   :language: console

List files ready to be committed
    :bash:`git diff --cached --name-only`

List modified files containing the string `spam`
    :bash:`git ls-files --modified | xargs git grep -l "spam"`

List deleted files
    :bash:`git ls-files --deleted`

List untracked files
    :bash:`git ls-files --others --exclude-standard`

List untracked directories
    :bash:`git ls-files --others --exclude-standard --directory`

List untracked files containing the string `spam`
    :bash:`git ls-files --others --exclude-standard | xargs git grep -l "spam"`

List deleted files between two commits
    :bash:`git log --diff-filter=D --summary HEAD~10..HEAD~9 | grep delete | awk '{print $4}'`


```

## Search history

```{eval-rst}
.. role:: bash(code)
   :language: bash

.. role:: console(code)
   :language: console

List the last 10 commits on one line
    :bash:`log -n 10 --date=short --decorate --pretty=oneline`

List the last 10 commits on one line with custom format
    :bash:`log -n 10 --date=short --decorate --pretty=format:%C(yellow)%h\ %ad%Cred%d\ %Creset%s%Cblue\ [%cn]`

Search the first 20 commits whose comment contains string "spam", case insensitive
    :bash:`git log -i --grep ^spam -n 20` 
```

## History revision

Rewrite history: `git rebase`

### Edit already pushed specific commit

!!! Danger "This is to be done in very specific situations"


- Specify a rebase by identifying an earlier commit `git rebase -i <Earlier
  Commit>`
- in the interactive pane, select `edit` for the commit to be rewritten
- amend the part of the commit to be edited, e.g.:

    - `git commit --amend --author="Author Name <email@address.com>"`
    - `git commit  --amend --date="$(date -R)"`
    - `git commit --amend -m "New Commit Message"`

- eventualy, edit the commit message
- continue with the rebase: `git rebase --continue`
- force a pull `git pull --force`


## Cherry pick from another repository

First the other repository source must be added to the remote list
```
git remote add other https://other.url/repository.git
git fetch other
```

Then use [`git cherry-pick`](https://git-scm.com/docs/git-cherry-pick)

## Others

{ghstars}`siderolabs/conform` is a tool for enforcing policies on your
build pipelines.


:::{dropdown} Conventional commits

Conventional Commits 1.0.0

The Conventional Commits specification is a convention on top of
commit messages. It dovetails with [SemVer](http://semver.org), by describing the features, fixes, and breaking changes made in commit messages. Conventional commits are used to write automated tools on top of.

The commit message should be structured as follows:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

<br />
The commit contains the following structural elements, to communicate intent
to the consumers of your library:

1. **fix:** a commit of the _type_ `fix` patches a bug in your codebase
   (this correlates with [`PATCH`](http://semver.org/#summary) in semantic
   versioning).
1. **feat:** a commit of the _type_ `feat` introduces a new feature to the
   codebase (this correlates with [`MINOR`](http://semver.org/#summary) in
   semantic versioning).
1. **BREAKING CHANGE:** a commit that has a footer `BREAKING CHANGE:`, or
   appends a `!` after the type/scope, introduces a breaking API change
   (correlating with [`MAJOR`](http://semver.org/#summary) in semantic
   versioning).
A BREAKING CHANGE can be part of commits of any _type_.
1. _types_ other than `fix:` and `feat:` are allowed, for example
   [@commitlint/config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional)
   (based on the [the Angular
   convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines))
   recommends `build:`, `chore:`,
  `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, and others.
1. _footers_ other than `BREAKING CHANGE: <description>` may be provided and
   follow a convention similar to [git trailer
   format](https://git-scm.com/docs/git-interpret-trailers).

Additional types are not mandated by the Conventional Commits specification,
and have no implicit effect in semantic versioning (unless they include a
BREAKING CHANGE). <br /><br />
A scope may be provided to a commit's type, to provide additional contextual
information and is contained within parenthesis, e.g., `feat(parser): add
ability to parse arrays`.

 Examples

### Commit message with description and breaking change footer
```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for extending other config files
```

### Commit message with `!` to draw attention to breaking change
```
refactor!: drop support for Node 6
```

### Commit message with both `!` and BREAKING CHANGE footer
```
refactor!: drop support for Node 6

BREAKING CHANGE: refactor to use JavaScript features not available in Node 6.
```

### Commit message with no body
```
docs: correct spelling of CHANGELOG
```

### Commit message with scope
```
feat(lang): add polish language
```

### Commit message with multi-paragraph body and multiple footers
```
fix: correct minor typos in code

see the issue for details

on typos fixed.

Reviewed-by: Z
Refs #133
```

## Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”,
“SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this
document are to be interpreted as described in [RFC
2119](https://www.ietf.org/rfc/rfc2119.txt).

1. Commits MUST be prefixed with a type, which consists of a noun, `feat`,
   `fix`, etc., followed by the OPTIONAL scope, OPTIONAL `!`, and REQUIRED
   terminal colon and space.
1. The type `feat` MUST be used when a commit adds a new feature to your
   application or library.
1. The type `fix` MUST be used when a commit represents a bug fix for your
   application.
1. A scope MAY be provided after a type. A scope MUST consist of a noun
   describing a section of the codebase surrounded by parenthesis, e.g.,
   `fix(parser):`
1. A description MUST immediately follow the colon and space after the
   type/scope prefix. The description is a short summary of the code
   changes, e.g., _fix: array parsing issue when multiple spaces were
   contained in string_.
1. A longer commit body MAY be provided after the short description,
   providing additional contextual information about the code changes. The
   body MUST begin one blank line after the description.
1. A commit body is free-form and MAY consist of any number of newline
   separated paragraphs.
1. One or more footers MAY be provided one blank line after the body. Each
   footer MUST consist of a word token, followed by either a `:<space>` or
   `<space>#` separator, followed by a string value (this is inspired by the
   [git trailer
   convention](https://git-scm.com/docs/git-interpret-trailers)).
1. A footer's token MUST use `-` in place of whitespace characters, e.g.,
   `Acked-by` (this helps differentiate the footer section from a
   multi-paragraph body). An exception is made for `BREAKING CHANGE`, which
   MAY also be used as a token.
1. A footer's value MAY contain spaces and newlines, and parsing MUST
   terminate when the next valid footer token/separator pair is observed.
1. Breaking changes MUST be indicated in the type/scope prefix of a commit,
   or as an entry in the footer.
1. If included as a footer, a breaking change MUST consist of the uppercase
   text BREAKING CHANGE, followed by a colon, space, and description, e.g.,
   _BREAKING CHANGE: environment variables now take precedence over config
   files_.
1. If included in the type/scope prefix, breaking changes MUST be indicated
   by a `!` immediately before the `:`. If `!` is used, `BREAKING CHANGE:`
   MAY be omitted from the footer section, and the commit description SHALL
   be used to describe the breaking change.
1. Types other than `feat` and `fix` MAY be used in your commit messages,
   e.g., _docs: updated ref docs._
1. The units of information that make up Conventional Commits MUST NOT be
   treated as case sensitive by implementors, with the exception of BREAKING
   CHANGE which MUST be uppercase.
1. BREAKING-CHANGE MUST be synonymous with BREAKING CHANGE, when used as a
   token in a footer.

:::

{ghstars}`x-motemen/ghq` provides a way to
organize remote repository clones, like go get does.

## Hooks

Hooks <badge-doc
href='https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks'></badge-doc> are
executable scripts, generaly located in `.git/hooks`. They can be devided into
two groups:

- client-side
- server-side

### Client side

| Hook                 | Run description                                                                                                                                     |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `post-checkout`      | after a successful git checkout                                                                                                                     |
| `pre-commit`         | before commiting message, general checks like linting                                                                                               |
| `prepare-commit-msg` | before the commit message editor is fired up but after the default message is created, good for commits where the default message is auto-generated |
| `commit-msg`         | validate project state or commit message                                                                                                            |
| `pre-rebase`         | before you rebase anything                                                                                                                          |
| `pre-push `          | during `git push`, after the remote refs have been updated but before any objects have been transferred                                             |
| `post-rewrite`       | triggered by commands that replace commits, such as `git commit --amend` and `git rebase`                                                           |
| `post-merge`         | after a successful `merge` command                                                                                                                  |
| `post-commit`        | once eveything coompleted.                                                                                                                          |


There are other hooks, invoked by specific commands:

- `pre-auto-gc` by invoking garbage collection `git gc --auto`
- `applypatch-msg`, `pre-applypatch` and `post-applypatch` all invoked by `git
  am` for an email-based workflow.

??? example "Post commit"

    ```bash
    #!/bin/bash
    #
    # Update a superproject when a commit is made to a submodule.
    # Intended for .git/**modules/{THE_SUBMODULE}/hooks/post-commit
    # where the double-star indicates variadic path elements.
    #
    # Depends on Git >= 2.13.

    # Clean the Git environment before crossing repository boundaries.
    # From https://stackoverflow.com/questions/36196548
    while read variable; do
        unset $variable
    done < <(env | grep "^GIT_" | sed 's/=.*//g')

    COMMIT_MSG=$(git log --format=%B -n 1)
    GIT="git"
    SUPERPROJECT_WORKING_TREE=`git rev-parse --show-superproject-working-tree`

    echo "📣 Committing to $SUPERPROJECT_WORKING_TREE."

    cd $SUPERPROJECT_WORKING_TREE
    $GIT add .
    $GIT commit -m "$COMMIT_MSG"
    ```

### Server side

| Hook           | Run description                                                                                |
|----------------|------------------------------------------------------------------------------------------------|
| `pre-receive`  | first script to run when handling a push from a client. Runs only once.                        |
| `post-receive` | run once for each branch the pusher is trying to update                                        |
| `update`       | after the entire process is completed and can be used to update other services or notify users |

Installation must be performed on the server, see e.g. for
[gitlab](https://docs.gitlab.com/ee/administration/server_hooks.html). If no
admin rights are available, some alternatives:

- webhooks
  [github](https://docs.github.com/en/free-pro-team@latest/developers/webhooks-and-events/webhooks)/[gitlab](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html)
- CI/CD pipeline
  [github](https://docs.github.com/en/free-pro-team@latest/actions)
  [gitlab](https://docs.gitlab.com/ee/ci/README.html)
- push rules [gitlab](https://docs.gitlab.com/ee/push_rules/push_rules.html)


## Git flow

From [Scott Chacon blog](http://scottchacon.com/2011/08/31/github-flow.html):

> - To work on something new, create a descriptively named branch off of master
> - Commit to that branch locally and regularly push your work to the same named branch on the server
> - When you need feedback or help, or you think the branch is ready for merging, open a pull request
> - After someone else has reviewed and signed off on the feature, you can merge it into master

### Pull request

https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/
https://stackoverflow.com/questions/14680711

https://stackoverflow.com/questions/29049650


Switch branches or restore working tree files


```shell
git checkout master
git checkout -b mybranch
```

`git remote` manage the set of repositories ("remotes") whose branches you track.

```shell
git remote -v
# If upstream is not configured, add the upstream route
git remote add upstream /url/original/repo

git fetch upstream

# reset master to upstream/master
git checkout master
git reset --hard upstream/master
git push --force

  y--y--y (mybranch)
 /
z--z--z   (master, upstream/master, origin/master)

# replay the patches (even they are rejected for now) on top of master
git checkout mybranch
git rebase master
git push -u origin mybranch

        y'--y'--y' (mybranch, origin/mybranch)
       /
z--z--z   (master, upstream/master, origin/master)
```


## Platform specific

### Github

**cli** <badge-stars repo='cli/cli'></badge-stars> is github official cli tool.


#### Change the repository language detection

[`.gitattributes`](https://git-scm.com/docs/gitattributes/2.9.5) s used for the files you want to override using the `linguist-documentation`, `linguist-language`, `linguist-vendored`, `linguist-generated` and `linguist-detectable` attributes.

Installation <badge-doc href='https://github.com/github/linguist#installation', logo='github'></badge-doc> is performed with gem:
```bash
gem install github-linguist
```

#### Github action

**act** <badge-stars repo='nektos/act'></badge-stars> run GitHub Actions locally.
