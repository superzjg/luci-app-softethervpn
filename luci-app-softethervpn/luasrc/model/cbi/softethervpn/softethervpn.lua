-- 修改20250315 by superzjg@qq.com

local s = require"luci.sys"
local m, s, o

m = Map("softethervpn")
m.title = translate("SoftEther VPN Service")
m.description = translate("SoftEther VPN是由日本筑波大学开发的开源，跨平台，多重协定的虚拟私人网路方案。使用管理器可以轻松在路由器上搭建OpenVPN, IPsec, L2TP, MS-SSTP, L2TPv3 和 EtherIP服务器。DE指开发版，SE指稳定版。")

m:section(SimpleSection).template  = "softethervpn/softethervpn_status"

s = m:section(TypedSection, "softether")
s.anonymous = true

o = s:option(Flag, "enable", translate("启用"), translate("通过管理器修改配置后，请及时导出备份；或者通过本页重启一次服务使配置保存。否则可能因自动保存的时机未到，而导致配置丢失！"))
o.rmempty = false

o = s:option(Flag, "foreground", translate("前台模式"), translate("DE版有效，输出至控制台而不是文件（不生成日志）。建议：后台模式，用管理器进行HUB日志管理，关闭非必要安全日志/数据包日志提高性能"))

o = s:option(ListValue, "set_firewall", translate("防火墙通信规则"), translate("默认IPv4/IPv6，非“强制”时，可在“网络”-“防火墙”-“通信规则”修改限制地址(勿修改其它)<br>检测：启动服务，无规则将建立，停止时不删除<br>强制：启动时删除/重建，停止时删除"))
o:value("no", translate("-无动作-"))
o:value("check", translate("检测"))
o:value("force", translate("强制"))
o = s:option(Value, "udp_ports", translate("通信规则-UDP端口"),translate("多端口用空格隔开，下同<br/>常用端口L2TP/IPsec：500 4500 1701；OpenVPN：1194"))
o:depends("set_firewall", "check")
o:depends("set_firewall", "force")
o = s:option(Value, "tcp_ports", translate("通信规则-TCP端口"))
o:depends("set_firewall", "check")
o:depends("set_firewall", "force")

o = s:option(Flag, "config_fix", translate("修改配置文件"), translate("确认修改一次即可"))

o = s:option(Value, "lang", translate("语言"), translate("留空即不修改"))
o:value("", translate("-空-"))
o:value("cn", translate("简体中文"))
o:value("tw", translate("繁體中文"))
o:value("en", translate("English"))
o:value("ja", translate("日本語"))
o:depends("config_fix", "1")

o = s:option(Value, "AutoSaveConfigSpan", translate("自动保存时间"), translate("留空即不修改，对应AutoSaveConfigSpan字段，单位：秒。自动保存一次配置文件的间隔时间（因 VPN 会记录流量、用户登录等统计数据），可能的默认值（SE：300，DE：86400），当配置做完并备份以后，若对统计数据不感冒，可以改大一些，以免频繁执行写入，可能的最大值（SE：3600，DE：604800）。注：丢失统计数据不影响使用。"))
o:depends("config_fix", "1")

o = s:option(ListValue, "DisableJsonRpcWebApi", translate("禁用内置web服务"), translate("留空即不修改。禁用可增强安全性，对应DisableJsonRpcWebApi字段"))
o:value("", translate("-空-"))
o:value("true", translate("是"))
o:value("false", translate("否"))
o:depends("config_fix", "1")

o = s:option(DummyValue, "info", translate("_分隔线_"))
o.default = "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ "

o = s:option(Flag, "config_tmp_mode", translate("配置文件TMP模式"), translate("使配置文件在RAM中，正常停止服务时才保存。修改配置后应马上重启一次服务。某些版本AutoSaveConfigSpan最大3600秒，若觉得不够大，或不需要统计数据，可试用此模式。此模式想要保留部分统计数据，可修改AutoSaveConfigSpan为较小的值，比如300，然后设置定时保存。"))

o = s:option(Button,"backup_conf",translate("手动记录配置"), translate("服务开启时生效"))
function o.write()
luci.sys.exec("pidof vpnserver >/dev/null && [ $(uci get softethervpn.@softether[0].enable) -eq 1 ] && [ $(uci get softethervpn.@softether[0].config_tmp_mode) -eq 1 ] && [ ! -L /tmp/softethervpn/vpn_server.config ] && cp -f /tmp/softethervpn/vpn_server.config /usr/libexec/softethervpn/")
end
o:depends("config_tmp_mode", "1")

o = s:option(ListValue, "backup_conf_unit", translate("定时记录配置"))
o:value("", translate("-无-"))
o:value("hour", translate("小时"))
o:value("day", translate("天数"))
o:depends("config_tmp_mode", "1")

o = s:option(ListValue, "backup_conf_time", translate("时间间隔"))
o:value(2)
o:value(3)
o:value(4)
o:value(6)
o:value(8)
o:value(12)
o:value(24)
o:depends("backup_conf_unit", "hour")

o = s:option(ListValue, "backup_conf_time2", translate("时间间隔"))
o:value(2)
o:value(3)
o:value(4)
o:value(5)
o:value(6)
o:value(7)
o:depends("backup_conf_unit", "day")

o = s:option(DummyValue, "moreinfo", translate("<strong>相关链接：</strong><a onclick=\"window.open('https://www.softether-download.com/cn.aspx')\"><br/>管理器(Manager)下载</a><a onclick=\"window.open('https://github.com/SoftEtherVPN/SoftEtherVPN/releases')\"><br/>管理器DE版下载</a><a onclick=\"window.open('https://www.softether.org/4-docs/1-manual')\"><br/>使用手册</a>"))

return m
