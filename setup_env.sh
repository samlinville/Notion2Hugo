#!/bin/bash
#set -u -e -o pipefail

GITHUB_ACTOR="samlinville"

# setup git
git config --global user.email "samlinville@protonmail.com"
git config --global user.name "Sam Linville"
git config --global github.user "${GITHUB_ACTOR}"
git config --global github.token "${GITHUB_TOKEN_OVERRIDE}"

[ -d "blog" ] && git rm -r --cached blog
rm -rf blog

git submodule add --force https://github.com/samlinville/hugo-site-sammy.git blog

./NotiGoCMS

cd blog
git status
git add *
git status
now=`date "+%Y-%m-%d %a"`

# "git commit" returns 1 if there's nothing to commit, so don't report this as failed build
set +e
git commit -am "ci: update from notion on ${now}"
if [ "$?" -ne "0" ]; then
    echo "nothing to commit"
    exit 0
fi
set -e
git push "https://${GITHUB_ACTOR}:${GITHUB_TOKEN_OVERRIDE}@github.com/lvntbkdmr/blog.git" master || true
cd ../
