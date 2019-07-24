#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=sl-dsl-cpe
PKG_VERSION:=0.4.2
PKG_MD5SUM:=d6b5b91085510124efa48abbe534efcf
PKG_BASE_NAME:=sl_dsl_cpe
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost

PKG_FIXUP:=autoreconf
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
-include $(INCLUDE_DIR)/package-version-override.mk

ifeq ($(findstring intel,$(VENDOR_PATH)),intel)
#UGW8 onwards
$(call include_mk, ugw-loglevel.mk)
else
include $(INCLUDE_DIR)/ugw-loglevel.mk
endif

define Package/$(PKG_NAME)
  SECTION:=utils
  CATEGORY:=Lantiq
  SUBMENU:=DSL Subsystem
  TITLE:=Lantiq Network Manager
  URL:=http://www.lantiq.com
  MAINTAINER:=Lantiq Beteiligungs-GmbH & Co. KG
  DEPENDS:= +libugwhelper +libcal +csd +servd +polld +dsl-cpe-fapi +system_fapi +ltq-config_common_features:ltq-config_common_features
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	Lantiq SL function for DSL Service
endef

### Menuconfig ##################################
define Package/$(PKG_NAME)/config
    $(call Package/$(PKG_NAME)/override_version)
    $(call Package/$(PKG_NAME)/override_source_path)
    $(call Package/$(PKG_NAME)/config_debug_level)

	config sl-dsl-cpe_TC_SWITCHOVER_WITHOUT_REBOOT
		bool "TC switchover without reboot in puma"
		depends on TARGET_x86 || TARGET_lantiq_xrx330
		depends on PACKAGE_$(PKG_NAME)
		default y
endef

ifeq ($(CONFIG_sl-dsl-cpe_TC_SWITCHOVER_WITHOUT_REBOOT),y)
TARGET_CFLAGS+= -DSWITCHOVER_WITHOUT_REBOOT
endif

ifeq ($(CONFIG_PACKAGE_kmod-vrx518-dp-mod),y)
TARGET_CFLAGS+= -DCONFIG_VRX318_VRX518
else ifeq ($(CONFIG_PACKAGE_kmod-vrx518_tc_drv),y)
TARGET_CFLAGS+= -DCONFIG_VRX318_VRX518
else ifeq ($(CONFIG_PACKAGE_kmod-vrx318-dp-mod),y)
TARGET_CFLAGS+= -DCONFIG_VRX318_VRX518
endif

TARGET_CFLAGS += -I$(LINUX_DIR)/user_headers/include/net/ -I$(LINUX_DIR)/user_headers/include/ -I$(LINUX_DIR)/include/

ifeq ($(CONFIG_USE_MUSL),y)
TARGET_CFLAGS += -DCONFIG_USE_MUSL
endif

CONFIGURE_ARGS += \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib" \
	--enable-dsl-fapi-include="-I$(STAGING_DIR)/usr/include/dsl-fapi" \
	--enable-dsl-fapi-library="-L$(STAGING_DIR)/usr/lib" \
	--enable-system-fapi-include="-I$(STAGING_DIR)/usr/include/system_fapi"

define Build/Configure
	# remove "configured" stamps of other configs
	@- rm $(PKG_BUILD_DIR)/.configured*
	$(call Build/Configure/Default)
endef

define Build/Clean
	@- rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/xml/
	$(INSTALL_DATA) ./files/db_xml/DSL_*.xml $(1)/xml/	
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	cd $(1)/usr/lib && rm -f "libdslsl.so.0" && ln -s "../../$(VENDOR_PATH)/servd/lib/libdslsl.so" "libdslsl.so.0"

	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/servd/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libdslsl.so $(1)/$(VENDOR_PATH)/servd/lib/

	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/xml
	$(INSTALL_DATA) ./files/db_xml/DSL_*.xml $(1)/$(VENDOR_PATH)/xml/

	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/xdslrc.sh $(1)/$(VENDOR_PATH)/etc/init.d/
	cd $(1)/etc/init.d && ln -sf ../../$(VENDOR_PATH)/etc/init.d/xdslrc.sh

	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/www
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/www/languages
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/www/languages/en
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/www/languages/de
	$(INSTALL_DATA) ./files/view_xml/*.* $(1)/$(VENDOR_PATH)/www/
	$(INSTALL_DATA) ./files/view_xml/languages/en/*.* $(1)/$(VENDOR_PATH)/www/languages/en/
	$(INSTALL_DATA) ./files/view_xml/languages/de/*.* $(1)/$(VENDOR_PATH)/www/languages/de/

	$(if $(CONFIG_TARGET_lantiq_xrx200),\
		$(INSTALL_DATA) ./files/view_xml/xrx200/* $(1)/$(VENDOR_PATH)/www/)

	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/cli
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/cli/xmls
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/cli/map-files
	$(INSTALL_DATA) ./files/cli/*.xml $(1)/$(VENDOR_PATH)/cli/xmls/
	$(INSTALL_DATA) ./files/cli/*.map $(1)/$(VENDOR_PATH)/cli/map-files/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
