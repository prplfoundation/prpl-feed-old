include $(TOPDIR)/rules.mk

PKG_NAME:=lib-dti-ecos
PKG_RELEASE:=1
PKG_BASE_NAME:=lib_dti
PKG_VERSION:=1.2.5
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/lib-dti-ecos/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DEPENDS:=ifxos-ecos
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/lib-dti-ecos
  SECTION:=libs
  CATEGORY:=Intel
  SUBMENU:=DTI
  TITLE:=DTI library (eCos)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  MENU:=1
  DEPENDS:=+ifxos-ecos
endef

define Package/lib-dti-ecos/description
 Debug and Trace Interface (DTI) for eCos
 This package provides a generic library used for the DTI access.
endef

define Package/lib-dti-ecos/config
	menu "configuration"
	depends on PACKAGE_lib-dti-ecos
		source "$(SOURCE)/config/Config.in"
	endmenu
endef

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

$(eval $(call BuildPackage,lib-dti-ecos))
