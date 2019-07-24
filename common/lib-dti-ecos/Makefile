#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=lib-dti-ecos
PKG_RELEASE:=1
PKG_BASE_NAME:=lib_dti
PKG_VERSION:=1.2.5

PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DEPENDS:=ifxos-ecos

PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_PACKAGE_lib-dti' $(TOPDIR)/.config | md5s)$(shell $(SH_FUNC) grep '^CONFIG_ECOS_' $(TOPDIR)/.config | md5s)$(shell $(SH_FUNC) grep '^CONFIG_COMMON_DTI_' $(TOPDIR)/.config | md5s)
endif

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Lantiq
  SUBMENU:=DTI
  TITLE:=DTI library (eCos)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq
  MENU:=1
  DEPENDS:=+ifxos-ecos
endef

define Package/$(PKG_NAME)/description
 Debug and Trace Interface (DTI) for eCos
 This package provides a generic library used for the DTI access.
endef

define Package/$(PKG_NAME)/config
	menu "configuration"
	depends on PACKAGE_$(PKG_NAME)
		source "$(SOURCE)/config/Config.in"
	endmenu
   $(call Package/$(PKG_NAME)/override_version)
   $(call Package/$(PKG_NAME)/override_source_path)
endef

# make the submake silent:
ifeq ($(QUIET),1)
MAKE_FLAGS+=-s
endif
ifneq (,$(findstring 99,$(V)))
MAKE_FLAGS+=-s
endif

TARGET_CFLAGS += \
	-DDTI_LISTENER_THREAD_STACK_SIZE=4608 \
	-DDTI_WORKER_THREAD_STACK_SIZE=16384 \
	-g -ggdb

CONFIGURE_ARGS += \
	--enable-ecos \
	--enable-targetincl=$(STAGING_DIR)/usr/include \
	--enable-target=$(STAGING_DIR)/usr/lib \
	--enable-debug \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos -I$(STAGING_DIR)/usr/include/ecos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib" \
	--with-dti-tcp-port=9000 \
	--disable-dti-agent \
	--disable-dev-generic \
	--enable-cli \
	$(call autoconf_bool,CONFIG_COMMON_DTI_ERROR_PRINTS,error-print) \
	$(call autoconf_bool,CONFIG_COMMON_DTI_DEBUG_PRINTS,debug-print)

define Build/Clean
	@- rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/dti}
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/dti
	mkdir -p $(1)/usr/lib
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/libdti_agent.a $(1)/usr/lib/libdti_agent-ecos.a
endef


define Build/UninstallDev
	- rm -Rf $(1)/usr/include/dti
	- rm -f $(1)/usr/lib/libdti*
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

