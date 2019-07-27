include $(TOPDIR)/rules.mk

PKG_NAME:=ifxos-ecos
PKG_BASE_NAME:=lib_ifxos
PKG_VERSION:=1.6.9
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_BUILD_DEPENDS:=ecos
PKG_SOURCE_URL:=http://localhost
PKG_MD5SUM:=2c40d61533696b279cbaa9794bcf3559
PKG_FIXUP:=libtool
PKG_INSTALL:=1
PATCH_DIR:=./patches-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Intel
  SUBMENU:=IFXOS
  TITLE:=Intel OS abstraction library (eCos)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  MENU:=1
  DEPENDS:=+ecos
endef

define Package/$(PKG_NAME)/config
	menu "configuration"
	depends on PACKAGE_$(PKG_NAME)
		source "$(SOURCE)/config/Config.ecos"
	endmenu
endef

define Package/$(PKG_NAME)/description
  This library will be used by Lantiq SFP applications / drivers under eCos
endef

# make the submake silent:
ifeq ($(QUIET),1)
MAKE_FLAGS+=-s
endif
ifneq (,$(findstring 99,$(V)))
MAKE_FLAGS+=-s
endif

CONFIGURE_ARGS += \
	--enable-ecos \
	--enable-kernelincl="$(STAGING_DIR)/usr/include/ecos" \
	--without-kernel-module

TARGET_CFLAGS += \
	-DIFXOS_ADD_STATIC_MEMORY_FILE \
	-DIFXOS_ADD_STATIC_SOCKET_FILE \
	-DDEVIO_SELECT_POLLING_TIME=10 \
	-g -ggdb

ifeq ($(CONFIG_IFXOS_ECOS_OVERRIDE_DEVIO_SETTINGS),y)
define Build/Prepare
	$(Build/Prepare/Default)
	$(SED) 's/#define DEVIO_MAXDRIVERS.*/#define DEVIO_MAXDRIVERS $(strip $(subst ",,$(CONFIG_IFXOS_ECOS_DEVIO_MAXDRIVERS)))/g' $(PKG_BUILD_DIR)/src/include/ifxos_device_io.h
	$(SED) 's/#define DEVIO_MAXDEVICES.*/#define DEVIO_MAXDEVICES $(strip $(subst ",,$(CONFIG_IFXOS_ECOS_DEVIO_MAXDEVICES)))/g' $(PKG_BUILD_DIR)/src/include/ifxos_device_io.h
	$(SED) 's/#define DEVIO_MAXFDS.*/#define DEVIO_MAXFDS $(strip $(subst ",,$(CONFIG_IFXOS_ECOS_DEVIO_MAXFDS)))/g' $(PKG_BUILD_DIR)/src/include/ifxos_device_io.h
endef
endif

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/ifxos}
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/ifxos

	mkdir -p $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libifxos.a $(1)/usr/lib/libifxos-ecos.a

endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/ifxos
	- rm -f $(1)/usr/lib/libifxos*
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
