--[[
LuCI - Lua Configuration Interface

Copyright (C) 2014, QA Cafe, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

]]--

module("luci.controller.cshark", package.seeall)

function index()
		page = node("admin", "network", "cloudshark")
		page.target = cbi("cshark")
		page.title = _("CloudShark")
		page.order = 70

		page = entry({"admin", "network", "cshark_iface_dump_start"}, call("cshark_iface_dump_start"), nil)
		page.leaf = true

		page = entry({"admin", "network", "cshark_iface_dump_stop"}, call("cshark_iface_dump_stop"), nil)
		page.leaf = true
end

function cshark_iface_dump_start(ifname, value, flag, filter)
	if ifname == nil then
		ifname = 'any'
	end
	if value == nil then
		value = '0'
	end
	if filter == nil then
		filter = ''
	end

	luci.http.prepare_content("text/html")

	local res = io.popen("/sbin/cshark -i " .. ifname .. " -" .. flag .. " " .. value .. " -p /tmp/cshark-luci.pid " .. filter .. " 2>&1")
	if res then
		while true do
			local ln = res:read("*l")
			if not ln then break end
			luci.http.write(ln)
			luci.http.write("\r\n")
		end
		res:close()
	end
end

function cshark_iface_dump_stop()
	luci.http.prepare_content("text/html")

	local f = io.open("/tmp/cshark-luci.pid", "rb")
	local pid = f:read("*all")
	f:close()

	local res = os.execute("kill -INT " ..pid)
	luci.http.write(tostring(res))
end
