#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: $

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-vr11-firmware-xdsl
PKG_VERSION:=08.0C.01.07.01.07_08.0C.01.01.01.01
PKG_MD5SUM:=f294ab54fb65a437e49d063456aa8ff0
PKG_BASE_NAME:=dsl_vr11_firmware_xdsl
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_UNPACK:=gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
PKG_SOURCE_URL:=http://localhost
PKG_TARGET_BASE_NAME:=xcpe_hw.bin

PKG_CONFIG_DEPENDS:=CONFIG_UBOOT_CONFIG_FIRMWARE_IN_ROOTFS \
	CONFIG_dsl-vr11-firmware-xdsl_FW_IN_ROOTFS

FIRMWARE_DIR:=/lib/firmware
FW_IN_ROOTFS:=1

-include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=firmware
	CATEGORY:=Intel
	SUBMENU:=DSL Subsystem
	TITLE:=VR11 CPE xDSL firmware
	URL:=http://www.intel.com/
	MAINTAINER:=Intel Corporation
	DEPENDS:=dsl-cpe-mei-vrx
	MENU:=1
endef

define Package/$(PKG_NAME)/description
	VRX500 CPE xDSL firmware
endef

define Package/$(PKG_NAME)/config
source "$(SOURCE)/Config.in"
endef

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

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(FIRMWARE_DIR)

ifneq ($(CONFIG_UBOOT_CONFIG_FIRMWARE_IN_ROOTFS)$(CONFIG_TARGET_x86_puma)$(CONFIG_dsl-vr11-firmware-xdsl_FW_IN_ROOTFS),)
	echo "########### FW in rootfs !!!!!!!!!!!!!! ###########"
	$(CP) $(PKG_BUILD_DIR)/*.bin $(1)/$(FIRMWARE_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION).bin
	$(CP) $(PKG_BUILD_DIR)/LICENSE $(1)/$(FIRMWARE_DIR)
	ln -sf $(PKG_BASE_NAME)-$(PKG_VERSION).bin $(1)/$(FIRMWARE_DIR)/$(PKG_TARGET_BASE_NAME)
else
	echo "########### FW NOT in rootfs !!!!!!!!!!!!!! ###########"
	rm -rf $(STAGING_DIR)/firmware/; mkdir -p $(STAGING_DIR)/firmware/
	$(CP) $(PKG_BUILD_DIR)/*.bin $(STAGING_DIR)/firmware/$(PKG_BASE_NAME)-$(PKG_VERSION).bin
	$(CP) $(PKG_BUILD_DIR)/LICENSE $(STAGING_DIR)/firmware/
	ln -sf $(PKG_BASE_NAME)-$(PKG_VERSION).bin $(STAGING_DIR)/firmware/$(PKG_TARGET_BASE_NAME)
endif
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

