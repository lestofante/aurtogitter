# aurtogitter

Aurtogitter is a collection of script to automatically check for new tag on a git repo,
and if found to update and release a new version of the PKGBUILD.

To work properly the PKGBUILD must have:
- variable `urlgit` that point to the source git repo, for example `urlgit="https://github.com/lestofante/PacmanParallelizer.git"`
- `source()` must be checking out the repo and the tag based of $pkgver, for example `source=("$pkgname-$pkgver"::"git+$urlgit#tag=$pkgver")`

As said, this script trust the author of the PKGBUILD: I assume you are author and just want to speed up your work.
It also assume you have all the necessary setup to push the repo (ssh key, git username and email set).

## update.sh

### usage
update.sh <path_to_aur_repo_folder>

### behaviur

- hard reset to HEAD (insure clean state, DANGEROUS! you may loose data)
- pull
- estract the required information (DANGEROUS! it trust the PKGBUILD)
- check for new tag (easy to add some grep rules to grep only actual release tag)
- update pkgver to the new version
- update pkgrel to 1
- update the checksum
- update .SRCINFO
- make the package (DANGEROUS! it trust the PKGBUILD, but make sure the release is not broken)
- push the modification

any failure of any step will lead to immediate interruption of the script.

## example MAKEPKG
```
# Maintainer: lesto <lestofante88@gmail.com>
pkgname=pacman-parallelizer
pkgver=8
pkgrel=2
pkgdesc="A minimal package downloader for pacman, using aria2"
arch=(any)
url="https://github.com/lestofante/PacmanParallelizer"
urlgit="https://github.com/lestofante/PacmanParallelizer.git"
license=('GPL3')
depends=('aria2' 'pacman-contrib')
source=("$pkgname-$pkgver"::"git+$urlgit#tag=$pkgver")
sha256sums=('SKIP')

build() {
	cd "$srcdir/$pkgname-$pkgver"
	chmod +x ./pp.sh
}

package() {
	cd "$srcdir/$pkgname-$pkgver"
	mkdir -p "$pkgdir/usr/bin"
	cp pp.sh "$pkgdir/usr/bin"
}
```
