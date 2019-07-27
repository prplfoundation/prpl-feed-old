include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-cpe-control-vrx
PKG_SOURCE_VERSION:=4.21.1
PKG_RELEASE:=1
PKG_BASE_NAME:=dsl_cpe_control_vrx
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/prplfoundation/intel_dsl_cpe_control.git

DSL_BIN_DIR=$(VENDOR_PATH)/bin
DSL_INITD_DIR=$(VENDOR_PATH)/etc/init.d
DSL_FW_DIR=$(VENDOR_PATH)/firmware

ifeq (y,$(CONFIG_dsl-cpe-mei-vrx_DTM_STANDALONE))
	STARTSEQ = 22
endif

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

DSL_NETLINK_ID=$(strip $(subst ",, $(CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID)))

ifeq ($(DSL_NETLINK_ID),)
	DSL_NETLINK_ID=28
endif

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) ( \
		grep '^CONFIG_dsl-cpe-control-vrx' $(TOPDIR)/.config; \
		grep '^CONFIG_DSL_' $(TOPDIR)/.config; \
		grep '^CONFIG_VRX_' $(TOPDIR)/.config; \
		grep '^CONFIG_VRX320_' $(TOPDIR)/.config; \
		grep '^CONFIG_dsl-cpe-control-vrx_DTM_' $(TOPDIR)/.config; \
		grep '^CONFIG_PTM_VECTORING' $(LINUX_DIR)/.config) | md5s)
endif

define Package/dsl-cpe-control-vrx
  SECTION:=intel
  CATEGORY:=Intel
  SUBMENU:=DSL Subsystem
  TITLE:=DSL CPE control application for VRX Family
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  PROVIDES:=+dsl-cpe-control
  DEPENDS:=+libugwhelper +dsl-cpe-api-vrx +libpthread +librt +PACKAGE_safeclibs:safeclibs +dsl-cpe-control-vrx_DSL_JSON_PARSING:+libjson-c
  MENU:=1
endef

define Package/dsl-cpe-control-vrx/description
	This package contains the DSL CPE control application.

	Supported Devices:
		- VRX200 Family
		- VRX300 Family
endef

define Package/dsl-cpe-control-vrx/config
source "$(SOURCE)/Config.in"
endef

CONFIGURE_ARGS += \
	--enable-vrx \
	--enable-driver-include="-I$(STAGING_DIR)/usr/include/drv_dsl_cpe_api" \
	--enable-device-driver-include="-I$(STAGING_DIR)/usr/include" \
	--enable-ifxos \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-I$(STAGING_DIR)/usr/lib" \
	--enable-dsl-ceoc=no

ifdef CONFIG_dsl-cpe-mei-vrx_DSL_NETLINK_ID
	CONFIGURE_ARGS += \
	--enable-debug-logger-support \
	--with-dbg-netlink-id="$(DSL_NETLINK_ID)"
endif

ifeq ($(CONFIG_dsl-cpe-control-vrx_DTI),y)
CONFIGURE_ARGS += \
	--enable-dti=yes
CONFIGURE_ARGS += \
	--enable-dti-include="-I$(STAGING_DIR)/usr/include/dti" \
	--enable-dti-library="-L$(STAGING_DIR)/usr/lib"
else
CONFIGURE_ARGS += --enable-dti=no
endif

CONFIGURE_ARGS += \
	--enable-cli-support

ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR9),y)
	CONFIGURE_ARGS += --enable-vrx-device=vr9
else ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR10),y)
	CONFIGURE_ARGS += --enable-vrx-device=vr10
else ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR10_320),y)
	CONFIGURE_ARGS += --enable-vrx-device=vr10_320
else ifeq ($(CONFIG_dsl-cpe-mei-vrx_DEVICE_VR11),y)
	CONFIGURE_ARGS += --enable-vrx-device=vr11
else
	CONFIGURE_ARGS += --enable-vrx-device=vr9
endif

NUM_PIPES:=1
ifeq ($(CONFIG_dsl-cpe-control-vrx_MODEL_LITE),y)
	CONFIGURE_ARGS += --enable-model=lite
	APP_BILD_MODEL="lite"
else ifeq ($(CONFIG_dsl-cpe-control-vrx_MODEL_FOOTPRINT),y)
	CONFIGURE_ARGS += --enable-model=footprint
	APP_BILD_MODEL="footprint"
else ifeq ($(CONFIG_dsl-cpe-control-vrx_MODEL_TYPICAL),y)
	CONFIGURE_ARGS += --enable-model=typical
	APP_BILD_MODEL="typical"
else ifeq ($(CONFIG_dsl-cpe-control-vrx_MODEL_FULL),y)
	CONFIGURE_ARGS += --enable-model=full
	APP_BILD_MODEL="full"
else ifeq ($(CONFIG_dsl-cpe-control-vrx_MODEL_DEBUG),y)
	CONFIGURE_ARGS += --enable-model=debug
	# In case of debug compilation number of pipes is increased
	NUM_PIPES:=2
	APP_BILD_MODEL="debug"
else
	CONFIGURE_ARGS += --enable-model=footprint
	APP_BILD_MODEL="footprint"
endif

CONFIGURE_ARGS += --enable-add-appl-cflags="-DMAX_CLI_PIPES=$(NUM_PIPES)"

ifeq ($(CONFIG_dsl-cpe-control-vrx_USE_ADDITIONAL_BUILD_OPTIONS),y)
	CONFIGURE_ARGS += $(CONFIG_dsl-cpe-control-vrx_ADDITIONAL_BUILD_OPTIONS)
endif

