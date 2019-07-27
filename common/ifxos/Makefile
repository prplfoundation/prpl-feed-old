include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ifxos
PKG_BASE_NAME:=lib_ifxos
PKG_VERSION:=1.6.9
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/ifxos/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_MD5SUM:=2c40d61533696b279cbaa9794bcf3559
PKG_FIXUP:=libtool
PKG_INSTALL:=1
PKG_CONFIG_DEPENDS:=CONFIG_IFXOS_SHARED_LIB

PATCH_DIR:=./patches-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/ifxos
  SECTION:=libs
  CATEGORY:=Intel
  SUBMENU:=IFXOS
  TITLE:=Intel OS abstraction library (Linux)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+libpthread +librt
  MENU:=1
endef

define Package/ifxos/config
	menu "configuration"
	depends on PACKAGE_ifxos
	source "$(SOURCE)/config/Config.in"
	endmenu
endef

define Package/ifxos/description
  This library will be used by some Lantiq applications / drivers under Linux
endef

define KernelPackage/ifxos
  SUBMENU:=Intel
  TITLE:=Intel OS abstraction library
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  FILES:=$(PKG_INSTALL_DIR)/usr/bin/drv_ifxos$(PKG_MODULE_EXTENSION)
  AUTOLOAD:=$(call AutoLoad,10,drv_ifxos)
endef

MAKE_FLAGS+=-s

ifeq ($(CONFIG_IFXOS_IPV6_SUPPORT),y)
IFXOS_IPV6_SUPPORT:=--enable-ipv6-drv
else
IFXOS_IPV6_SUPPORT:=--disable-ipv6-drv
endif

CONFIGURE_ARGS += \
	$(IFXOS_IPV6_SUPPORT)

ifneq ($(CONFIG_PACKAGE_kmod-ifxos),)
CONFIGURE_ARGS += --with-kernel-module
CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --enable-linux-26 --enable-kernelbuild="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION:=.ko
else
CONFIGURE_ARGS += --without-kernel-module
endif

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/ifxos}
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/ifxos
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos.a $(1)/usr/lib/libifxos.a
ifeq ($(CONFIG_IFXOS_SHARED_LIB),y)
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos.so* $(1)/usr/lib/
endif
	$(INSTALL_DIR) $(1)/modulesym
	- $(CP) $(PKG_BUILD_DIR)/src/Module.symvers $(1)/modulesym/ifxos.symvers
endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/ifxos
	- rm -f $(1)/usr/lib/libifxos*
endef

define Package/ifxos/install
#
ifeq ($(CONFIG_IFXOS_SHARED_LIB),y)
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos.so* $(1)/usr/lib/
endif
endef

$(eval $(call BuildPackage,ifxos))
$(eval $(call KernelPackage,ifxos))
