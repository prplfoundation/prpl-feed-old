#
# Copyright (C) 2014 OpenWrt.org
# Copyright (C) 2014 lantiq.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-gfast-drv-pciep
PKG_VERSION:= 0.1.2
PKG_BASE_NAME:=dsl_gfast_drv_vrx618_ep
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR=/opt/lantiq/bin
PKG_BUILD_DEPENDS:=ifxos
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

-include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_VRX618_EP_' $(TOPDIR)/.config | md5s)
endif

define Package/$(PKG_NAME)
  SECTION:=app
  CATEGORY:=Lantiq
  TITLE:= PCIe Endpoint Driver for VRX618
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+libpthread +kmod-ifxos
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/$(PKG_NAME)/description
   PCIe Endpoint Driver for VRX618
endef


# make the submake silent:
ifeq ($(QUIET),1)
MAKE_FLAGS+=-s
endif
ifneq (,$(findstring 99,$(V)))
MAKE_FLAGS+=-s
endif

CONFIGURE_ARGS += \
	--enable-driver-include="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/vrx618"

CONFIGURE_ARGS += --enable-linux-kernel
CONFIGURE_ARGS += --enable-kernelbuild="$(LINUX_DIR)"
CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION=.ko

define KernelPackage/$(PKG_NAME)
  SUBMENU:=Lantiq
  TITLE:=VRX618 PCIe Endpoint driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+kmod-ifxos
  FILES:=$(PKG_BUILD_DIR)/src/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
#  AUTOLOAD:=$(call AutoLoad,90,mod_vrx618_ep)
endef

define KernelPackage/$(PKG_NAME)/description
   The driver for VRX618 PCIe Endpoint application.
endef

define Build/Clean
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/vrx618
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/vrx618/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call KernelPackage,$(PKG_NAME)))

