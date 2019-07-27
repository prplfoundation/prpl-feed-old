include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-cpe-api-vrx
PKG_SOURCE_VERSION:=4.21.1
PKG_RELEASE:=1
PKG_INSTALL:=1
PKG_BASE_NAME:=drv_dsl_cpe_api_vrx
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/prplfoundation/intel_dsl_cpe_api.git
PKG_BUILD_DEPENDS:=dsl-cpe-mei-vrx

DSL_BIN_DIR=$(VENDOR_PATH)/bin
DSL_INITD_DIR=$(VENDOR_PATH)/etc/init.d

ifeq (y,$(CONFIG_dsl-cpe-mei-vrx_DTM_STANDALONE))
	STARTSEQ = 18
endif

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

ifneq ($(CONFIG_UBOOT_CONFIG_FIRMWARE_IN_ROOTFS)$(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR10_320),)
FIRMWARE_BIN=$(1)/lib/firmware
else
FIRMWARE_BIN=$(STAGING_DIR)/firmware/
endif

DSL_NETLINK_ID=$(strip $(subst ",, $(CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID)))

ifeq ($(DSL_NETLINK_ID),)
	DSL_NETLINK_ID=28
endif

define Package/dsl-cpe-api-vrx
	SECTION:=driver
	CATEGORY:=Intel
	SUBMENU:=DSL Subsystem
	TITLE:=DSL CPE API driver for VRX Family
	URL:=http://www.intel.com/
	MAINTAINER:=Intel Corporation
	DEPENDS:=+dsl-cpe-mei-vrx +kmod-dsl-cpe-api-vrx
	MENU:=1
endef

define KernelPackage/dsl-cpe-api-vrx
	SUBMENU:=Intel
	TITLE:=DSL CPE API driver for VRX Family
	URL:=http://www.lantiq.com/
	MAINTAINER:=Intel Beteiligungs-GmbH & Co. KG
	DEPENDS:=+kmod-dsl-cpe-mei-vrx
	KCONFIG:=CONFIG_LTQ_DSL_CPE_API_VRX=y
	FILES:=$(PKG_BUILD_DIR)/src/drv_dsl_cpe_api$(PKG_MODULE_EXTENSION)
	AUTOLOAD:=$(call AutoLoad,45,drv_dsl_cpe_api)
endef

define Package/dsl-cpe-api-vrx/description
	This package contains the Intel DSL CPE API driver.

	Supported Devices:
		- VRX200 Family
		- VRX300 Family
		- VRX500 Family
endef

define Package/dsl-cpe-api-vrx/config
$(call Package/dsl-cpe-api-vrx/override_version)
$(call Package/dsl-cpe-api-vrx/override_source_path)
source "$(SOURCE)/Config.in"
endef

define KernelPackage/dsl-cpe-api-vrx/description
	Intel DSL CPE API Kernel Module Driver
endef

CONFIGURE_ARGS += --enable-kernel-include="$(LINUX_DIR)/include"

ifdef CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID
CONFIGURE_ARGS += \
	--enable-debug-logger-support \
	--with-dbg-netlink-id="$(DSL_NETLINK_ID)"
endif

CONFIGURE_ARGS += --enable-vrx \
	--enable-ifxos \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-driver-include="-I$(STAGING_DIR)/usr/include" \
	--enable-add-drv-cflags="" \
	--enable-adsl-led=no \
	--enable-adsl-mib=no \
	--enable-dsl-ceoc=no

ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR9),y)
CONFIGURE_ARGS += --enable-vrx-device=vr9
CONFIGURE_ARGS += --enable-firmware-r9
else ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR10),y)
CONFIGURE_ARGS += --enable-vrx-device=vr10
CONFIGURE_ARGS += --enable-firmware-r9
else ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR10_320),y)
CONFIGURE_ARGS += --enable-vrx-device=vr10_320
CONFIGURE_ARGS += --enable-firmware-r9
else ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR11),y)
CONFIGURE_ARGS += --enable-vrx-device=vr11
else
CONFIGURE_ARGS += --enable-vrx-device=vr9
CONFIGURE_ARGS += --enable-firmware-r9
endif

ifeq ($(CONFIG_dsl-cpe-api-vrx_MODEL_LITE),y)
	CONFIGURE_ARGS += --enable-model=lite
	DRV_BILD_MODEL="lite"
else ifeq ($(CONFIG_dsl-cpe-api-vrx_MODEL_FOOTPRINT),y)
	CONFIGURE_ARGS += --enable-model=footprint
	DRV_BILD_MODEL="footprint"
else ifeq ($(CONFIG_dsl-cpe-api-vrx_MODEL_TYPICAL),y)
	CONFIGURE_ARGS += --enable-model=typical
	DRV_BILD_MODEL="typical"
