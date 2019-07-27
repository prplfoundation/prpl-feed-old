include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-cpe-logger
PKG_VERSION:=0.2.0
PKG_MD5SUM:=7c313e5028b2bdc22aed84e5e3f65e62
PKG_RELEASE:=1
PKG_BASE_NAME:=dsl_cpe_logger
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

DSL_MAX_DEVICE=$(strip $(subst ",, $(CONFIG_VRX_MAX_DEVICE)))
DSL_LINES_PER_DEVICE=$(strip $(subst ",, $(CONFIG_VRX_LINES_PER_DEVICE)))
DSL_CHANNELS_PER_LINE=$(strip $(subst ",, $(CONFIG_VRX_CHANNELS_PER_LINE)))
DSL_NETLINK_ID=$(strip $(subst ",, $(CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID)))
DSL_TOTAL_ENTITIES:=$(shell echo $$[$(DSL_MAX_DEVICE)*$(DSL_LINES_PER_DEVICE)])

ifeq ($(DSL_MAX_DEVICE),)
	DSL_MAX_DEVICE=1
endif

ifeq ($(DSL_LINES_PER_DEVICE),)
	DSL_LINES_PER_DEVICE=1
endif

ifeq ($(DSL_CHANNELS_PER_LINE),)
	DSL_CHANNELS_PER_LINE=1
endif

ifeq ($(DSL_NETLINK_ID),)
	DSL_NETLINK_ID=28
endif

define Package/dsl-cpe-logger
  SECTION:=application
  CATEGORY:=Intel
  SUBMENU:=DSL Subsystem
  TITLE:=DSL CPE Debug Logger Application
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel Beteiligungs-GmbH & Co. KG
  DEPENDS:=+libnl +librt +dsl-cpe-mei-vrx
  MENU:=1
endef

define Package/dsl-cpe-logger/description
	This package contains the DSL CPE Debug Logger Application.
endef

CONFIGURE_ARGS += \
	--with-max-device="$(DSL_MAX_DEVICE)" \
	--with-lines-per-device="$(DSL_LINES_PER_DEVICE)" \
	--with-channels-per-line="$(DSL_CHANNELS_PER_LINE)"

ifdef CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID
CONFIGURE_ARGS += \
	--with-dbg-netlink-id="$(DSL_NETLINK_ID)"
endif

define Build/Configure
	# remove "configured" stamps of other configs
	@- rm $(PKG_BUILD_DIR)/.configured*
	$(call Build/Configure/Default)
endef

define Package/dsl-cpe-logger/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dsl_cpe_logger $(1)/bin
endef

$(eval $(call BuildPackage,dsl-cpe-logger))
