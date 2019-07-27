include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ltq-voice-kpi2udp
PKG_VERSION:=3.1.0.0
PKG_MD5SUM:=e69fa082140bcfd075e6e9451141dbd4
PKG_RELEASE:=1
PKG_SOURCE:=drv_kpi2udp-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/drv_kpi2udp-$(PKG_VERSION)
PKG_START_SCRIPT:=load_voice_kpi2udp.sh
PKG_BUILD_DEPENDS:=ltq-voice-tapi ifxos

PKG_CONFIG_DEPENDS:=\
       $(foreach _mr,$(shell grep -w config config/Config.in|awk '{ print $$2 }'),CONFIG_$(_mr)) \

include $(INCLUDE_DIR)/package.mk

define Package/ltq-voice-kpi2udp
  SECTION:=driver
  CATEGORY:=Intel
  SUBMENU:=Voice Subsystem
  TITLE:=TAPI KPI2UDP driver
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  MENU:=1
  DEPENDS:=ltq-voice-tapi +kmod-ifxos +kmod-voice-tapi-kpi2udp
endef

define Package/ltq-voice-kpi2udp/description
	RTP packet path acceleration into IP stack (strongly recommended)
endef

define Package/ltq-voice-kpi2udp/config
$(call Package/ltq-voice-kpi2udp/override_version)
$(call Package/ltq-voice-kpi2udp/override_source_path)
#	menu "configuration"
#		depends on PACKAGE_ltq-voice-kpi2udp
#		source "$(SOURCE)/config/Config.in"
#	endmenu
	source "$(SOURCE)/config/Config.in"
endef

ifneq ($(CONFIG_LTQ_VOICE_KPI2UDP_USER_FLAGS),"")
KPI2UDP_USER_CFLAGS=$(strip $(subst ",, $(CONFIG_LTQ_VOICE_KPI2UDP_USER_FLAGS)))
CONFIGURE_ARGS += --with-cflags="$(KPI2UDP_USER_CFLAGS)"
endif

ifneq ($(CONFIG_LTQ_VOICE_KPI2UDP_USER_OPTIONS),"")
CONFIGURE_ARGS += $(subst ",, $(CONFIG_LTQ_VOICE_KPI2UDP_USER_OPTIONS))
endif

DRV_TAPI_INCLUDE:=$(STAGING_DIR)/usr/include/drv_tapi
CONFIGURE_ARGS += --with-kernel-incl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --with-tapi-incl="$(DRV_TAPI_INCLUDE)"
CONFIGURE_ARGS += --with-ifxos-incl=$(STAGING_DIR)/usr/include/ifxos
CONFIGURE_ARGS += --enable-warnings
CONFIGURE_ARGS += --enable-linux-26 --with-kernel-build="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION=.$(LINUX_KMOD_SUFFIX)

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/.configured*
	(cd $(PKG_BUILD_DIR); aclocal -I m4 && autoconf && automake)
	$(call Build/Configure/Default)
endef

ifneq ($(CONFIG_TARGET_intel_mips_falcon)$(CONFIG_TARGET_lantiq_falcon),y)
define Package/ltq-voice-kpi2udp/install
	# Startup script
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/$(PKG_START_SCRIPT) $(1)/etc/init.d/
	# Primary install location of the driver binary
	$(INSTALL_DIR) $(1)/$(MODULES_SUBDIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/drv_kpi2udp$(PKG_MODULE_EXTENSION) $(1)/$(MODULES_SUBDIR)
endef
endif

$(eval $(call BuildPackage,ltq-voice-kpi2udp))

define KernelPackage/voice-tapi-kpi2udp
  SUBMENU:=Voice over IP
  TITLE:=TAPI KPI2UDP driver
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  DEPENDS:=+kmod-ltq-tapi @(TARGET_intel_mips||TARGET_lantiq)
  FILES:=$(PKG_BUILD_DIR)/drv_kpi2udp$(PKG_MODULE_EXTENSION)
  AUTOLOAD:=$(call AutoLoad,26,drv_kpi2udp)
  KCONFIG:=CONFIG_UDP_REDIRECT=y
endef

define KernelPackage/voice-tapi-kpi2udp/description
	RTP packet path acceleration into IP stack (strongly recommended)
endef

$(eval $(call KernelPackage,voice-tapi-kpi2udp))
