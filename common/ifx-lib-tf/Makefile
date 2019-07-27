include $(TOPDIR)/rules.mk

PKG_NAME:=ifx-lib-tf
PKG_VERSION:=2.1.3
PKG_BASE_NAME:=lib_tf
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(PKG_SOURCE_DIR)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/ifx-lib-tf
  SECTION:=libs
  CATEGORY:=Intel
  TITLE:=Intel Test Framework library
  URL:=http://www.Lantiq.com/
  MAINTAINER:=Intel Deutschland GmbH
  DEPENDS:=+libpthread +ifxos
  MENU:=1
endef

define Package/ifx-lib-tf/description
	This library will be used by some Lantiq applications.
endef

CONFIGURE_ARGS += \
	--enable-warnings \
	--enable-messages \
	--enable-trace \
	--enable-soap \
	--with-ifxos-incl=$(STAGING_DIR)/usr/include/ifxos \
	--with-ifxos-lib=$(STAGING_DIR)/usr/lib \
	--enable-target=$(STAGING_DIR)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/libtf/include}
	$(CP) $(PKG_SOURCE_DIR)/include/* $(1)/usr/include/libtf/include
	$(CP) $(PKG_SOURCE_DIR)/tc_server/report.h $(1)/usr/include/libtf/include/
	$(CP) $(PKG_SOURCE_DIR)/tc_dispatch_loc/tc_dispatch_loc.h $(1)/usr/include/libtf/include/
	mkdir -p $(1)/usr/lib/tc_server
	mkdir -p $(1)/usr/lib/tc_dispatch_loc
	$(CP) $(PKG_BUILD_DIR)/tc_server/libtc_server.a $(1)/usr/lib/tc_server/libtc_server.a
	$(CP) $(PKG_BUILD_DIR)/tc_dispatch_loc/libtc_disploc.a $(1)/usr/lib/tc_dispatch_loc/libtc_disploc.a
endef

$(eval $(call BuildPackage,ifx-lib-tf))
