#
# Copyright (C) 2018 iopsys Software Solutions AB
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dslmngr
PKG_VERSION:=1.0.0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=68786fa9c603269f32566c101e62f51191224bd7
PKG_SOURCE_URL:=https://github.com/prplfoundation/dsl-poc.git

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/libdsl
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Library for managing XDSL subsystem
endef

define Package/libdsl/description
 This package contains library for managing XDSL subsystem.
endef

define Package/dslmngr
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=XDSL status and configration utility
  DEPENDS:=+libdsl +libuci +libubox +ubus +libpthread +libnl-genl
endef

define Package/dslmngr/description
 This package can be used to configure and provide status about
 the XDSL subsystem through UBUS.
 It does this in an implementation agnostic manner through APIs
 exposed by the libdsl library.
endef

#XDSL_BACKENDS := \
#	$(if $(CONFIG_TARGET_xrx500),intelcpe)

ifeq ($(CONFIG_TARGET_xrx500),y)
  LIBDSL_CFLAGS+=-DINTELCPE
endif

TARGET_CFLAGS += \
	-I$(STAGING_DIR)/usr/include \
	-I$(STAGING_DIR)/usr/include/libnl3 \
	-D_GNU_SOURCE \
	$(LIBDSL_CFLAGS)

MAKE_FLAGS += \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	FPIC="$(FPIC)"

define Build/Compile
	+$(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) $(MAKE_FLAGS)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/libdsl/xdsl.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libdsl/libdsl.so* $(1)/usr/lib/
	$(LN) libdsl.so.$(PKG_VERSION) $(1)/usr/lib/libdsl.so
endef

define Package/libdsl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libdsl/libdsl.so* $(1)/usr/lib/
endef

define Package/dslmngr/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dslmngr $(1)/sbin/
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,libdsl))
$(eval $(call BuildPackage,dslmngr))
