include $(TOPDIR)/rules.mk

PKG_VERSION:=20250630
PKG_RELEASE:=1
PKG_NAME:=luci-app-softethervpn

# 高版本24.10.4的sdk会增加依赖luci-lua-runtime导致低版本系统装不上ipk，建议22.03.7
LUCI_TITLE:=LuCI support for SoftetherVPN
LUCI_DEPENDS:=+libc
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/softethervpn
endef

# 安装前脚本
# define Package/$(PKG_NAME)/preinst
# endef

# 安装后脚本，可以配置权限等但不建议
# define Package/$(PKG_NAME)/postinst
# #!/bin/sh
# chmod 0755 /etc/init.d/luci_softethervpnserver
# /etc/init.d/softethervpnbridge disable 2>/dev/null
# /etc/init.d/softethervpnbridge stop >/dev/null 2>&1
# /etc/init.d/softethervpnclient disable 2>/dev/null
# /etc/init.d/softethervpnclient stop >/dev/null 2>&1
# /etc/init.d/softethervpnserver disable 2>/dev/null
# /etc/init.d/softethervpnserver stop >/dev/null 2>&1
# exit 0
# endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
