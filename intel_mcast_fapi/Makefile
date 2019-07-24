#
# Openwrt Makefile for libmcastfapi
#
#

#### Includes ###################################
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
#### Package Info ############################### 
PKG_NAME:=libmcastfapi
PKG_SOURCE_VERSION:=1.0.2.7
PKG_RELEASE=1
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/prplfoundation/intel_mcast_fapi.git
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_SOURCE_VERSION)

PKG_MAINTAINER:=Intel
PKG_LICENSE:=Intel

include $(INCLUDE_DIR)/package.mk
$(call include_mk, ugw-loglevel.mk)


define Package/$(PKG_NAME)
  SECTION:=utils
  CATEGORY:=Intel
  SUBMENU:=UGW Software
  TITLE:=Intel Mcast FAPI
  URL:=http://www.intel.com
  MAINTAINER:=Intel Corporation 
  DEPENDS:= +kmod-mcast-helper +kmod-mcast-snooping +libsafec
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	Intel Multicast FAPI Support .
endef

define KernelPackage/mcast-helper
  SUBMENU:=Intel
  TITLE:=MCAST-HELPER support
  KCONFIG:= \
	CONFIG_MCAST_HELPER=y
endef

define KernelPackage/mcast-snooping
  SUBMENU:=Intel
  TITLE:=MCAST-SNOOPING support
  KCONFIG:= \
	CONFIG_MCAST_SNOOPING=y
endef

define KernelPackage/mcast-helper/description
 A kernel module for multicast PPA and ACL support.
endef

### Menuconfig ##################################
define Package/$(PKG_NAME)/config
$(call Package/$(PKG_NAME)/override_version)
$(call Package/$(PKG_NAME)/override_source_path)
$(call Package/$(PKG_NAME)/config_debug_level)
endef

# To Staging Dir
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/mcast
	$(INSTALL_DIR) $(1)/usr/lib/mcast
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/include/*.h $(1)/usr/include/mcast/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/libmcastfapi.so $(1)/usr/lib/mcast/
endef

# To ipkg / Rootfs
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)$(VENDOR_PATH)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libmcastfapi.so $(1)$(VENDOR_PATH)/usr/lib/
	$(INSTALL_DIR) $(STAGING_DIR)/usr/docs
	$(CP) $(PKG_BUILD_DIR)/include/fapi_mcast.h $(STAGING_DIR)/usr/docs/.
endef

define Build/Clean
	if [ -d $(PKG_BUILD_DIR) ]; then $(MAKE) -C $(PKG_BUILD_DIR) clean; \
	$(RM) -r $(PKG_BUILD_DIR)/ipkg-$(BOARD); fi
endef

$(eval $(call KernelPackage,mcast-helper))
$(eval $(call KernelPackage,mcast-snooping))
$(eval $(call BuildPackage,$(PKG_NAME)))
