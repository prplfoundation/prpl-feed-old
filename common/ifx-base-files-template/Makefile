include $(TOPDIR)/rules.mk

PKG_NAME:=ifx-base-files-template
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/ifx-base-files-template
  SUBMENU:=Base Files
  SECTION:=base
  CATEGORY:=Intel
  TITLE:=Base files for the template board.
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+ifx-base-files-common @BROKEN
endef

define Package/ifx-base-files-template/description
 This package contains files and system scripts for OpenWrt,
 required for the template board.
endef

Build/Prepare=
Build/Compile=

define Package/ifx-base-files-template/install
	[ -d ./files ] && $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ifx-base-files-template))

