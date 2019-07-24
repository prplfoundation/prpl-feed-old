#
# Copyright (C) 2009 OpenWrt.org
# Copyright (C) 2014 lantiq.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=ltq-acli
PKG_VERSION:=0.0.0.21
PKG_MD5SUM:=af7bf93d6ab149d149b4022de0cb6cf6
PKG_RELEASE:=1

PKG_SOURCE:=acli-$(PKG_VERSION).tar.gz
PKG_SOURCE_DIR:=$(BUILD_DIR)/acli-$(PKG_VERSION)
PKG_BUILD_DIR:=$(PKG_SOURCE_DIR)
PKG_BUILD_DEPENDS:=+libreadline +libncurses
PKG_SOURCE_URL:=http://localhost
LANTIQ_BIN_DIR=/opt/lantiq/bin
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

PKG_FIXUP:=autoreconf

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=application
  CATEGORY:=Lantiq
  TITLE:=Autocompletion CLI
  URL:=http://www.lantiq.com/
  MAINTAINER:=Lantiq GmbH
  DEPENDS:=+libreadline +libncurses
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	Autocompletion CLI
endef

define Package/$(PKG_NAME)/config
$(call Package/$(PKG_NAME)/override_version)
$(call Package/$(PKG_NAME)/override_source_path)
	source "$(SOURCE)/config/Config.in"
endef

CONFIGURE_ARGS += \
	--enable-warnings

ifneq ($(CONFIG_LANTIQ_ACLI_USER_FLAGS),"")
ACLI_USER_CFLAGS=$(strip $(subst ",, $(CONFIG_LANTIQ_ACLI_USER_FLAGS)))
CONFIGURE_ARGS += --with-cflags="$(ACLI_USER_CFLAGS)"
endif

ifneq ($(CONFIG_LANTIQ_ACLI_PIPE_NAME),"")
ACLI_PIPE_NAME=$(strip $(subst ",, $(CONFIG_LANTIQ_ACLI_PIPE_NAME)))
CONFIGURE_ARGS += --with-pipe=$(ACLI_PIPE_NAME)
endif

ifneq ($(CONFIG_LANTIQ_ACLI_USER_OPTIONS),"")
CONFIGURE_ARGS += $(subst ",, $(CONFIG_LANTIQ_ACLI_USER_OPTIONS))
endif

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)$(LANTIQ_BIN_DIR)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/acli $(1)$(LANTIQ_BIN_DIR)
	$(INSTALL_DIR) $(1)/usr/sbin
	ln -snf ../..$(LANTIQ_BIN_DIR)/acli $(1)/usr/sbin/

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
