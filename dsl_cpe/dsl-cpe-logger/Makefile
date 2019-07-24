#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-cpe-logger
PKG_VERSION:=0.2.0
PKG_MD5SUM:=7c313e5028b2bdc22aed84e5e3f65e62
PKG_RELEASE:=1
PKG_BASE_NAME:=dsl_cpe_logger
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost

DSL_BIN_DIR=/$(VENDOR_PATH)/bin

#PKG_FIXUP:=libtool
PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

-include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

# Get config values from general image config or other packages in dependency list
# Definition of these values will be overtaken from package 'dsl-cpe-mei-vrx'
DSL_MAX_DEVICE=$(strip $(subst ",, $(CONFIG_VRX_MAX_DEVICE)))
DSL_LINES_PER_DEVICE=$(strip $(subst ",, $(CONFIG_VRX_LINES_PER_DEVICE)))
DSL_CHANNELS_PER_LINE=$(strip $(subst ",, $(CONFIG_VRX_CHANNELS_PER_LINE)))
DSL_NETLINK_ID=$(strip $(subst ",, $(CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID)))

DSL_TOTAL_ENTITIES:=$(shell echo $$[$(DSL_MAX_DEVICE)*$(DSL_LINES_PER_DEVICE)])

# Set default config values if necessary (not defined before)
ifeq ($(DSL_MAX_DEVICE),)
	DSL_MAX_DEVICE=1
endif

ifeq ($(DSL_LINES_PER_DEVICE),)
	DSL_LINES_PER_DEVICE=1
endif

ifeq ($(DSL_CHANNELS_PER_LINE),)
	DSL_CHANNELS_PER_LINE=1
endif

ifeq ($(DSL_NETLINK_ID),)
	DSL_NETLINK_ID=28
endif

define Package/$(PKG_NAME)
	SECTION:=application
	CATEGORY:=Lantiq
	SUBMENU:=DSL Subsystem
	TITLE:=DSL CPE Debug Logger Application
	URL:=http://www.lantiq.com/
	MAINTAINER:=Lantiq Beteiligungs-GmbH & Co. KG
	DEPENDS:=+libnl +librt +dsl-cpe-mei-vrx
	MENU:=1
endef

define Package/$(PKG_NAME)/description
	This package contains the DSL CPE Debug Logger Application.
endef

#define Package/$(PKG_NAME)/config
#	$(call Package/$(PKG_NAME)/override_version)
#	$(call Package/$(PKG_NAME)/override_source_path)
#	source "$(SOURCE)/Config.in"
#endef

CONFIGURE_ARGS += \
	--with-max-device="$(DSL_MAX_DEVICE)" \
	--with-lines-per-device="$(DSL_LINES_PER_DEVICE)" \
	--with-channels-per-line="$(DSL_CHANNELS_PER_LINE)"

ifdef CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID
CONFIGURE_ARGS += \
	--with-dbg-netlink-id="$(DSL_NETLINK_ID)"
endif

define Build/Configure
	# remove "configured" stamps of other configs
	@- rm $(PKG_BUILD_DIR)/.configured*
	$(call Build/Configure/Default)
endef

define Build/Clean
	@- rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(DSL_BIN_DIR)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dsl_cpe_logger $(1)/$(DSL_BIN_DIR)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
