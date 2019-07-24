#
# Copyright (C) 2014 OpenWrt.org
# Copyright (C) 2014 lantiq.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uthash
PKG_VERSION:=1.9.7
PKG_RELEASE:=1
PKG_SOURCE:=uthash-$(PKG_VERSION).zip
PKG_RELEASE:=1
PKG_SOURCE_URL:=@SF/uthash
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_UNPACK=unzip -d $(PKG_BUILD_DIR)/ $(DL_DIR)/$(PKG_SOURCE)

include $(INCLUDE_DIR)/package.mk

define Package/uthash
  SECTION:=lib
  CATEGORY:=Libraries
  TITLE:=uthash
  URL:=http://uthash.sourceforge.net/
endef

define Package/uthash/description
 This package contains the uthash library
endef

define Build/Configure

endef

define Build/Compile

endef

define Build/Clean

endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/*.h $(1)/usr/include/
endef

define Package/uthash/install

endef

$(eval $(call BuildPackage,uthash))
