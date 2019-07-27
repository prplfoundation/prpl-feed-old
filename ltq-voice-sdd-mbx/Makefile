include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ltq-voice-sdd-mbx
PKG_VERSION:=1.4.0.0
PKG_MD5SUM:=e85a7a9f7ef51c5fc9b5f21bc967c0bf
PKG_RELEASE:=1
PKG_BASE_NAME:=drv_sdd_mbx
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DIR:=$(BUILD_DIR)/ltq-voice-sdd-mbx/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_CAT:=zcat
PKG_BUILD_DEPENDS:=ifxos PACKAGE_ltq-evtlog:ltq-evtlog
PKG_CONFIG_DEPENDS:=$(foreach _mr,$(shell grep -w config config/Config.in|awk '{ print $$2 }'),CONFIG_$(_mr))

include $(INCLUDE_DIR)/package.mk

define Package/ltq-voice-sdd-mbx
  SECTION:=driver
  CATEGORY:=Intel
  SUBMENU:=Voice Subsystem
  TITLE:=TAPI driver for VCODEC
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  MENU:=1
  DEPENDS:=ltq-voice-tapi +kmod-ifxos +kmod-voice-tapi-sdd-mbx
endef

define Package/ltq-voice-sdd-mbx/description
	TAPI Low Level Driver for SDD mailbox handling
endef

define Package/ltq-voice-sdd-mbx/config
	source "$(SOURCE)/config/Config.in"
endef

ifneq ($(CONFIG_LTQ_VOICE_SDD_MBX_USER_FLAGS),"")
SDD_MBX_USER_CFLAGS=$(strip $(subst ",, $(LTQ_VOICE_SDD_MBX_USER_FLAGS)))
endif

ifneq ($(CONFIG_LTQ_VOICE_SDD_MBX_USER_OPTIONS),"")
CONFIGURE_ARGS += $(subst ",, $(CONFIG_LTQ_VOICE_SDD_MBX_USER_OPTIONS))
endif

ifeq ($(CONFIG_LTQ_VOICE_SDD_MBX_DEBUGGING),y)
CONFIGURE_ARGS += --enable-debug \
                  --enable-warnings
SDD_MBX_USER_CFLAGS += -O0
endif

ifneq ($(SDD_MBX_USER_CFLAGS),"")
CONFIGURE_ARGS += --with-cflags="$(SDD_MBX_USER_CFLAGS)"
endif

CONFIGURE_ARGS += --enable-proc

CONFIGURE_ARGS += $(call autoconf_bool,CONFIG_LTQ_VOICE_TAPI_TRACES,trace)

ifeq ($(CONFIG_LTQ_VOICE_SDD_MBX_EVENT_LOGGER),y)
CONFIGURE_ARGS += \
	--enable-el_debug \
	--with-el-incl=$(STAGING_DIR)/usr/include/event_logger
endif

CONFIGURE_ARGS += --with-kernel-incl="$(LINUX_DIR)/include" --with-ifxos-incl=$(STAGING_DIR)/usr/include/ifxos

CONFIGURE_ARGS += \
	--enable-linux-26 \
	--with-kernel-build="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION=.$(LINUX_KMOD_SUFFIX)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/drv_sdd_mbx}
	$(CP) -L $(PKG_BUILD_DIR)/include/* $(1)/usr/include/drv_sdd_mbx
endef

define Build/UninstallDev
	rm -rf $(1)/usr/include/drv_sdd_mbx
endef

define Package/ltq-voice-sdd-mbx/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/load_sdd_mbx.sh $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/$(MODULES_SUBDIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/drv_sdd_mbx$(PKG_MODULE_EXTENSION) $(1)/$(MODULES_SUBDIR)
endef

define KernelPackage/voice-tapi-sdd-mbx
  SUBMENU:=Voice over IP
  TITLE:=TAPI driver for VCODEC
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  DEPENDS:=+kmod-ltq-tapi
  FILES:=$(PKG_BUILD_DIR)/src/drv_sdd_mbx$(PKG_MODULE_EXTENSION)
  AUTOLOAD:=$(call AutoLoad,21,drv_sdd_mbx)
  KCONFIG:= \
	CONFIG_SPI=y \
	CONFIG_SPI_GRX500=y \
	CONFIG_SPI_MASTER=y
endef

define KernelPackage/voice-tapi-sdd-mbx/description
	Voice Subsystem Driver for VCODEC
endef

$(eval $(call BuildPackage,ltq-voice-sdd-mbx))
$(eval $(call KernelPackage,voice-tapi-sdd-mbx))
