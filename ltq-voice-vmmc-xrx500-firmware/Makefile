include $(TOPDIR)/rules.mk

PKG_NAME:=ltq-voice-vmmc-xrx500-firmware
PKG_VERSION:=1.2.10.10.0
PKG_MD5SUM:=21eb3e7155bdcd2dfaa18a5479fdea31
PKG_BASE_NAME:=fw_voip_xrx500
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_UNPACK:=gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
PKG_SOURCE_URL:=http://localhost
PKG_TARGET_BASE_NAME:=xrx500_firmware.bin

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=firmware
  CATEGORY:=Intel
  SUBMENU:=Voice Subsystem
  TITLE:=xRX500 family voice firmware
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  DEPENDS:=ltq-voice-tapi
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	xRX500 voice firmware.
endef

Build/Configure=
Build/Compile=

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)//lib/firmware
	$(INSTALL_DIR) $(1)//voice
	$(CP) $(PKG_BUILD_DIR)/fw*.bin $(1)//voice/$(PKG_BASE_NAME)-$(PKG_VERSION).bin
	ln -snf /voice/$(PKG_BASE_NAME)-$(PKG_VERSION).bin $(1)//lib/firmware/$(PKG_TARGET_BASE_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
