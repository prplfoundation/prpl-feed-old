include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-gfast-drv-pmi-sim
PKG_VERSION:= 0.3.0
PKG_BASE_NAME:=drv_pmi_sim
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR=/opt/lantiq/bin
PKG_BUILD_DEPENDS:=ifxos dsl-gfast-fw-sim
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/dsl-gfast-drv-pmi-sim
  SECTION:=app
  CATEGORY:=Intel
  TITLE:= G.Fast PMI SIM Driver for VRX618
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+libpthread +kmod-ifxos +dsl-gfast-fw-sim
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/dsl-gfast-drv-pmi-sim/description
   G.Fast PMI SIM Driver for VRX618
endef

ifeq ($(QUIET),1)
MAKE_FLAGS+=-s
endif
ifneq (,$(findstring 99,$(V)))
MAKE_FLAGS+=-s
endif

CONFIGURE_ARGS += \
	--enable-driver-include="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/pmi -I$(STAGING_DIR)/usr/include/vrx618_sim"
CONFIGURE_ARGS += --enable-linux-kernel
CONFIGURE_ARGS += --enable-kernelbuild="$(LINUX_DIR)"
CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos"
CONFIGURE_ARGS += --enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"
CONFIGURE_ARGS += --enable-error-print
CONFIGURE_ARGS += --enable-debug-print
CONFIGURE_ARGS += ARCH=$(LINUX_KARCH)

PKG_MODULE_EXTENSION=.ko

define KernelPackage/dsl-gfast-drv-pmi-sim
  SUBMENU:=Intel
  TITLE:=G.Fast PMI SIM Driver for VRX618
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+kmod-ifxos +kmod-dsl-gfast-fw-sim
  FILES:=$(PKG_BUILD_DIR)/src/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,mod_drv_pmi_sim)
endef

define KernelPackage/dsl-gfast-drv-pmi-sim/description
   The driver for G.Fast PMI SIM Driver for VRX618.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/vrx618_sim
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/vrx618_sim/
endef

define Package/dsl-gfast-drv-pmi-sim/install
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
	$(INSTALL_BIN) ./files/init_618sim.sh $(1)/$(LANTIQ_BIN_DIR)/init_618_sim.sh
endef

$(eval $(call BuildPackage,dsl-gfast-drv-pmi-sim))
$(eval $(call KernelPackage,dsl-gfast-drv-pmi-sim))
