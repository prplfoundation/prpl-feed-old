include $(TOPDIR)/rules.mk

PKG_NAME:=juci

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://dev.iopsys.eu/iopsys/juci.git
PKG_SOURCE_VERSION:=20b572119683f63fd3929f69543f0519254636b2
PKG_VERSION:=2019-06-06
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

PKG_RELEASE=$(PKG_VERSION)-$(PKG_SOURCE_VERSION)

PKG_LICENSE:=GPL
PKG_LICENSE_FILES:=

include $(INCLUDE_DIR)/package.mk

define Package/juci
  $(Package/juci/default)
  SECTION:=juci
  CATEGORY:=JUCI
  MENU=1
  TITLE:=JUCI Core Package (select this to select default plugins)
  DEPENDS:=+libubox +libubus +owsd +rpcd +rpcd-mod-file +questd
endef

define Build/InstallDev 
	$(INSTALL_DIR) $(1)/usr/src/
	ln -s $(PKG_BUILD_DIR) $(1)/usr/src/juci
endef 

define Build/Compile
	$(call Build/Compile/Default,THEME_PATH="$(TOPDIR)/themes/")
endef

define Package/juci/description
 JUCI Javascript UCI Web interface.
endef

define Package/juci/install
	$(INSTALL_DIR) $(1)/
	$(CP) $(PKG_BUILD_DIR)/bin/juci/* $(1)/
	$(INSTALL_DIR) $(1)/www/cgi-bin/
	$(INSTALL_DIR) $(1)/sbin/
	$(INSTALL_DIR) $(1)/etc/
	$(CP) ./files/etc/* $(1)/etc/
endef

define Package/juci/postinst
#!/bin/sh

juci-update
exit 0
endef

$(eval $(call BuildPackage,juci))

####### Extensions / Themes and Plugins

define RegisterAddonInner
define Package/$(2)
	SECTION:=juci
	CATEGORY:=JUCI
	TITLE:=default
	SUBMENU:=$(1)
	TITLE:=$(if $(3),$(3),JUCI $(2) plugin)
	DEPENDS:=$(4)
endef

define Package/$(2)/install
	$(INSTALL_DIR) $$(1)/
	$(CP) $(PKG_BUILD_DIR)/bin/$(2)/* $$(1)/
endef
endef

define RegisterAddon
	$(eval $(call RegisterAddonInner,$(1),$(2),$(3),$(4),$(5)))
	$(eval $(call BuildPackage,$(2)))
endef

$(eval $(call RegisterAddon,Plugins,juci-ddns, DDNS Configuration,+ddns-scripts))
$(eval $(call RegisterAddon,Plugins,juci-diagnostics, Simple Diagnostics,+busybox))
$(eval $(call RegisterAddon,Plugins,juci-dnsmasq-dhcp, DHCP/DNSMasq Configuration,+dnsmasq))
$(eval $(call RegisterAddon,Plugins,juci-dropbear, Dropbear Configuration,+dropbear))
$(eval $(call RegisterAddon,Plugins,juci-event, Event Module,+owsd))
$(eval $(call RegisterAddon,Plugins,juci-firewall-fw3, Firewall Configuration,+firewall))
$(eval $(call RegisterAddon,Plugins,juci-config-backup, Config Backup Module))
$(eval $(call RegisterAddon,Plugins,juci-qos, QoS module,+qos-scripts))
$(eval $(call RegisterAddon,Plugins,juci-minidlna, MiniDLNA Configuration,+minidlna))
$(eval $(call RegisterAddon,Plugins,juci-mcproxy, Multicast Proxy Configuration, +mcproxy))
$(eval $(call RegisterAddon,Plugins,juci-mod-status, Deprecated Status Reporting Module,+questd))
$(eval $(call RegisterAddon,Plugins,juci-mod-system, System Administration Module))
$(eval $(call RegisterAddon,Plugins,juci-mwan3, mwan3 Configuration,+mwan3))
$(eval $(call RegisterAddon,Plugins,juci-network-device, Network Device Configuration,+netifd))
$(eval $(call RegisterAddon,Plugins,juci-network-dsl, DSL Module,+dslmngr))
$(eval $(call RegisterAddon,Plugins,juci-network-netifd, netifd Module,+netifd))
$(eval $(call RegisterAddon,Plugins,juci-network-port, Ethernet Port Configuration,+port-management))
$(eval $(call RegisterAddon,Plugins,juci-openvpn, OpenVPN configuration,+openvpn))
$(eval $(call RegisterAddon,Plugins,juci-owsd, OWSD configuration,+owsd))
$(eval $(call RegisterAddon,Plugins,juci-printer, p910nd Printer Server Configuration,+p910nd))
$(eval $(call RegisterAddon,Plugins,juci-realtime-graphs, Realtime Graphs,+questd))
$(eval $(call RegisterAddon,Plugins,juci-samba, Samba Configuration,+samba3))
$(eval $(call RegisterAddon,Plugins,juci-snmpd, SNMP Module, +snmpd))
$(eval $(call RegisterAddon,Plugins,juci-sysupgrade, Sysupgrade Firmware Upgrade))
$(eval $(call RegisterAddon,Plugins,juci-upnp, UPnP Configuration Module,+miniupnpd))
$(eval $(call RegisterAddon,Plugins,juci-usb, USB Module,+questd))
$(eval $(call RegisterAddon,Plugins,juci-wireless, Wireless Management Module,+wifimngr))
$(eval $(call RegisterAddon,Themes,juci-theme-prpl))

####### dynamically publish themes as packages #######
$(foreach th,$(wildcard $(TOPDIR)/themes/*),$(eval $(call RegisterAddon,Themes,$(notdir $(th)))))
