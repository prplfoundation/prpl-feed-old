include $(TOPDIR)/rules.mk

PKG_NAME:=uci_test
PKG_RELEASE:=1
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS=libuci uci

include $(INCLUDE_DIR)/package.mk

define Package/uci_test
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Test UCI library
  DEPENDS:=+uci +libuci
endef

define Package/uci_test/description
 This package contains a test suite for UCI
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

Build/Configure=

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -Wall -I$(STAGING_DIR)/usr/include" \
		LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib"
endef

define Package/uci_test/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/uci_test $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,uci_test))
