local M = {}

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err = self:preload(job)
	if not ok or err then
		return ya.preview_widget(job, err)
	end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

	local _, err2 = ya.image_show(cache, job.area)
	ya.preview_widget(job, err2)
end

function M:seek() end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache then
		return true
	end

	local cha = fs.cha(cache)
	if cha and cha.len > 0 then
		return true
	end

	local tmp = tostring(cache) .. ".jpg"
	local output, err = Command("sh")
		:arg("-c")
		:arg(string.format(
			"heif-convert -q 90 %q %q && mv %q %q",
			tostring(job.file.url), tmp, tmp, tostring(cache)
		))
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not output then
		return false, Err("Failed to start `heif-convert`, error: %s", err)
	elseif output.status.success then
		return true
	else
		return false, Err("`heif-convert` exited with code %s: %s", output.status.code, output.stderr)
	end
end

return M
