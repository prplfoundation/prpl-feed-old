#
# Copyright (C) 2014 OpenWrt.org
# Copyright (C) 2014 lantiq.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-gfast-drv-vrx618-dp-emul
PKG_VERSION:= 0.1.0.3
PKG_BASE_NAME:=dsl_gfast_drv_vrx618_dp_emul
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR=/opt/lantiq/bin
PKG_BUILD_DEPENDS:=dsl-gfast-drv-pciep 
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
-include $(INCLUDE_DIR)/package-version-override.mk

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_VRX618_DP_EMUL_' $(TOPDIR)/.config | md5s)
endif

define Package/$(PKG_NAME)
  SECTION:=app
  CATEGORY:=Lantiq
  TITLE:= VRX618 Datapath Emulation Setup Driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+libpthread +dsl-gfast-drv-pciep
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/$(PKG_NAME)/description
   VRX618 Datapath Emulation Setup Driver
endef

define Package/$(PKG_NAME)/config_
	#menu "configuration"
	#depends on PACKAGE_$(PKG_NAME)
	#	source "$(SOURCE)/config/Config.in"
	#endmenu
   $(call Package/$(PKG_NAME)/override_version)
   $(call Package/$(PKG_NAME)/override_source_path)
endef

# make the submake silent:
ifeq ($(QUIET),1)
MAKE_FLAGS+=-s
endif
ifneq (,$(findstring 99,$(V)))
MAKE_FLAGS+=-s
endif

CONFIGURE_ARGS += --enable-linux-kernel
CONFIGURE_ARGS += --enable-kernelbuild="$(LINUX_DIR)"
CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --enable-driver-include="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/vrx618"
CONFIGURE_ARGS += ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION=.ko

define KernelPackage/$(PKG_NAME)
  SUBMENU:=Lantiq
  TITLE:=VRX618 Datapath Emulation Setup Driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+kmod-ifxos
  FILES:=$(PKG_BUILD_DIR)/src/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
#  AUTOLOAD:=$(call AutoLoad,90,mod_vrx618_dp_emul)
endef

define KernelPackage/$(PKG_NAME)/description
   The driver for VRX618 Datapath Emulation Setup.
endef

define Build/Clean
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)

	$(INSTALL_DIR) $(1)/lib/firmware/09AA
	$(INSTALL_BIN) ./files/aca_fw.bin $(1)/lib/firmware/09AA/aca_fw.bin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call KernelPackage,$(PKG_NAME)))

