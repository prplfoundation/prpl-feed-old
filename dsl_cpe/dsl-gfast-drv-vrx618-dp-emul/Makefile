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

define Package/dsl-gfast-drv-vrx618-dp-emul
  SECTION:=app
  CATEGORY:=Intel
  TITLE:= VRX618 Datapath Emulation Setup Driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+libpthread +dsl-gfast-drv-pciep
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/dsl-gfast-drv-vrx618-dp-emul/description
   VRX618 Datapath Emulation Setup Driver
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

define KernelPackage/dsl-gfast-drv-vrx618-dp-emul
  SUBMENU:=Intel
  TITLE:=VRX618 Datapath Emulation Setup Driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+kmod-ifxos
  FILES:=$(PKG_BUILD_DIR)/src/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/dsl-gfast-drv-vrx618-dp-emul/description
   The driver for VRX618 Datapath Emulation Setup.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
endef

define Package/dsl-gfast-drv-vrx618-dp-emul/install
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
	$(INSTALL_DIR) $(1)/lib/firmware/09AA
	$(INSTALL_BIN) ./files/aca_fw.bin $(1)/lib/firmware/09AA/aca_fw.bin
endef

$(eval $(call BuildPackage,dsl-gfast-drv-vrx618-dp-emul))
$(eval $(call KernelPackage,dsl-gfast-drv-vrx618-dp-emul))
