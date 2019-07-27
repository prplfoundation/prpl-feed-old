include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-gfast-drv-pmi
PKG_VERSION:= 0.3.3
PKG_BASE_NAME:=dsl_gfast_drv_pmi
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR=/opt/lantiq/bin
PKG_BUILD_DEPENDS:=ifxos dsl-gfast-drv-pciep
PKG_BUILD_PARALLEL:=1
PATCH_DIR:=./patches-$(PKG_VERSION)
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/dsl-gfast-drv-pmi
  SECTION:=app
  CATEGORY:=Intel
  TITLE:= VRX618 Phy Management Interface (PMI)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+libpthread +kmod-ifxos +dsl-gfast-drv-pciep
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/dsl-gfast-drv-pmi/description
   Phy Management Interface (PMI) Driver for the VRX618 device
endef

define Package/dsl-gfast-drv-pmi/config
	menu "configuration"
	depends on PACKAGE_dsl-gfast-drv-pmi
		source "$(SOURCE)/config/Config.in"
	endmenu
endef

CONFIGURE_ARGS += --enable-linux-kernel
CONFIGURE_ARGS += --enable-kernelbuild="$(LINUX_DIR)"
CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos"
CONFIGURE_ARGS += --enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"
CONFIGURE_ARGS += ARCH=$(LINUX_KARCH)
CONFIGURE_ARGS += \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_DEBUG,debug) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_ERROR_PRINTS,error-print) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_DEBUG_PRINTS,debug-print) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_STATISTICS,statistics) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_ERR_STRINGS,err-string) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_PLATFORM_DRV,platform-drv) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_DRV_BUILTIN_TESTS,builtin-tests)

ifeq ($(CONFIG_DSL_GFAST_DRV_PMI_ALL_STATIC),y)
CONFIGURE_ARGS += --disable-shared
CONFIGURE_ARGS += --enable-all-static
endif

ifeq ($(CONFIG_DSL_GFAST_DRV_PMI_MODE_SIMULATION),y)
CONFIGURE_ARGS += --enable-simulation
CONFIGURE_ARGS += --enable-driver-include="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/pmi -I$(STAGING_DIR)/usr/include/vrx618_sim"
else
CONFIGURE_ARGS += --enable-driver-include="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/pmi  -I$(STAGING_DIR)/usr/include/vrx618"
endif

ifeq ($(CONFIG_DSL_GFAST_DRV_PMI_MODE_EMULATION),y)
CONFIGURE_ARGS += --enable-emulation
endif

define KernelPackage/dsl-gfast-drv-pmi
  SUBMENU:=Intel
  TITLE:=Phy Management Interface (PMI) driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+kmod-ifxos +DSL_GFAST_DRV_PMI_MODE_SIMULATION:kmod-dsl-gfast-drv-pmi-sim
  FILES:=$(PKG_INSTALL_DIR)/usr/bin/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/dsl-gfast-drv-pmi/description
   The driver for VRX618 Phy Management Interface (PMI) application.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include}
	$(INSTALL_DIR) $(1)/usr/include/pmi
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/pmi/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcontrol_pmi.* $(1)/usr/lib/
endef

define Package/dsl-gfast-drv-pmi/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcontrol_pmi.so.* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/control_pmi $(1)/$(PKG_BIN_DIR)
	$(CP) ./files/*.sh $(1)/$(LTQ_BIN_DIR)
endef

$(eval $(call BuildPackage,dsl-gfast-drv-pmi))
$(eval $(call KernelPackage,dsl-gfast-drv-pmi))
