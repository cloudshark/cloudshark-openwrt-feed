#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cshark-luci
PKG_VERSION:=2014-05-15
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/cshark-luci
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Cloudshark capture tool web ui
  URL:=http://www.cloudshark.org/
  DEPENDS:=+cshark
endef

define Package/cshark-luci/description
 This package will install cshark luci web ui.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/cshark-luci/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_BIN) \
		./files/controller/cshark.lua \
		$(1)/usr/lib/lua/luci/controller/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/
	$(INSTALL_BIN) \
		./files/view/cshark.htm \
		$(1)/usr/lib/lua/luci/view/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_BIN) \
		./files/model/cbi/cshark.lua \
		$(1)/usr/lib/lua/luci/model/cbi/
endef

$(eval $(call BuildPackage,cshark-luci))
