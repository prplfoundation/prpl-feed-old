include $(TOPDIR)/rules.mk

PKG_NAME:=ifx-eeprom
PKG_VERSION:=0.0.1
PKG_BASE_NAME:=eeprom
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_BUILD_DEPENDS:=lib_ifxos ifx-spi
PKG_SOURCE_URL:=http://localhost

include $(INCLUDE_DIR)/package.mk

define Package/ifx-eeprom
  SECTION:=driver
  CATEGORY:=Intel
  TITLE:=EEPROM manipulating
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+kmod-ifxos ifx-spi
endef

define Package/ifx-eeprom/description
	EEPROM manipulating application
endef

CONFIGURE_ARGS += \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"

CONFIGURE_ARGS += --enable-debug --enable-warnings

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
endef

define Package/ifx-eeprom/install
	$(INSTALL_DIR) $(1)/opt/ifx/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/eeprom $(1)/opt/ifx/bin
endef

$(eval $(call BuildPackage,ifx-eeprom))
