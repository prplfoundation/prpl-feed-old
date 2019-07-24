#
# Copyright (C) 2009-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ifxos-devio
PKG_BASE_NAME:=lib_ifxos
PKG_VERSION:=1.6.9
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_MD5SUM:=2c40d61533696b279cbaa9794bcf3559

PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package-version-override.mk

# re-define PATCH_DIR to get version-specific patches
PATCH_DIR:=./patches-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_PACKAGE_ifxos-devio' $(TOPDIR)/.config | md5s)
endif

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Lantiq
  SUBMENU:=IFXOS
  TITLE:=Lantiq OS abstraction library (devio)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  MENU:=1
  DEPENDS:=+kmod-ifxos
endef

define Package/$(PKG_NAME)/description
 Lantiq IFXOS - compiled for devio interface.
endef

CONFIGURE_ARGS += \
	--without-kernel-module\
	--enable-add_appl_cflags="-DIFXOS_DEBUG_USR_PRINT=0 -DIFXOS_USE_ERROR_USR_PRINT=0 -DIFXOS_USE_DEV_IO=1 -DIFXOS_HAVE_SOCKET=1" \
	--enable-targetincl=$(STAGING_DIR)/usr/include\
	--enable-target=$(STAGING_DIR)/usr/lib

define Build/Clean
	@- rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/ifxos_devio}
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/ifxos_devio
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos_devio.* $(1)/usr/lib/
endef

#	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos.a $(1)/usr/lib/libifxos_devio.a
#	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos.so.0.0.0 $(1)/usr/lib/libifxos_devio.so.0.0.0
#	(cd $(1)/usr/lib/ && ln -snf libifxos_devio.so.0.0.0 libifxos_devio.so)
#	(cd $(1)/usr/lib/ && ln -snf libifxos_devio.so.0.0.0 libifxos_devio.so.0)

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos_devio.* $(1)/usr/lib/
endef

#	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos.so.0.0.0 $(1)/usr/lib/libifxos_devio.so.0.0.0
#	(cd $(1)/usr/lib/ && ln -snf libifxos_devio.so.0.0.0 libifxos_devio.so)
#	(cd $(1)/usr/lib/ && ln -snf libifxos_devio.so.0.0.0 libifxos_devio.so.0)


define Build/UninstallDev
	- rm -f $(1)/usr/lib/libifxos_devio.*
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

