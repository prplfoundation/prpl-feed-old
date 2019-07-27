include $(TOPDIR)/rules.mk

PKG_NAME:=lq-base-files-common
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/lq-base-files-common
  SUBMENU:=Base Files
  SECTION:=base
  CATEGORY:=Intel
  TITLE:=Common files for Lantiq systems (transitional package)
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
  DEPENDS:=+ltq-base-files-common
endef

define Package/lq-base-files-common/description
 This package is only transitional to help renaming to ltq-base-files-common.
 Can be unselected/removed later.
endef

Build/Prepare=
Build/Compile=
Package/lq-base-files-common/install=

$(eval $(call BuildPackage,lq-base-files-common))
