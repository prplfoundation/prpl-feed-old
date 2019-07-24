#
# Copyright (C) 2011 OpenWrt.org
# Copyright (C) 2011 lantiq.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dsl-vrx618-firmware
PKG_VERSION:=V12.1.1.1.0.x
PKG_TARGET_BASE_NAME:=xcpe_fw.bin
PKG_BASE_NAME:=dsl_vrx618_firmware
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_UNPACK:=gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
PKG_RELEASE:=1

PKG_SOURCE_URL:=http://localhost
FIRMWARE_DIR=lib/firmware/09AA/

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=Lantiq
  SUBMENU:=DSL Subsystem
  TITLE:=G.FAST CPE VRX618 firmware
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq Beteiligungs-GmbH & Co.KG
  MENU:=1
  SECTION:=firmware
  DEPENDS:=+kmod-dsl-gfast-drv-pmi
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(FIRMWARE_DIR)
	$(CP) $(PKG_BUILD_DIR)/$(PKG_TARGET_BASE_NAME) $(1)/$(FIRMWARE_DIR)
	$(CP) $(PKG_BUILD_DIR)/LICENSE $(1)/$(FIRMWARE_DIR)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
