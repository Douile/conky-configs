-- This is a lua script for use with conky

require 'string'

-- TODO: Cache the changes
function conky_rss_html(uri, interval_in_seconds, action, num_par, spaces_in_front)
  local rss = conky_parse(string.format("${rss %s %s %s}",
    uri,
    interval_in_seconds,
    action
  ))

  -- Filter out html
  rss = string.gsub(rss, "<li>", "\n")
  rss = string.gsub(rss, "<[^>]+>", "")

  length = string.len(rss)

  local last_newline = 0
  local output = ""

  -- Set maximum width for lines
  for i=1,length do
    local character = string.sub(rss, i, i)
    if character == "\n" then
      output = output..string.sub(rss, last_newline+1, i)
      last_newline = i
    elseif i - last_newline > 60 then
      -- Note: the extra added indentation here will allow the second line to be longer
      output = output..string.sub(rss, last_newline+1, i).."\n  "
      last_newline = i
    end
  end
  output = output..string.sub(rss, last_newline+1, length)

  return output
end
