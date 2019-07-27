include $(TOPDIR)/rules.mk

PKG_NAME:=lib-dti
PKG_RELEASE:=1
PKG_BASE_NAME:=lib_dti
PKG_VERSION:=1.2.5
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR=/opt/lantiq/bin
AGENT_LIB_DIR=/opt/lantiq/lib
PKG_BUILD_DEPENDS:=ifxos
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/lib-dti/Default
  TITLE:=DTI
  URL:=http://www.lantiq.com/
endef

define Package/lib-dti/Default/description
 Debug and Trace Interface (DTI)
 This package provides a generic library used for the DTI access.
endef

define Package/lib-dti
$(call Package/lib-dti/Default)
  SECTION:=libs
  CATEGORY:=Intel
  DEPENDS:=+libpthread
  TITLE+= (library)
  SUBMENU:=DTI
endef

define Package/lib-dti/description
$(call Package/lib-dti/Default/description)
 This package contains the DTI shared libraries, needed by other programs.
 - libdti_agent
endef

define Package/lib-dti-device-generic
$(call Package/lib-dti/Default)
  SECTION:=libs
  CATEGORY:=Intel
  TITLE+= (generic device library)
  SUBMENU:=DTI
  DEFAULT:=n
  DEPENDS:=lib-dti
endef

define Package/lib-dti-device-generic/description
$(call Package/lib-dti/Default/description)
 This package contains the DTI generic device library (for testing).
 - libdti_device_generic
endef

define Package/dti-agent
$(call Package/lib-dti/Default)
  SECTION:=application
  CATEGORY:=Intel
  TITLE+= (Default Agent)
  SUBMENU:=DTI
  DEFAULT:=n
  DEPENDS:=lib-dti
endef

define Package/dti-agent/description
$(call Package/lib-dti/Default/description)
 This package builds a default DTI Agent.
 - dti_agent
endef

define Package/lib-dti/config
	menu "configuration"
	depends on PACKAGE_lib-dti
		source "$(SOURCE)/config/Config.in"
	endmenu
endef

CONFIGURE_ARGS += \
	--enable-targetincl=$(STAGING_DIR)/usr/include \
	--enable-target=$(STAGING_DIR)/usr/lib \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos"\
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"\
	--enable-debug \
	--with-dti-tcp-port=$(strip $(CONFIG_COMMON_DTI_TCP_IP_PORT)) \
	$(call autoconf_bool,CONFIG_COMMON_DTI_ERROR_PRINTS,error-print) \
	$(call autoconf_bool,CONFIG_COMMON_DTI_CLI,cli) \
	$(call autoconf_bool,CONFIG_COMMON_DTI_STATISTICS,core-statistic) \
	$(call autoconf_bool,CONFIG_COMMON_DTI_GENERIC_DEVICE,dev-generic) \
	$(call autoconf_bool,CONFIG_COMMON_DTI_STANDALONE,dti-agent) \
	$(call autoconf_bool,CONFIG_COMMON_DTI_CLIENT_LIB,dti-client)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/dti}
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/dti
	mkdir -p $(1)/usr/lib
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/*.{a,la,so*} $(1)/usr/lib/
endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/dti
	- rm -f $(1)/usr/lib/libdti*.so*
endef

define Package/lib-dti/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdti_agent*.so.* $(1)/usr/lib/
ifeq ($(CONFIG_COMMON_DTI_CLIENT_LIB),y)
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdti_client*.so.* $(1)/usr/lib/
endif
endef

define Package/lib-dti-device-generic/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdti_device_generic*.so.* $(1)/usr/lib/
endef

define Package/dti-agent/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/$(PKG_BIN_DIR)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dti_agent_main $(1)/$(PKG_BIN_DIR)
endef

$(eval $(call BuildPackage,lib-dti))
$(eval $(call BuildPackage,lib-dti-device-generic))
$(eval $(call BuildPackage,dti-agent))
