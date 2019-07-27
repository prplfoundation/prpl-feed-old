include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=lib-cli
PKG_RELEASE:=1
PKG_BASE_NAME:=lib_cli
PKG_VERSION:=2.8.0
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/lib-cli/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost
PKG_BIN_DIR=/opt/lantiq/bin
PKG_BUILD_DEPENDS:=ifxos
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/lib-cli
  SECTION:=driver
  CATEGORY:=Intel
  TITLE:= CLI Library
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel Deutschland GmbH
  DEPENDS:=+ifxos +libpthread
  MENU:=1
  SUBMENU:=CLI
endef

define Package/lib-cli/description
 The common command line interface (CLI) library.
endef

define Package/lib-cli/config
	menu "configuration"
	depends on PACKAGE_lib-cli
		source "$(SOURCE)/config/Config.in"
	endmenu
endef

MAKE_FLAGS += -s
CONFIGURE_ARGS += \
	--enable-kernelincl="$(LINUX_DIR)/include"
CONFIGURE_ARGS += --enable-linux-26 --enable-kernelbuild="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION:=.ko

CONFIGURE_ARGS += \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib" \
	$(call autoconf_bool,CONFIG_COMMON_CLI_ERROR_PRINTS,error-print) \
	$(call autoconf_bool,CONFIG_COMMON_CLI_DEBUG_PRINTS,debug-print) \
	$(call autoconf_bool,CONFIG_COMMON_CLI_SUPPORT_BUFFER_OUT,cli-buffer-pout) \
	$(call autoconf_bool,CONFIG_COMMON_CLI_SUPPORT_FILE_OUT,cli-file-pout) \
	$(call autoconf_bool,CONFIG_COMMON_CLI_SUPPORT_CONSOLE,cli-console) \
	$(call autoconf_bool,CONFIG_COMMON_CLI_SUPPORT_PIPE,cli-pipe) \
	$(call autoconf_bool,CONFIG_COMMON_CLI_EXAMPLE,build-example) \
	--with-max-pipes=$(strip $(CONFIG_COMMON_CLI_MAX_CLI_PIPES))

ifeq ($(CONFIG_COMMON_CLI_SUPPORT_AUTO_COMPLETION),y)
TARGET_CFLAGS += -DCLI_SUPPORT_AUTO_COMPLETION=1
else
TARGET_CFLAGS += -DCLI_SUPPORT_AUTO_COMPLETION=0
endif

define KernelPackage/lib-cli
  SUBMENU:=Intel
  DEPENDS:=+kmod-ifxos
  TITLE:=CLI Module (kernel space)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel Deutschland GmbH
  FILES:=$(PKG_BUILD_DIR)/src/mod_cli$(PKG_MODULE_EXTENSION)
  AUTOLOAD:=$(call AutoLoad,15,drv_ifxos mod_cli)
endef

define KernelPackage/lib-cli/description
  The common command line interface (CLI) kernel module.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include}
	$(CP) $(PKG_INSTALL_DIR)/include/cli $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcli.* $(1)/usr/lib/
endef

define Build/UninstallDev
	- rm -Rf $(1)/usr/include/cli
	- rm -f $(1)/usr/lib/libcli.*
endef

define Package/lib-cli/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcli.so* $(1)/usr/lib/
ifeq ($(CONFIG_COMMON_CLI_EXAMPLE),y)
	$(INSTALL_DIR) $(1)/$(PKG_BIN_DIR)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/cli_example $(1)/$(PKG_BIN_DIR)
endif
endef

$(eval $(call BuildPackage,lib-cli))
$(eval $(call KernelPackage,lib-cli))
