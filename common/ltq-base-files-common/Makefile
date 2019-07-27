include $(TOPDIR)/rules.mk

PKG_NAME:=ltq-base-files-common
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/ltq-base-files-common
  SUBMENU:=Base Files
  SECTION:=base
  CATEGORY:=Intel
  TITLE:=Common files for Lantiq systems
  URL:=http://www.lantiq.com/
  MAINTAINER:=Intel
endef

define Package/ltq-base-files-common/description
 This package contains files and system scripts for OpenWrt,
 common for all Lantiq targets.
endef

Build/Prepare=
Build/Compile=

define Package/ltq-base-files-common/install
	$(CP) ./files/* $(1)/
	$(SED) 's,$$$$R,$(REVISION),g' $(1)/etc/banner
endef

$(eval $(call BuildPackage,ltq-base-files-common))
