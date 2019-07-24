#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=lib-ezbox
PKG_RELEASE:=1
PKG_BASE_NAME:=lib_ezbox
PKG_VERSION:=0.0.1

PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost

PKG_BIN_DIR=/opt/lantiq/bin
PKG_BUILD_DEPENDS:=ifxos lib-cli

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=driver
  CATEGORY:=Lantiq
  TITLE:= Easybox Library
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq Deutschland GmbH
  DEPENDS:=
  MENU:=1
  SUBMENU:=Toolbox
endef

define Package/$(PKG_NAME)/description
   Easybox library.
endef

define Package/$(PKG_NAME)/config
   $(call Package/$(PKG_NAME)/override_version)
   $(call Package/$(PKG_NAME)/override_source_path)
endef

ifeq ($(QUIET),1)
MAKE_FLAGS+=-s
endif

CONFIGURE_ARGS += \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-cli-include="-I$(STAGING_DIR)/usr/include/cli"

define Build/Clean
	@- rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/ezbox}
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/ezbox/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libezbox.* $(1)/usr/lib/
endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/ezbox
	- rm -f $(1)/usr/lib/libezbox.*
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
