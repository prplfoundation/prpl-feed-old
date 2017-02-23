# OpenWrt/LEDE packages from prpl Foundation and its Members
Feed of OpenWrt/LEDE packages from prpl Foundation members

## How to add the prpl Feed to you OpenWrt/LEDE build
At the root of your OpenWrt/LEDE tree, add the following to your `feeds.conf` file:
```sh
src-git prpl https://github.com/prplfoundation/prpl-feed.git
```
Now to add the packages on your prpl feed to your OpenWrt/LEDE instance:
```sh
./scripts/feeds update prpl #retrieve the prpl feed from service/update to latest
./scripts/feeds install -p prpl #make all of the prpl feed packages available to the build
```

For more control over the package versions being installed, you can fork the feed using Github (and replace the `src-git` url) or maintaining a copy of the feed on your local system by using this line instead:
```sh
src-link prpl /full/path/to/feed/root
```

## How to add a package to the prpl Feed
1. Fork this repository
2. Add a directory for the package in the root of your forked prpl Feed repo.

 A few things to remember:
 * Make sure to include all of the dependencies in your package's `Makefile`
 * List the [SPDX license tag](https://spdx.org/licenses/) in your package's `Makefile` by setting the `PKG_LICENSE` using the `:=` operator.
3. Consider creating and submitting pull requests to [Boardfarm](https://github.com/qca/boardfarm) so your package can be tested on real hardware.
4. Submit a pull request to submit your package for consideration for review.
5. Your package is added to the feed.
