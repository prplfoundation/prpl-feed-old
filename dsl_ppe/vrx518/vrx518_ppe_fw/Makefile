include $(TOPDIR)/rules.mk

PKG_NAME:=vrx518_ppe_fw
PKG_VERSION:=1.3.7
PKG_MD5SUM:=fc89a7f58334b402212289b705665671
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://mts-chd.intel.com/~wlnsw/dist/

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/package-version-override.mk

define Package/$(PKG_NAME)
  SECTION:=firmware  
  SUBMENU:=Intel
  TITLE:=VRX518 PPE firmware
  URL:=http://www.intel.com
  MAINTAINER:=Intel
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	VRX518 PPE firmware
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/lib/firmware

ifeq ($(CONFIG_TARGET_lantiq_xrx330),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx330/ppe_fw.bin $(1)/lib/firmware/
endif
ifeq ($(CONFIG_TARGET_lantiq_xrx500),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx500/ppe_fw.bin $(1)/lib/firmware/
endif
ifeq ($(CONFIG_TARGET_intel_mips_xrx500),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx500/ppe_fw.bin $(1)/lib/firmware/
endif
ifeq ($(CONFIG_TARGET_x86_puma),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx750/ppe_fw.bin $(1)/lib/firmware/
endif
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
