include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-vr10-firmware-xdsl
PKG_VERSION:=07.07.0A.0F.01.06_07.07.05.02.01.01
PKG_MD5SUM:=569fd538d874d7f006ce63440b282210
PKG_BASE_NAME:=dsl_vr10_firmware_xdsl
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_UNPACK:=gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
PKG_SOURCE_URL:=http://localhost
PKG_TARGET_BASE_NAME:=xcpe_hw.bin

FIRMWARE_DIR:=/lib/firmware

include $(INCLUDE_DIR)/package.mk

define Package/dsl-vr10-firmware-xdsl
	SECTION:=firmware
	CATEGORY:=Intel
	SUBMENU:=DSL Subsystem
	TITLE:=VR10 CPE xDSL firmware
	URL:=http://www.lantiq.com/
	MAINTAINER:=Intel Beteiligungs-GmbH & Co. KG
	DEPENDS:=dsl-cpe-mei-vrx
	MENU:=1
endef

define Package/dsl-vr10-firmware-xdsl/description
	VRX300 CPE xDSL firmware
endef

define Build/Configure
	@- rm $(PKG_BUILD_DIR)/.configured*
	$(call Build/Configure/Default)
endef

Build/Compile=

define Package/dsl-vr10-firmware-xdsl/install
	$(INSTALL_DIR) $(1)/$(FIRMWARE_DIR)

ifneq ($(CONFIG_UBOOT_CONFIG_FIRMWARE_IN_ROOTFS)$(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR10_320),)
	$(CP) $(PKG_BUILD_DIR)/*.bin $(1)/$(FIRMWARE_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION).bin
	$(CP) $(PKG_BUILD_DIR)/LICENSE $(1)/$(FIRMWARE_DIR)
	ln -sf $(PKG_BASE_NAME)-$(PKG_VERSION).bin $(1)/$(FIRMWARE_DIR)/$(PKG_TARGET_BASE_NAME)
else
	rm -rf $(STAGING_DIR)/firmware/; mkdir -p $(STAGING_DIR)/firmware/
	$(CP) $(PKG_BUILD_DIR)/*.bin $(STAGING_DIR)/firmware/$(PKG_BASE_NAME)-$(PKG_VERSION).bin
	$(CP) $(PKG_BUILD_DIR)/LICENSE $(STAGING_DIR)/firmware/
	ln -sf $(PKG_BASE_NAME)-$(PKG_VERSION).bin $(STAGING_DIR)/firmware/$(PKG_TARGET_BASE_NAME)
endif
endef

$(eval $(call BuildPackage,dsl-vr10-firmware-xdsl))

