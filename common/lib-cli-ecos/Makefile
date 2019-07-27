include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=lib-cli-ecos
PKG_RELEASE:=1
PKG_BASE_NAME:=lib_cli
PKG_VERSION:=2.8.0
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/lib-cli-ecos/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DEPENDS:=ifxos-ecos
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/lib-cli-ecos
  SECTION:=driver
  CATEGORY:=Intel
  TITLE:= CLI Library (eCos)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel Deutschland GmbH
  DEPENDS:=+ifxos-ecos
  MENU:=1
  SUBMENU:=CLI
endef

define Package/lib-cli-ecos/description
 The common command line interface (CLI) library.
endef

MAKE_FLAGS += -s

CONFIGURE_ARGS += \
	--enable-ecos \
	--enable-kernelincl="$(STAGING_DIR)/usr/include/ecos" \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib" \
	--enable-error-print \
	--enable-debug-print \
	--enable-cli-file-pout \
	--enable-cli-console \
	--enable-build-example=no

TARGET_CFLAGS += -g -ggdb

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include}
	$(CP) $(PKG_INSTALL_DIR)/include/cli $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcli.a $(1)/usr/lib/libcli-ecos.a
endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/cli
	- rm -f $(1)/usr/lib/libcli.*
endef

$(eval $(call BuildPackage,lib-cli-ecos))
