#!/bin/bash
set -e

get_git_latest_release() {
    VERSION_AND_HASH=$(git ls-remote --tags --ref --sort="v:refname"  $1 | tail -n1)
    version=${VERSION_AND_HASH##*/}
    echo $version
}

package_dir=$1

cd $package_dir

git reset --hard HEAD
git pull

. ./PKGBUILD

gitUrl="https://github.com/lestofante/PacmanParallelizer.git"
echo "downloading $gitUrl"
version=$(get_git_latest_release $gitUrl)

if [[ -z $version ]]; then
    echo "could not find any tag"
    exit -1
fi

if [[ $pkgver == $version ]]; then
    echo "already up to date"
    exit 0
fi

echo "need update: package is $pkgver, $version is out"
sed -i "s/^pkgver=.*/pkgver=$version/g" PKGBUILD
sed -i "s/^pkgrel=.*/pkgrel=1/g" PKGBUILD

updpkgsums

makepkg --printsrcinfo > .SRCINFO

makepkg

git add PKGBUILD .SRCINFO
git commit -m "automatically updated from $pkgver to $version"
git push
