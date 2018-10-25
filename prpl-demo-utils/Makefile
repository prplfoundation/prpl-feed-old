include $(TOPDIR)/rules.mk

PKG_NAME:=prpl-demo-utils
PKG_VERSION:=1.0.0
PKG_RELEASE:=0

include $(INCLUDE_DIR)/package.mk

define Package/prpl-demo-utils
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Prpl Demo Tools
  DEPENDS:=+iwinfo_wave +rpcd +ubus +uci
endef

define Package/prpl-demo-utils/description
	This package contains tools for PrplWrt demo
endef

define Build/Compile
	true
endef

define Package/prpl-demo-utils/install
	cp -r ./files/*  $(1)/
endef

$(eval $(call BuildPackage,prpl-demo-utils))