ifeq ($(CONFIG_dsl-cpe-control-vrx_USE_DSL_ADD_EXT_APPL_CFLAGS),y)
CONFIGURE_ARGS += --enable-add_ext_appl_cflags=$(CONFIG_dsl-cpe-control-vrx_DSL_ADD_EXT_APPL_CFLAGS)
endif

ifdef CONFIG_PACKAGE_dsl-cpe-dti-agent
CONFIGURE_ARGS += --enable-dti-agent-st-alone-support
endif

ifeq ($(CONFIG_PACKAGE_safeclibs),y)
CONFIGURE_ARGS += \
	--enable-safec-support=yes \
	--enable-safec-include="-I$(STAGING_DIR)/usr/include" \
	--enable-safec-library="-L$(STAGING_DIR)/usr/lib"
endif

ifeq ($(CONFIG_dsl-cpe-control-vrx_DSL_JSON_PARSING),y)
CONFIGURE_ARGS += \
	--enable-libjson-c-support=yes \
	--enable-libjson-c-include="-I$(STAGING_DIR)/usr/include/json-c/" \
	--enable-libjson-c-library="-L$(STAGING_DIR)/usr/lib/"
endif

define Build/Configure
	@- rm $(PKG_BUILD_DIR)/.configured*
	$(call Build/Configure/Default)
endef

define Package/dsl-cpe-control-vrx/install
	$(INSTALL_DIR) $(1)/$(DSL_INITD_DIR)
	$(INSTALL_BIN) ./files/ltq_dsl_fw_dbg.sh $(1)/$(DSL_INITD_DIR)
	$(SED) "s:@dsl_bin_dir@:$(DSL_BIN_DIR):g" $(1)/$(DSL_INITD_DIR)/ltq_dsl_fw_dbg.sh
	$(SED) "s:@dsl_fw_dir@:$(DSL_FW_DIR):g" $(1)/$(DSL_INITD_DIR)/ltq_dsl_fw_dbg.sh

	$(INSTALL_BIN) ./files/ltq_cpe_control_init.sh $(1)/$(DSL_INITD_DIR)
	$(SED) "s:@dsl_bin_dir@:$(DSL_BIN_DIR):g" $(1)/$(DSL_INITD_DIR)/ltq_cpe_control_init.sh
	$(SED) "s:@dsl_fw_dir@:$(DSL_FW_DIR):g" $(1)/$(DSL_INITD_DIR)/ltq_cpe_control_init.sh
	$(SED) "s:@model_name@:$(MODEL_NAME):g" $(1)/$(DSL_INITD_DIR)/ltq_cpe_control_init.sh

ifeq ($(CONFIG_dsl-cpe-mei-vrx_DTM_STANDALONE),y)
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ltq_cpe_control_init_standalone.sh $(1)/etc/init.d/
	$(SED) "s:@dsl_init_dir@:$(DSL_INITD_DIR):g" $(1)/etc/init.d/ltq_cpe_control_init_standalone.sh
	$(SED) "s:@start_seq@:$(STARTSEQ):g" $(1)/etc/init.d/ltq_cpe_control_init_standalone.sh
endif

	$(INSTALL_DIR) $(1)/etc/profile.d
	$(INSTALL_BIN) ./files/alias_dsl_cpe.sh $(1)/etc/profile.d/
	$(SED) "s:@dsl_bin_dir@:$(DSL_BIN_DIR):g" $(1)/etc/profile.d/alias_dsl_cpe.sh

	$(INSTALL_DIR) $(1)/$(DSL_BIN_DIR)

ifeq ($(DSL_LINES_PER_DEVICE),1)
	$(INSTALL_DATA) ./files/adsl.scr $(1)/$(DSL_BIN_DIR)
	$(INSTALL_DATA) ./files/vdsl.scr $(1)/$(DSL_BIN_DIR)
else
	$(INSTALL_DATA) ./files/adsl_bonding.scr $(1)/$(DSL_BIN_DIR)/adsl.scr
	$(INSTALL_DATA) ./files/vdsl_bonding.scr $(1)/$(DSL_BIN_DIR)/vdsl.scr
endif

	# Copy configuration files to rootfs
	@- [ -e ./files/dsl_auto_app.cfg ] && $(INSTALL_DATA) ./files/dsl_auto_app.cfg $(1)/$(DSL_BIN_DIR)

	# Set common variables within DSL config file
	$(SED) "s:@num_dsl_pipes@:$(NUM_PIPES):g" $(1)/$(DSL_BIN_DIR)/dsl_auto_app.cfg;
	$(SED) "s:@app_build_model@:$(APP_BILD_MODEL):g" $(1)/$(DSL_BIN_DIR)/dsl_auto_app.cfg;

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/dsl_cpe_control $(1)/$(DSL_BIN_DIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tools/pipe/dsl_cpe_pipe $(1)/$(DSL_BIN_DIR)
	ln -snf dsl_cpe_pipe $(1)/$(DSL_BIN_DIR)/dsl_cpe_pipe.sh

	$(if $(CONFIG_LANTIQ_OPENWRT_FIRMWARE), \
                $(INSTALL_DIR) $(1)/etc/init.d/; \
                $(INSTALL_BIN) ./files/xdsl.init $(1)/etc/init.d/xdsl; \
                $(SED) "s:@dsl_bin_dir@:$(DSL_BIN_DIR):g" $(1)/etc/init.d/xdsl; \
                $(SED) "s:@dsl_dir@:$(VENDOR_PATH):g" $(1)/etc/init.d/xdsl; \
        )
endef

$(eval $(call BuildPackage,dsl-cpe-control-vrx))
