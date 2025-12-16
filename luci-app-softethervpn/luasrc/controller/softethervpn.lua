module("luci.controller.softethervpn", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/softethervpn") then
		return
	end
	
	entry({"admin", "vpn", "softethervpn"},firstchild(), _("SoftEther VPN 服务器")).dependent = false
	entry({"admin", "vpn", "softethervpn", "basic"}, cbi("softethervpn/softethervpn"), _("VPN 服务器"), 1).leaf = true
	entry({"admin", "vpn", "softethervpn", "log"}, cbi("softethervpn/log"), _("服务器日志"), 2).leaf = true
	entry({"admin", "vpn", "softethervpn", "status"}, call("act_status")).leaf = true
	entry({"admin", "vpn", "softethervpn", "get_log"}, call("get_log")).leaf = true
	entry({"admin", "vpn", "softethervpn", "clear_log"}, call("clear_log")).leaf = true
	
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pidof vpnserver >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function get_log()
	luci.http.write(luci.sys.exec("cat /tmp/softethervpn/server_log/vpn_$(date +%Y%m%d).log"))
end

function clear_log()
	luci.sys.call("cat /dev/null > /tmp/softethervpn/server_log/vpn_$(date +%Y%m%d).log")
end
