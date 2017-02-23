# OpenWrt/LEDE packages from prpl Foundation and its Members
Feed of OpenWrt/LEDE packages from prpl Foundation members

## How to add the prpl Feed to you OpenWrt/LEDE build
TODO

## How to add a package to the prpl Feed
1. Fork this repository
2. Add a directory for the package in the root of your forked prpl Feed repo.

 A few things to remember:
 * Make sure to include all of the dependencies in your package's `Makefile`
 * List the [SPDX license tag](https://spdx.org/licenses/) in your package's `Makefile` by setting the `PKG_LICENSE` using the `:=` operator.

3. Consider creating and submitting pull requests to [Boardfarm](https://github.com/qca/boardfarm) so your package can be tested on real hardware.
4. Submit a pull request to submit your package for consideration for review.
5. Your package is added to the feed.
