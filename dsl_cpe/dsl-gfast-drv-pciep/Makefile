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

include $(INCLUDE_DIR)/package.mk

define Package/dsl-gfast-drv-pciep
  SECTION:=app
  CATEGORY:=Intel
  TITLE:= PCIe Endpoint Driver for VRX618
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+libpthread +kmod-ifxos
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/dsl-gfast-drv-pciep/description
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

define KernelPackage/dsl-gfast-drv-pciep
  SUBMENU:=Intel
  TITLE:=VRX618 PCIe Endpoint driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+kmod-ifxos
  FILES:=$(PKG_BUILD_DIR)/src/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/dsl-gfast-drv-pciep/description
   The driver for VRX618 PCIe Endpoint application.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/vrx618
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/vrx618/
endef

define Package/dsl-gfast-drv-pciep/install
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
endef

$(eval $(call BuildPackage,dsl-gfast-drv-pciep))
$(eval $(call KernelPackage,dsl-gfast-drv-pciep))

