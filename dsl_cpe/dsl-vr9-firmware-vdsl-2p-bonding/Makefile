include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-vr9-firmware-vdsl-2p-bonding
PKG_VERSION:=05.05.01.0D.01.06
PKG_MD5SUM:=5bac9bbb8f5f319a4d36e70be321f6c7
PKG_BASE_NAME:=dsl_vr9_firmware_vdsl
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_UNPACK:=gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
PKG_SOURCE_URL:=http://localhost
PKG_TARGET_BASE_NAME:=xcpe_hw_2p.bin

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=firmware
	CATEGORY:=Intel
	SUBMENU:=DSL Subsystem
	TITLE:=VR9 CPE VDSL ON-chip bonding firmware
	URL:=http://www.lantiq.com/
	MAINTAINER:=Intel Beteiligungs-GmbH & Co. KG
	DEPENDS:=+dsl-cpe-mei-vrx
	MENU:=1
endef

define Package/$(PKG_NAME)/description
	VRX200 CPE xDSL ON-chip bonding firmware
endef

Build/Configure=
Build/Compile=

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(/opt/lantiq/firmware)
	$(CP) $(PKG_BUILD_DIR)/*.bin $(1)/$(/opt/lantiq/firmware)/$(PKG_BASE_NAME)-$(PKG_VERSION).bin;
	$(CP) $(PKG_BUILD_DIR)/LICENSE $(1)/$(/opt/lantiq/firmware)/;
	ln -sf $(PKG_BASE_NAME)-$(PKG_VERSION).bin $(1)/$(/opt/lantiq/firmware)/$(PKG_TARGET_BASE_NAME);
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

