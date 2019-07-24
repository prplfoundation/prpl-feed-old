#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=dti-pmi
PKG_RELEASE:=1
PKG_BASE_NAME:=dti_agent_pmi
PKG_VERSION:=0.1.1

PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost

PKG_BIN_DIR=/opt/lantiq/bin
PKG_BUILD_DEPENDS:=ifxos lib-dti dsl-gfast-drv-pmi

PKG_FIXUP:=libtool
PKG_INSTALL:=1

-include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_DSL_CO_PMI_DTI' $(TOPDIR)/.config | md5s)
endif

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Lantiq
  TITLE+=DTI PMI device library
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq Deutschland GmbH
  DEPENDS:=+libpthread +librt +lib-dti
  MENU:=1
  SUBMENU:=DSL Subsystem
endef

define Package/$(PKG_NAME)/description
 The DTI PMI device agent and library (shared).
endef

define Package/$(PKG_NAME)/config
	menu "configuration"
	depends on PACKAGE_$(PKG_NAME)
		source "$(SOURCE)/config/Config.in"
	endmenu
   $(call Package/$(PKG_NAME)/override_version)
   $(call Package/$(PKG_NAME)/override_source_path)
endef

CONFIGURE_ARGS += \
	--enable-targetincl=$(STAGING_DIR)/usr/include\
	--enable-target=$(STAGING_DIR)/usr/lib\
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos"\
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"\
	--enable-dti-include="-I$(STAGING_DIR)/usr/include/dti"\
	--enable-dti-library="-L$(STAGING_DIR)/usr/lib"\
	--enable-pmi-driver-include="-I$(STAGING_DIR)/usr/include/pmi"\
	$(call autoconf_bool,CONFIG_DSL_CO_PMI_DTI_ERROR_PRINTS,error-print) \
	$(call autoconf_bool,CONFIG_DSL_CO_PMI_DTI_DEBUG_PRINTS,debug-print) \
	--enable-dti-agent \
	--enable-pmi

ifeq ($(CONFIG_DSL_CO_PMI_DTI_ALL_STATIC),y)
CONFIGURE_ARGS += --disable-shared
CONFIGURE_ARGS += --enable-all-static
endif

ifdef CONFIG_PACKAGE_lib-dti-device-generic
CONFIGURE_ARGS += \
	--enable-dev-generic
endif

define Build/Clean
	@- rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include}
	$(INSTALL_DIR) $(1)/usr/include/pmi
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/pmi/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdti_device_pmi.* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdti_agent_pmi.* $(1)/usr/lib/
endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/pmi/dti_device_pmi.h
	- rm -Rf $(1)/usr/include/pmi/dti_agent_pmi.h
	- rm -f $(1)/usr/lib/libdti_device_pmi.*
	- rm -f $(1)/usr/lib/libdti_agent_pmi.*
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
ifneq ($(CONFIG_DSL_CO_PMI_DTI_ALL_STATIC),y)
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdti_device_pmi.so.* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdti_agent_pmi.so.* $(1)/usr/lib/
endif
ifeq ($(CONFIG_DSL_CO_PMI_DTI_STANDALONE_AGENT),y)
		$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
		$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dti_agent_pmi $(1)/$(PKG_BIN_DIR)
endif
endef


$(eval $(call BuildPackage,$(PKG_NAME)))

