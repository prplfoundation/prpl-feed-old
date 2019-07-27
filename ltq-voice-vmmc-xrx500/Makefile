include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ltq-voice-vmmc-xrx500
PKG_VERSION:=1.24.0.0
PKG_HASH:=6e47387545d96fd792b9424bafcb6ca1f56114a853f619ac5509edff5233d30a
PKG_RELEASE:=1
PKG_SOURCE:=drv_vmmc_xrx500-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/drv_vmmc_xrx500-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=ifxos ltq-voice-tapi PACKAGE_ltq-evtlog:ltq-evtlog

PKG_CONFIG_DEPENDS:=\
	$(foreach _mr,$(shell grep -w config config/Config.in|awk '{ print $$2 }'),CONFIG_$(_mr))

include $(INCLUDE_DIR)/package.mk

define Package/ltq-voice-vmmc-xrx500
  SUBMENU:=Voice Subsystem
  TITLE:=TAPI LL driver for Voice Macro on xRX500
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  DEPENDS:=+ltq-voice-tapi +kmod-ifxos
  MENU:=1
endef

define Package/ltq-voice-vmmc-xrx500/description
	Voice Subsystem Low Level Driver for XWAY(TM) xRX500 family devices
endef

define Package/ltq-voice-vmmc-xrx500/config
	source "$(SOURCE)/config/Config.in"
endef

ifneq ($(CONFIG_LTQ_VOICE_VMMC_USER_FLAGS),"")
VMMC_CFLAGS=$(strip $(subst ",, $(CONFIG_LTQ_VOICE_VMMC_USER_FLAGS)))
endif

ifneq ($(CONFIG_LTQ_VOICE_VMMC_USER_OPTIONS),"")
CONFIGURE_ARGS += $(subst ",, $(CONFIG_LTQ_VOICE_VMMC_USER_OPTIONS))
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_DEBUGGING),y)
CONFIGURE_ARGS += --enable-debug \
                  --enable-warnings
VMMC_CFLAGS += -O0
endif

ifneq ($(VMMC_CFLAGS),"")
CONFIGURE_ARGS += --with-cflags="$(VMMC_CFLAGS)"
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_RTCP_XR),y)
CONFIGURE_ARGS += --enable-rtcp-xr
else
CONFIGURE_ARGS += --disable-rtcp-xr
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_DISABLE_DECT_NIBBLE_SWAP),y)
CONFIGURE_ARGS += --disable-dect-nibble-swap
else
CONFIGURE_ARGS += --enable-dect-nibble-swap
endif

ifneq ($(CONFIG_LTQ_VOICE_VMMC_MPS_HISTORY_SIZE),128)
CONFIGURE_ARGS += --enable-history-buf=$(CONFIG_LTQ_VOICE_VMMC_MPS_HISTORY_SIZE)
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_SSLIC_FXO_ACTIVATE),y)
CONFIGURE_ARGS += --enable-fxo-act
else
CONFIGURE_ARGS += --disable-fxo-act
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_FAX),y)
CONFIGURE_ARGS += --enable-fax --enable-t38
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_CID),y)
CONFIGURE_ARGS += --enable-cid
else
CONFIGURE_ARGS += --disable-cid
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_DECT),y)
CONFIGURE_ARGS += --enable-dect
else
CONFIGURE_ARGS += --disable-dect
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_PCM),y)
CONFIGURE_ARGS += --enable-pcm
else
CONFIGURE_ARGS += --disable-pcm
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_KPI),y)
CONFIGURE_ARGS += --enable-kpi
else
CONFIGURE_ARGS += --disable-kpi
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_LT_GR909),y)
CONFIGURE_ARGS += --enable-lt --enable-calibration
else
CONFIGURE_ARGS += --disable-lt
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_METERING),y)
CONFIGURE_ARGS += --enable-metering
else
CONFIGURE_ARGS += --disable-metering
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_HDLC),y)
CONFIGURE_ARGS += --enable-hdlc
else
CONFIGURE_ARGS += --disable-hdlc
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_TRACES),y)
CONFIGURE_ARGS += --enable-trace
else
CONFIGURE_ARGS += --disable-trace
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_EVENT_LOGGER),y)
CONFIGURE_ARGS += --enable-el-debug --with-el-incl=$(STAGING_DIR)/usr/include/event_logger
else
CONFIGURE_ARGS += --disable-el-debug
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_PHONE_DETECTION),y)
CONFIGURE_ARGS += --enable-phone-detection
else
CONFIGURE_ARGS += --disable-phone-detection
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_CONT_MEASUREMENT),y)
CONFIGURE_ARGS += --enable-cont-measurement
else
CONFIGURE_ARGS += --disable-cont-measurement
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_PMC),y)
CONFIGURE_ARGS += --enable-pmc
  ifeq ($(CONFIG_PACKAGE_kmod-lantiq-cpufreq),y)
  CONFIGURE_ARGS += --enable-pmc-if=cpufreq
  endif
else
CONFIGURE_ARGS += --disable-pmc
CONFIGURE_ARGS += --disable-pmc-if
endif

ifeq ($(CONFIG_LTQ_VOICE_TAPI_SRTP),y)
CONFIGURE_ARGS += --enable-srtp
else
CONFIGURE_ARGS += --disable-srtp
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_FXO),y)
CONFIGURE_ARGS += --enable-fxo
else
CONFIGURE_ARGS += --disable-fxo
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_WITH_SLIC_NONE),y)
CONFIGURE_ARGS += --disable-slic
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_WITH_SLIC100),y)
CONFIGURE_ARGS += --enable-slic
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_WITH_SLIC200),y)
CONFIGURE_ARGS += --enable-slic
CONFIGURE_ARGS += --enable-s220-support
endif

ifeq ($(CONFIG_LTQ_VOICE_VMMC_DISABLE_AUTO_DATA_MAP),y)
CONFIGURE_ARGS += --disable-automatic-datachannel-mapping
else
CONFIGURE_ARGS += --enable-automatic-datachannel-mapping
endif

DRV_TAPI_INCLUDE:=$(STAGING_DIR)/usr/include/drv_tapi

CONFIGURE_ARGS += --with-kernel-incl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --with-tapi-incl="$(DRV_TAPI_INCLUDE)"
CONFIGURE_ARGS += --with-ifxos-incl=$(STAGING_DIR)/usr/include/ifxos

CONFIGURE_ARGS += --enable-linux-26 --with-kernel-build="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
CONFIGURE_ARGS += --enable-linux-platform-driver
PKG_MODULE_EXTENSION=.$(LINUX_KMOD_SUFFIX)

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/.configured*
	$(call Build/Configure/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	mkdir -p $(1)/usr/include/drv_vmmc
	$(CP) -v --dereference $(PKG_BUILD_DIR)/include/* $(1)/usr/include/drv_vmmc
	(cd $(1)/usr/include/drv_vmmc && ln -snf . include)
endef

define Build/UninstallDev
	rm -rf $(BUILD_DIR)/drv_vmmc
endef

define Package/ltq-voice-vmmc-xrx500/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/$(MODULES_SUBDIR)
	$(INSTALL_BIN) ./files/$(PKG_START_SCRIPT) $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/drv_vmmc$(PKG_MODULE_EXTENSION) $(1)/$(MODULES_SUBDIR)
endef

$(eval $(call BuildPackage,ltq-voice-vmmc-xrx500))
