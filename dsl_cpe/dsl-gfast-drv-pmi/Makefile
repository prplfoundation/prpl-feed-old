#
# Copyright (C) 2014 OpenWrt.org
# Copyright (C) 2014 lantiq.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

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

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_VRX618_PMI_' $(TOPDIR)/.config | md5s)
endif

define Package/$(PKG_NAME)
  SECTION:=app
  CATEGORY:=Lantiq
  TITLE:= VRX618 Phy Management Interface (PMI)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+libpthread \
	+kmod-ifxos \
	+dsl-gfast-drv-pciep
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/$(PKG_NAME)/description
   Phy Management Interface (PMI) Driver for the VRX618 device
endef

define Package/$(PKG_NAME)/config
	menu "configuration"
	depends on PACKAGE_$(PKG_NAME)
		source "$(SOURCE)/config/Config.in"
	endmenu
   $(call Package/$(PKG_NAME)/override_version)
   $(call Package/$(PKG_NAME)/override_source_path)
endef

# make the submake silent:
# ifeq ($(QUIET),1)
# MAKE_FLAGS+=-s
# endif
# ifneq (,$(findstring 99,$(V)))
# MAKE_FLAGS+=-s
# endif


CONFIGURE_ARGS += --enable-linux-kernel
CONFIGURE_ARGS += --enable-kernelbuild="$(LINUX_DIR)"
CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos"
CONFIGURE_ARGS += --enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"
# CONFIGURE_ARGS += --enable-driver-include="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/pmi"
CONFIGURE_ARGS += ARCH=$(LINUX_KARCH)
CONFIGURE_ARGS += \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_DEBUG,debug) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_ERROR_PRINTS,error-print) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_DEBUG_PRINTS,debug-print) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_STATISTICS,statistics) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_ERR_STRINGS,err-string) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_PLATFORM_DRV,platform-drv) \
	$(call autoconf_bool,CONFIG_DSL_GFAST_DRV_PMI_DRV_BUILTIN_TESTS,builtin-tests)

# --enable-add-drv-cflags
# --with-supported-devices
# --enable-control-pmi

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


PKG_MODULE_EXTENSION=.ko

define KernelPackage/$(PKG_NAME)
  SUBMENU:=Lantiq
  TITLE:=Phy Management Interface (PMI) driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+kmod-ifxos +DSL_GFAST_DRV_PMI_MODE_SIMULATION:kmod-dsl-gfast-drv-pmi-sim
  FILES:=$(PKG_INSTALL_DIR)/usr/bin/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
#  AUTOLOAD:=$(call AutoLoad,75,drv_ifxos dsl_gfast_drv_pmi)
endef

define KernelPackage/$(PKG_NAME)/description
   The driver for VRX618 Phy Management Interface (PMI) application.
endef

define Build/Clean
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include}
	$(INSTALL_DIR) $(1)/usr/include/pmi
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/pmi/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcontrol_pmi.* $(1)/usr/lib/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcontrol_pmi.so.* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/control_pmi $(1)/$(PKG_BIN_DIR)
	$(CP) ./files/*.sh $(1)/$(LTQ_BIN_DIR)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call KernelPackage,$(PKG_NAME)))