else ifeq ($(CONFIG_dsl-cpe-api-vrx_MODEL_FULL),y)
	CONFIGURE_ARGS += --enable-model=full
	DRV_BILD_MODEL="full"
else ifeq ($(CONFIG_dsl-cpe-api-vrx_MODEL_DEBUG),y)
	CONFIGURE_ARGS += --enable-model=debug
	DRV_BILD_MODEL="debug"
else
	CONFIGURE_ARGS += --enable-model=footprint
	DRV_BILD_MODEL="footprint"
endif

ifeq ($(CONFIG_dsl-cpe-api-vrx_USE_ADDITIONAL_BUILD_OPTIONS),y)
	CONFIGURE_ARGS += $(CONFIG_dsl-cpe-api-vrx_ADDITIONAL_BUILD_OPTIONS)
endif

ifeq ($(CONFIG_dsl-cpe-api-vrx_USE_DSL_ADD_EXT_DRV_CFLAGS),y)
	API_DRV_CFLAGS += $(CONFIG_dsl-cpe-api-vrx_DSL_ADD_EXT_DRV_CFLAGS)
endif

ifeq ($(CONFIG_dsl-cpe-mei-vrx_PPA_NO),y)
	API_DRV_CFLAGS += -DDSL_DRV_ATM_PTM_INTERFACE_ENABLE=0
else
	API_DRV_CFLAGS += -DDSL_DRV_ATM_PTM_INTERFACE_ENABLE=1
endif

API_DRV_CFLAGS += -I$(STAGING_DIR)/include

CONFIGURE_ARGS += --enable-add_ext_drv_cflags="${API_DRV_CFLAGS}"

CONFIGURE_ARGS += --enable-linux-26 --enable-kernelbuild="$(LINUX_DIR)" ARCH=$(LINUX_KARCH)
PKG_MODULE_EXTENSION=.ko

ifeq ($(CONFIG_mips),y)
	EXTRA_CFLAGS = -fno-pic -mno-abicalls -mlong-calls -G 0
endif

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/drv_dsl_cpe_api
	$(CP) $(PKG_BUILD_DIR)/src/include/drv_dsl_cpe*.h $(1)/usr/include/drv_dsl_cpe_api/
endef

define Package/dsl-cpe-api-vrx/install
	$(INSTALL_DIR) $(1)/$(DSL_INITD_DIR)

	$(INSTALL_BIN) ./files/ltq_load_dsl_cpe_api.sh $(1)/$(DSL_INITD_DIR)
	$(SED) "s:@dsl_bin_dir@:$(DSL_BIN_DIR):g" $(1)/$(DSL_INITD_DIR)/ltq_load_dsl_cpe_api.sh

ifeq ($(CONFIG_dsl-cpe-mei-vrx_DTM_STANDALONE),y)
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ltq_load_dsl_cpe_api_standalone.sh $(1)/etc/init.d/
	$(SED) "s:@dsl_init_dir@:$(DSL_INITD_DIR):g" $(1)/etc/init.d/ltq_load_dsl_cpe_api_standalone.sh
	$(SED) "s:@start_seq@:$(STARTSEQ):g" $(1)/etc/init.d/ltq_load_dsl_cpe_api_standalone.sh
endif

	$(INSTALL_DIR) $(1)/$(DSL_BIN_DIR)

	# Copy configuration files to rootfs
	@- [ -e ./files/dsl_auto_api.cfg ] && $(INSTALL_DATA) ./files/dsl_auto_api.cfg $(1)/$(DSL_BIN_DIR)

	# Set common variables within DSL config file
	$(SED) "s:@drv_build_model@:$(DRV_BILD_MODEL):g" $(1)/$(DSL_BIN_DIR)/dsl_auto_api.cfg;

	$(INSTALL_BIN) ./files/inst_drv_dsl_cpe_api.sh $(1)/$(DSL_BIN_DIR)/
	$(SED) "s:@dsl_bin_dir@:$(DSL_BIN_DIR):g" $(1)/$(DSL_BIN_DIR)/inst_drv_dsl_cpe_api.sh
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/drv_dsl_cpe_api$(PKG_MODULE_EXTENSION) $(1)/$(DSL_BIN_DIR)
	$(INSTALL_DIR) $(1)/$(MODULES_SUBDIR)
	$(INSTALL_DIR) $(1)/$(DSL_BIN_DIR)
	ln -snf /$(MODULES_SUBDIR)/drv_dsl_cpe_api$(PKG_MODULE_EXTENSION) $(1)/$(DSL_BIN_DIR)/$(PKG_BASE_NAME)$(PKG_MODULE_EXTENSION)
endef

$(eval $(call BuildPackage,dsl-cpe-api-vrx))
$(eval $(call KernelPackage,dsl-cpe-api-vrx))
