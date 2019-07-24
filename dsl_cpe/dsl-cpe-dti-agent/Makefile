#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-cpe-dti-agent
PKG_VERSION:=0.0.3
PKG_MD5SUM:=37227953c5d40fe4ef6a3f6f232dad6d
PKG_BASE_NAME:=dsl_cpe_dti_agent
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost

DSL_BIN_DIR=/$(VENDOR_PATH)/bin

PKG_FIXUP:=libtool
PKG_INSTALL:=1

-include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

# Get config values from general image config or other packages in dependency list
# Definition of these values will be overtaken from package 'dsl-cpe-mei-vrx'
DSL_MAX_DEVICE=$(strip $(subst ",, $(CONFIG_VRX_MAX_DEVICE)))
DSL_LINES_PER_DEVICE=$(strip $(subst ",, $(CONFIG_VRX_LINES_PER_DEVICE)))
DSL_CHANNELS_PER_LINE=$(strip $(subst ",, $(CONFIG_VRX_CHANNELS_PER_LINE)))

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

define Package/$(PKG_NAME)
	SECTION:=application
	CATEGORY:=Lantiq
	SUBMENU:=DSL Subsystem
	TITLE:=DSL CPE DTI agent
	URL:=http://www.lantiq.com/
	MAINTAINER:=Lantiq Beteiligungs-GmbH & Co. KG
	DEPENDS:=+ifxos +dsl-cpe-mei-vrx +librt +lib-dti   
	MENU:=1
endef

define Package/$(PKG_NAME)/description
	This package contains the DSL CPE DTI agent.
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

CONFIGURE_ARGS += \
	--enable-vrx \
	--enable-driver-include="-I$(STAGING_DIR)/usr/include" \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib" \
	--enable-dti=yes \
	--enable-dti-include="-I$(STAGING_DIR)/usr/include/dti" \
	--enable-dti-library="-L$(STAGING_DIR)/usr/lib"   


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
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dsl_cpe_dti_agent $(1)/$(DSL_BIN_DIR)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
