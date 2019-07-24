#
# Copyright (C) 2011 OpenWrt.org
# Copyright (C) 2011 lantiq.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dsl-gfast-api-vrx618
PKG_RELEASE:=1
PKG_BASE_NAME:=lib_gfast_api
PKG_VERSION:=5.0.4
PKG_SOURCE:=$(PKG_BASE_NAME)_vrx618-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)_vrx618/lib_dsl_api-$(PKG_VERSION)
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DEPENDS:=ifxos kmod-dsl-gfast-drv-pmi lib-dti\
	DSL_CO_MELT:ifx-melt-lib
PKG_FIXUP:=libtool
PKG_INSTALL:=1
include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_DSL_GFAST' $(TOPDIR)/.config | md5s)
endif

LTQ_BIN_DIR=opt/lantiq/bin
DSL_BOARD_TYPE=$(strip $(subst ",, $(CONFIG_DSL_GFAST_BOARD_TYPE)))
DSL_MAX_DEVICE=$(strip $(subst ",, $(CONFIG_DSL_GFAST_MAX_DEVICE_VRX618)))
DSL_LINES_PER_DEVICE=$(strip $(subst ",, $(CONFIG_DSL_GFAST_LINES_PER_DEVICE_VRX618)))
DSL_CHANNELS_PER_LINE=$(strip $(subst ",, $(CONFIG_DSL_GFAST_CHANNELS_PER_LINE_VRX618)))
DSL_MAX_PROFILE=$(strip $(subst ",, $(CONFIG_DSL_GFAST_MAX_PROFILE_VRX618)))

define Package/$(PKG_BASE_NAME)/Default
  CATEGORY:=Lantiq
  SUBMENU:=DSL Subsystem
  TITLE:=DSL G.FAST API
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq Deutschland GmbH
  MENU:=1
endef

define Package/$(PKG_BASE_NAME)/Default/description
	Lantiq DSL CO G.FAST API for VRX618.
endef

define Package/$(PKG_NAME)
$(call Package/$(PKG_BASE_NAME)/Default)
  SECTION:=application
  TITLE+= VRX618
  DEPENDS:=+ifxos +kmod-dsl-gfast-drv-pmi +lib-dti +librt +lib-cli
endef

define Package/$(PKG_NAME)/description
	This package contains the VRX618 adaptation.
endef

define Package/$(PKG_NAME)/config
	menu "configuration"
	depends on PACKAGE_$(PKG_NAME)
		source "$(SOURCE)/config/Config.in"
	endmenu
	$(call Package/$(PKG_NAME)/override_version)
	$(call Package/$(PKG_NAME)/override_source_path)
endef

# make the submake silent:
ifeq ($(QUIET),1)
MAKE_FLAGS+=-s
endif
ifneq (,$(findstring 99,$(V)))
MAKE_FLAGS+=-s
endif

ifeq ($(DSL_MAX_DEVICE),)
# default values, if CONFIG_DSL_xxx is not used
DSL_MAX_DEVICE=1
DSL_LINES_PER_DEVICE=1
DSL_CHANNELS_PER_LINE=1
DSL_MAX_PROFILE=8
endif

ifeq ($(DSL_BOARD_TYPE),)
DSL_BOARD_TYPE=UNDEFINED
endif

ifeq ($(CONFIG_DSL_GFAST_NO_MELT_VRX618),y)
DSL_CO_ENABLE_MELT:=
endif

ifeq ($(CONFIG_DSL_GFAST_EXTERNAL_MELT_VRX618),y)
DSL_CO_ENABLE_MELT:=--enable-melt-include=-I$(STAGING_DIR)/usr/include/melt --enable-melt-library=-L$(STAGING_DIR)/usr/lib
endif


CONFIGURE_ARGS += \
	$(DSL_CO_ENABLE_MELT) \
	--enable-finaxdp \
	--enable-g997 \
	--with-max-device="$(DSL_MAX_DEVICE)" \
	--with-lines-per-device="$(DSL_LINES_PER_DEVICE)" \
	--with-channels-per-line="$(DSL_CHANNELS_PER_LINE)" \
	--with-max-profile="$(DSL_MAX_PROFILE)" \
	--enable-board-type="BOARD_$(DSL_BOARD_TYPE)" \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib"  \
	--enable-kernelincl="$(LINUX_DIR)/include" \
	--enable-comfort-api=no \
	--enable-ohc-queue 

CONFIGURE_ARGS += \
	--enable-dsl-daemon-callback-event-handling \
	--enable-lib-cli=yes \
	--enable-cli-include="-I$(STAGING_DIR)/usr/include/cli" \
	--enable-cli-library="-L$(STAGING_DIR)/usr/lib/cli" 

ifdef CONFIG_PACKAGE_kmod-dsl-gfast-drv-pmi
CONFIGURE_ARGS += --enable-dsl-driver-include="-I$(STAGING_DIR)/usr/include/pmi"
endif

ifdef CONFIG_PACKAGE_lib-dti
CONFIGURE_ARGS += \
	--enable-dti-support=yes \
	--enable-dti-include="-I$(STAGING_DIR)/usr/include/dti -I$(STAGING_DIR)/usr/include/pmi" \
	--enable-dti-library="-L$(STAGING_DIR)/usr/lib/"
endif

ifeq ($(CONFIG_DSL_GFAST_LIBRARY_ONLY),y)
CONFIGURE_ARGS += \
	--enable-library-only=yes
endif

ifeq ($(CONFIG_DSL_GFAST_DEBUG_FEATURES),y)
CONFIGURE_ARGS += \
	--enable-test-suite=yes\
   --enable-dsl-pm-tif=yes
#	--enable-test-db=yes
#   --with-dsl-pm-debug-mode=1
endif


EXTRA_CFLAGS = -DINCLUDE_DSL_BOARD_REBOOT -DDSL_BPT_CLI_NUM_ERR_POINTS=64 -D_FORTIFY_SOURCE=2
EXTRA_LDFLAGS = -z noexecstack -z relro -z now

define Build/Clean
	@- [ -e $(PKG_BUILD_DIR)/ipkg* ] && rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/dsl_api_vrx618
	$(CP) $(PKG_BUILD_DIR)/src/include/* $(1)/usr/include/dsl_api_vrx618
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/src/lib_dsl_api.a $(1)/usr/lib
ifeq ($(CONFIG_DSL_GFAST_LIBRARY_ONLY),y)
else
	$(CP) $(PKG_BUILD_DIR)/application/dsl_daemon/src/lib_dsl_daemon.a $(1)/usr/lib
endif
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(LTQ_BIN_DIR)
ifeq ($(CONFIG_DSL_GFAST_LIBRARY_ONLY),y)
else
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/application/dsl_daemon/src/dsl_daemon $(1)/$(LTQ_BIN_DIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/application/dsl_pipe/src/dsl_pipe $(1)/$(LTQ_BIN_DIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/alias_dsl.sh $(1)/$(LTQ_BIN_DIR)
endif
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/config_dms.sh $(1)/etc/init.d
	$(CP) ./files/opt/lantiq/bin/* $(1)/$(LTQ_BIN_DIR)
#	ln -snf /tmp $(1)/$(LTQ_BIN_DIR)/memdump
#	ln -snf /tmp $(1)/$(LTQ_BIN_DIR)/dbgstream
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
