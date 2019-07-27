include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ifx-spi
PKG_VERSION:=0.7.0
PKG_BASE_NAME:=drv_spi
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR:=opt/lantiq/bin

include $(INCLUDE_DIR)/package.mk

PKG_BUILD_DEPENDS:=ifxos

define Package/ifx-spi
  SECTION:=driver
  CATEGORY:=Intel
  TITLE:=SPI driver
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  MENU:=1
endef

define Package/ifx-spi/description
	Infineon SPI driver (EASY4171 / EASY83002 / EASY88008)
endef

CONFIGURE_ARGS += --enable-linux-26 --enable-kernelbuild="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION=.ko

CONFIGURE_ARGS += --enable-kernelincl="$(LINUX_DIR)/include" \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{include,include/drv_spi}
	$(CP) $(PKG_BUILD_DIR)/src/drv_spi_interface.h $(1)/usr/include/drv_spi
	$(CP) $(PKG_BUILD_DIR)/src/drv_spi_eeprom_at25160.h $(1)/usr/include/drv_spi
	$(CP) $(PKG_BUILD_DIR)/src/drv_spi_export.h $(1)/usr/include/drv_spi
	$(CP) $(PKG_BUILD_DIR)/src/mpc/src/drv_mpc.h $(1)/usr/include/drv_spi
endef

define Build/UninstallDev
	rm -rf $(1)/usr/include/drv_spi
endef

define Package/ifx-spi/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ifx_load_spi_drv.sh $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/$(PKG_BASE_NAME)$(PKG_MODULE_EXTENSION) $(1)/$(PKG_BIN_DIR)
	$(INSTALL_DIR) $(1)/$(MODULES_SUBDIR)
	ln -snf /$(PKG_BIN_DIR)/$(PKG_BASE_NAME)$(PKG_MODULE_EXTENSION) $(1)/$(MODULES_SUBDIR)/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX)
endef

$(eval $(call BuildPackage,ifx-spi))
