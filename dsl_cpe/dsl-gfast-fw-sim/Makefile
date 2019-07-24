include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-gfast-fw-sim
PKG_VERSION:=0.3.0
PKG_BASE_NAME:=lib_vrx618_fw_sim
PKG_KERNEL_MODULE_NAME:=drv_vrx618_fw_sim
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR:=/opt/lantiq/bin
PKB_BUILD_DEPENDS:=ifxos
PKG_BUILD_PARALLEL:=1
PATCH_DIR:=./patches-$(PKG_VERSION)
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Lantiq
  TITLE:= VRX618 FW Message and State Simulation Library
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+libpthread +kmod-ifxos
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/$(PKG_NAME)/description
  VRX618 FW Message and State Simulation Library
endef

CONFIGURE_ARGS += --enable-linux
CONFIGURE_ARGS += --enable-linux-kernel
CONFIGURE_ARGS += --enable-kernelbuild="$(LINUX_DIR)"
CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos"
CONFIGURE_ARGS += --enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"
CONFIGURE_ARGS += --enable-driver-include="-I$(STAGING_DIR)/usr/include"
CONFIGURE_ARGS += ARCH=$(LINUX_KARCH)

define KernelPackage/$(PKG_NAME)
  SUBMENU:=Lantiq
  TITLE:= VRX618 FW Message and State Simulation Library
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  DEPENDS:=+kmod-ifxos
  MENU:=1
  FILES:=$(PKG_INSTALL_DIR)/usr/bin/$(PKG_KERNEL_MODULE_NAME).$(LINUX_KMOD_SUFFIX)
endef

define Build/Clean
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/vrx618_sim}
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/vrx618_sim/
	mkdir -p $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.{a,la,so*} $(1)/usr/lib/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libvrx618_fw_sim.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call KernelPackage,$(PKG_NAME)))
