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

		page = entry({"admin", "network", "cshark_check_status"}, call("cshark_check_status"), nil)
		page.leaf = true

		page = entry({"admin", "network", "cshark_link_list_get"}, call("cshark_link_list_get"), nil)
		page.leaf = true

		page = entry({"admin", "network", "cshark_link_list_clear"}, call("cshark_link_list_clear"), nil)
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

	luci.http.prepare_content("text/plain")

	local res = os.execute("/sbin/cshark -i " .. ifname .. " -" .. flag .. " " .. value .. " -p /tmp/cshark-luci.pid " .. filter .. " 2>&1 &")
	luci.http.write(tostring(res))
end

function cshark_iface_dump_stop()
	luci.http.prepare_content("text/plain")

	local f = io.open("/tmp/cshark-luci.pid", "rb")
	local pid = f:read("*all")
	f:close()

	local res = os.execute("kill -INT " .. pid)
	luci.http.write(tostring(res))
end

function cshark_check_status()
	luci.http.prepare_content("text/plain")

	local f = io.open("/tmp/cshark-luci.pid","r")
	if f ~= nil then
		io.close(f)
		luci.http.write("1")
	else
		luci.http.write("0")
	end
end

function cshark_link_list_get()
	local uci = require("uci").cursor()

	luci.http.prepare_content("application/json")

	luci.http.write("[")

	local t = uci:get("cshark", "cshark", "entry")
	local n = 0
	for i = #t, 1, -1 do
		n = n + 1
		if n > 10 then break end

		luci.http.write("[\"" .. t[i] .. "\"],")
	end

	luci.http.write("[]]")
end

function cshark_link_list_clear()
	local uci = require("uci").cursor()

	uci:delete("cshark", "cshark", "entry")
	uci:commit("cshark");

	luci.http.status(200, "OK")
end
