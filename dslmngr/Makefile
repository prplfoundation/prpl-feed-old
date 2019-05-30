#
# Copyright (C) 2018 iopsys Software Solutions AB
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dslmngr
PKG_VERSION:=1.0.1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=ca4a5e763b2da4aeb906833da052c1467a7021a7
PKG_SOURCE_URL:=https://github.com/prplfoundation/dslmngr.git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

ifeq ($(CONFIG_TARGET_intel_mips),y)
  TARGET_PLATFORM=INTEL
else
  $(info Unexpected CONFIG_TARGET)
endif

define Package/dslmngr
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=DSL
  TITLE:=XDSL status and configration utility
  DEPENDS:=+libdsl +libuci +libubox +ubus +libpthread +libnl-genl
endef

define Package/dslmngr/description
 This package can be used to configure and provide status about
 the xDSL subsystem through UBUS. DSL Manager interacts with the
 DSL subsystem via libdsl.
endef

TARGET_CFLAGS += \
	-I$(STAGING_DIR)/usr/include \
	-I$(STAGING_DIR)/usr/include/openssl \
	-I$(STAGING_DIR)/usr/include/libnl3 \
	-D_GNU_SOURCE

MAKE_FLAGS += \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	FPIC="$(FPIC)" \
	PLATFORM="$(TARGET_PLATFORM)"

define Build/Compile
	+$(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) $(MAKE_FLAGS)
endef

define Package/dslmngr/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dslmngr $(1)/sbin/
	$(CP) ./files/* $(1)/
endef

define Package/libdsl
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=DSL
  TITLE:= xDSL library
  DEPENDS+=+TARGET_intel_mips:dsl-cpe-api-vrx +TARGET_intel_mips:dsl-cpe-fapi
endef

define Package/libdsl/description
 DSL platform independent library for configuring DSL subsystem
 and gathering statistics.
endef

define Build/Compile
	$(call Build/Compile/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libdsl/xdsl.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/libdsl/libdsl.so* $(1)/usr/lib/
endef

define Package/libdsl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libdsl/libdsl.so* $(1)/usr/lib/

endef

$(eval $(call BuildPackage,libdsl))
$(eval $(call BuildPackage,dslmngr))
