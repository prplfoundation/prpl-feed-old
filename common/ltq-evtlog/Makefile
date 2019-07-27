include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ltq-evtlog
PKG_VERSION:=1.1.15
PKG_RELEASE:=1
PKG_MD5SUM:=d98d33668fe3539cd624e2c378571bdc
PKG_BASE_NAME:=drv_event_logger
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://localhost
PKG_SOURCE_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(PKG_SOURCE_DIR)
PKG_CAT:=zcat
PKG_BUILD_DEPENDS:=ifxos
PKG_USE_MIPS16:=0
LANTIQ_BIN_DIR=opt/lantiq/bin
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/ltq-evtlog
  SECTION:=driver
  CATEGORY:=Intel
  TITLE:=Event Logger Kernel Module
  URL:=http://www.Lantiq.com/
  MAINTAINER:=Intel Corporation
  MENU:=1
  DEPENDS:=+kmod-ifxos
endef

define Package/ltq-evtlog/description
	Lantiq Event Logger (Kernel Module)
endef

CONFIGURE_ARGS += --disable-trace --with-kernel-incl="$(LINUX_DIR)/include" \
						--with-ifxos-incl="$(STAGING_DIR)/usr/include/ifxos" \
						--with-ifxos-lib="$(STAGING_DIR)/usr/lib"

CONFIGURE_ARGS += --enable-linux-26 --with-kernel-build="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION=.ko

define Package/ltq-evtlog/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/load_evtlog.sh $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/$(LANTIQ_BIN_DIR)
	$(INSTALL_DIR) $(1)/$(MODULES_SUBDIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/$(PKG_BASE_NAME)$(PKG_MODULE_EXTENSION) $(1)/$(MODULES_SUBDIR)
	ln -snf /$(MODULES_SUBDIR)/$(PKG_BASE_NAME).$(LINUX_KMOD_SUFFIX) $(1)/$(LANTIQ_BIN_DIR)/$(PKG_BASE_NAME)$(PKG_MODULE_EXTENSION)
	ln -snf /$(MODULES_SUBDIR)/drv_ifxos.$(LINUX_KMOD_SUFFIX) $(1)/$(LANTIQ_BIN_DIR)/drv_ifxos$(PKG_MODULE_EXTENSION)
endef

define KernelPackage/ltq-evtlog
  SUBMENU:=Intel
  DEPENDS:=+kmod-ifxos
  TITLE:=Event Logger Module
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel Corporation
  FILES:=$(PKG_BUILD_DIR)/src/drv_event_logger$(PKG_MODULE_EXTENSION)
  AUTOLOAD:=$(call AutoLoad,15,drv_event_logger)
endef

define KernelPackage/ltq-evtlog/description
   Event Logger Kernel Module
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	mkdir -p $(1)/usr/include/event_logger
	$(CP) $(PKG_SOURCE_DIR)/include/* $(1)/usr/include/event_logger
endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/event_logger
endef

$(eval $(call BuildPackage,ltq-evtlog))
$(eval $(call KernelPackage,ltq-evtlog))
