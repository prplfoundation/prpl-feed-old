include $(TOPDIR)/rules.mk

PKG_NAME:=ifxos-devio
PKG_BASE_NAME:=lib_ifxos
PKG_VERSION:=1.6.9
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/ifxos-devio/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_MD5SUM:=2c40d61533696b279cbaa9794bcf3559
PKG_FIXUP:=libtool
PKG_INSTALL:=1
PATCH_DIR:=./patches-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/ifxos-devio
  SECTION:=libs
  CATEGORY:=Intel
  SUBMENU:=IFXOS
  TITLE:=Intel OS abstraction library (devio)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  MENU:=1
  DEPENDS:=+kmod-ifxos
endef

define Package/ifxos-devio/description
 Lantiq IFXOS - compiled for devio interface.
endef

CONFIGURE_ARGS += \
	--without-kernel-module\
	--enable-add_appl_cflags="-DIFXOS_DEBUG_USR_PRINT=0 -DIFXOS_USE_ERROR_USR_PRINT=0 -DIFXOS_USE_DEV_IO=1 -DIFXOS_HAVE_SOCKET=1" \
	--enable-targetincl=$(STAGING_DIR)/usr/include\
	--enable-target=$(STAGING_DIR)/usr/lib

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/ifxos_devio}
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/ifxos_devio
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos_devio.* $(1)/usr/lib/
endef

define Package/ifxos-devio/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos_devio.* $(1)/usr/lib/
endef

define Build/UninstallDev
	- rm -f $(1)/usr/lib/libifxos_devio.*
endef

$(eval $(call BuildPackage,ifxos-devio))
