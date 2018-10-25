#
# Copyright (C) 2014-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libwebsockets
PKG_VERSION:=2.4.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/warmcat/libwebsockets.git
PKG_SOURCE_VERSION:=5b74d7108b5cfcc3a6ee3dcad521e0f0c3a18d0c
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.xz

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

PKG_LICENSE:=LGPL-2.1+exception
PKG_LICENSE_FILES:=LICENSE

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/$(PKG_NAME)
	SECTION:=libs
	CATEGORY:=Libraries
	TITLE:=libwebsockets
	DEPENDS:=+zlib \
		+$(PKG_NAME)_SSL_OpenSSL:libopenssl \
		+$(PKG_NAME)_SSL_CyaSSL:libcyassl \
		+$(PKG_NAME)_SSL_mbedTLS:libmbedtls \
		+$(PKG_NAME)_Full:libcap \
		+$(PKG_NAME)_Full:libuv \
		+$(PKG_NAME)_Full:libopenssl

	URL:=https://libwebsockets.org
	MAINTAINER:=Karl Palsson <karlp@remake.is>
endef

define Package/$(PKG_NAME)/config
	choice $(PKG_NAME)_SSL
		prompt "SSL support"
		depends on PACKAGE_$(PKG_NAME)
		default $(PKG_NAME)_Full

			config $(PKG_NAME)_SSL_none
				bool "no"

			config $(PKG_NAME)_SSL_OpenSSL
				bool "use OpenSSL library"

			config $(PKG_NAME)_SSL_CyaSSL
				bool "use CyaSSL library"

			config $(PKG_NAME)_SSL_mbedTLS
				bool "use mbedTLS library"

			config $(PKG_NAME)_Full
				bool "full - OpenSSL, libuv, plugins, CGI"

	endchoice
endef

CMAKE_OPTIONS += -DLWS_IPV6=$(if $(CONFIG_IPV6),ON,OFF)
CMAKE_OPTIONS += -DLWS_WITHOUT_TESTAPPS=ON

# other options worth noting
# CMAKE_OPTIONS += -DLWS_WITHOUT_EXTENSIONS=ON
# CMAKE_OPTIONS += -DLWS_WITHOUT_DAEMONIZE=ON
# CMAKE_OPTIONS += -DLWS_WITHOUT_SERVER=ON
# CMAKE_OPTIONS += -DLWS_WITHOUT_DEBUG=ON

ifeq ($(CONFIG_$(PKG_NAME)_SSL_none),y)
	CMAKE_OPTIONS += -DLWS_WITH_SSL=OFF
else
	CMAKE_OPTIONS += -DLWS_WITH_SSL=ON
endif

ifeq ($(CONFIG_$(PKG_NAME)_SSL_OpenSSL),y)
	CMAKE_OPTIONS += -DLWS_OPENSSL_SUPPORT=ON
	CMAKE_OPTIONS += -DLWS_OPENSSL_CLIENT_CERTS=/etc/ssl/certs
endif

ifeq ($(CONFIG_$(PKG_NAME)_SSL_CyaSSL),y)
	CMAKE_OPTIONS += -DLWS_OPENSSL_SUPPORT=ON
	CMAKE_OPTIONS += -DLWS_OPENSSL_CLIENT_CERTS=/etc/ssl/certs
# for cyassl, edit package/libs/cyassl/Makefile to include --enable-opensslextra
# NOTE: it will compile without it, untested whether it it's needed?!
	CMAKE_OPTIONS += -DLWS_WITH_CYASSL=ON
	CMAKE_OPTIONS += -DLWS_CYASSL_LIBRARIES=$(STAGING_DIR)/usr/lib/libcyassl.so
	CMAKE_OPTIONS += -DLWS_CYASSL_INCLUDE_DIRS=$(STAGING_DIR)/usr/include
endif

ifeq ($(CONFIG_$(PKG_NAME)_SSL_mbedTLS),y)
	CMAKE_OPTIONS += -DLWS_OPENSSL_SUPPORT=ON
	CMAKE_OPTIONS += -DLWS_OPENSSL_CLIENT_CERTS=/etc/ssl/certs
	CMAKE_OPTIONS += -DLWS_WITH_MBEDTLS=ON
endif

ifeq ($(CONFIG_$(PKG_NAME)_Full),y)
    CMAKE_OPTIONS += -DLWS_OPENSSL_CLIENT_CERTS=/etc/ssl/certs
    CMAKE_OPTIONS += -DLWS_OPENSSL_SUPPORT=ON
    CMAKE_OPTIONS += -DLWS_WITH_SSL=ON
    CMAKE_OPTIONS += -DLWS_WITH_LIBUV=ON
    CMAKE_OPTIONS += -DLWS_WITH_PLUGINS=ON
    CMAKE_OPTIONS += -DLWS_WITH_SERVER_STATUS=ON
    CMAKE_OPTIONS += -DLWS_WITH_ACCESS_LOG=ON
    CMAKE_OPTIONS += -DLWS_WITH_CGI=ON
endif

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
