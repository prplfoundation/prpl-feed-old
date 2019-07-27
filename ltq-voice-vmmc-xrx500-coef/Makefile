include $(TOPDIR)/rules.mk

PKG_NAME:=ltq-voice-vmmc-xrx500-coef
PKG_VERSION:=3.0.0
PKG_MD5SUM:=f47c46ce439b7a3c9747b452c23647fa
PKG_BASE_NAME:=coef_voip_xrx500
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_UNPACK:=gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
PKG_SOURCE_URL:=http://localhost

VOICE_TARGET_FILENAME_FXS_DEDICATED:=xrx500_bbd_fxs.bin
VOICE_TARGET_FILENAME_FXS_COMBINED:=xrx500_bbd_cmb_fxs.bin
VOICE_TARGET_FILENAME_FXO:=xrx500_bbd_fxo.bin

FIRMWARE_DIR=/lib/firmware
BBD_DIR=$(FIRMWARE_DIR)/voice

include $(INCLUDE_DIR)/package.mk

define Package/ltq-voice-vmmc-xrx500-coef
  SECTION:=firmware
  CATEGORY:=Intel
  SUBMENU:=Voice Subsystem
  TITLE:=xRX500 family voice coefficient samples
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  DEPENDS:=ltq-voice-tapi
  MENU:=1
endef

define Package/ltq-voice-vmmc-xrx500-coef/description
	xRX500 voice coefficient samples suitable for the reference schematic.
	Coefficients for different schematics can be calculated with XTCOS.
endef

define Package/ltq-voice-vmmc-xrx500-coef/config
	source "$(SOURCE)/config/Config.in"
endef

ifeq ($(CONFIG_LTQ_VOICE_VMMC_COEF_XRX500_ETSI),y)
	FXS_SRC_FILENAME:=xrx500_bbd_etsi_3_10.bin
	FXO_SRC_FILENAME:=xrx500_bbd_etsi_3_10.bin
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_COEF_XRX500_US600R),y)
	FXS_SRC_FILENAME:=xrx500_bbd_r600_3_10.bin
	FXO_SRC_FILENAME:=xrx500_bbd_r600_3_10.bin
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_COEF_XRX500_GERMANY),y)
	FXS_SRC_FILENAME:=xrx500_bbd_ger_3_10.bin
	FXO_SRC_FILENAME:=xrx500_bbd_ger_3_10.bin
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_COEF_XRX500_USE_CUSTOM_FILE),y)
	FXS_SRC_FILENAME:=xrx500_bbd_CUSTOM_FXS.BIN
	FXO_SRC_FILENAME:=xrx500_bbd_CUSTOM_FXO.BIN
endif

Build/Configure=
Build/Compile=

define Package/ltq-voice-vmmc-xrx500-coef/install
	$(INSTALL_DIR) $(1)/$(FIRMWARE_DIR)
	$(INSTALL_DIR) $(1)/$(BBD_DIR)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/xrx500_bbd*.bin  $(1)$(BBD_DIR)/
	- $(INSTALL_DATA) $(CONFIG_LTQ_VOICE_VMMC_COEF_XRX500_CUSTOM_FILE_FXS) $(1)$(BBD_DIR)/$(FXS_SRC_FILENAME)
	- $(INSTALL_DATA) $(CONFIG_LTQ_VOICE_VMMC_COEF_XRX500_CUSTOM_FILE_FXO) $(1)$(BBD_DIR)/$(FXO_SRC_FILENAME)
	ln -snf $(BBD_DIR)/$(FXS_SRC_FILENAME) $(1)$(FIRMWARE_DIR)/$(VOICE_TARGET_FILENAME_FXS_DEDICATED)
	ln -snf $(BBD_DIR)/$(FXS_SRC_FILENAME) $(1)$(FIRMWARE_DIR)/$(VOICE_TARGET_FILENAME_FXS_COMBINED)
	- ln -snf $(BBD_DIR)/$(FXO_SRC_FILENAME)  $(1)$(FIRMWARE_DIR)/$(VOICE_TARGET_FILENAME_FXO)
endef

$(eval $(call BuildPackage,ltq-voice-vmmc-xrx500-coef))
