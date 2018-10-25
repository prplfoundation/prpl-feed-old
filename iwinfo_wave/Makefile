#
# Copyright (C) 2010-2015 Jo-Philipp Wich <jow@openwrt.org>
#
# This is free software, licensed under the GPL 2 license.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libiwinfo_wave
PKG_VERSION:=2015-06-01
PKG_RELEASE=1
#PKG_RELEASE=$(PKG_SOURCE_VERSION)

#PKG_SOURCE_PROTO:=git
#PKG_SOURCE_URL:=http://git.openwrt.org/project/iwinfo.git
#PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
#PKG_SOURCE_VERSION:=ade8b1b299cbd5748db1acf80dd3e9f567938371
#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_MAINTAINER:=Jo-Philipp Wich <jow@openwrt.org>
PKG_LICENSE:=GPL-2.0

PKG_CONFIG_DEPENDS := \
	CONFIG_PACKAGE_kmod-cfg80211

include $(INCLUDE_DIR)/package.mk

define Package/libiwinfo_wave
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Generalized Wireless Information Library (iwinfo_wave)
  DEPENDS:=+PACKAGE_kmod-cfg80211:libnl-tiny +libuci +PACKAGE_kmod-lantiq-wlan-wave-support_5_x:libnl-tiny
  ABI_VERSION:=$(PKG_RELEASE)
endef

define Package/libiwinfo_wave/description
  Wireless information library with consistent interface for proprietary Broadcom,
  madwifi, nl80211 and wext driver interfaces.
endef


define Package/libiwinfo_wave-lua
  SUBMENU:=Lua
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=libiwinfo_wave Lua binding
  DEPENDS:=+libiwinfo_wave +liblua
endef

define Package/libiwinfo_wave-lua/description
  This is the Lua binding for the iwinfo_wave library. It provides access to all enabled
  backends.
endef


define Package/iwinfo_wave
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Generalized Wireless Information utility
  DEPENDS:=+libiwinfo_wave
endef

define Package/iwinfo_wave/description
  Command line frontend for the wireless information library.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

IWINFO_BACKENDS := \
	$(if $(CONFIG_PACKAGE_kmod-cfg80211),nl80211) \
	$(if $(CONFIG_PACKAGE_kmod-lantiq-wlan-wave-support_5_x),intelwifi)

TARGET_CFLAGS += \
	-I$(STAGING_DIR)/usr/include/libnl-tiny \
	-I$(STAGING_DIR)/usr/include \
	-D_GNU_SOURCE

MAKE_FLAGS += \
	FPIC="$(FPIC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	BACKENDS="$(IWINFO_BACKENDS)"

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/iwinfo
	$(CP) $(PKG_BUILD_DIR)/include/iwinfo.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/include/iwinfo/* $(1)/usr/include/iwinfo/
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libiwinfo.so $(1)/usr/lib/libiwinfo.so
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/iwinfo.so $(1)/usr/lib/lua/iwinfo.so
endef

define Package/libiwinfo_wave/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libiwinfo.so $(1)/usr/lib/libiwinfo.so
	$(INSTALL_DIR) $(1)/usr/share/libiwinfo
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/hardware.txt $(1)/usr/share/libiwinfo/hardware.txt
endef

define Package/libiwinfo_wave-lua/install
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/iwinfo.so $(1)/usr/lib/lua/iwinfo.so
endef

define Package/iwinfo_wave/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/iwinfo $(1)/usr/bin/iwinfo
endef

$(eval $(call BuildPackage,libiwinfo_wave))
$(eval $(call BuildPackage,libiwinfo_wave-lua))
$(eval $(call BuildPackage,iwinfo_wave))
