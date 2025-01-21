local lfs = require("lfs")
local argparse = require("argparse")
local parser = argparse("Scum Music Formatter (SMF)", "A simple audio file formatter to make it easier to upload audio files into apple music", "Util by Skumble")

parser:argument("path", "path to the directory or file that's being formatted"):args(1)
parser:mutex(
	parser:flag("-d --dir", "Path to the directory"),
	parser:flag("-f --file", "Path to the file")
)
parser:option("-e --extension", "desired file format")
	:choices({"mp3", "wav"})
	:default("wav")

parser:option("-n --name", "if files are name-artist or artist-name")
	:choices({"AN", "NA"})
	:default("AN")

-- parser:option("-o --output", "output directory for converted files")
--     :default("./")
--     :args"?"

-- HELPER FUNCTIOINS
-------------------------------------------
function parsefileName(fileName)
    -- Find the last dot to separate the extension
    local extensionStart = fileName:match(".*()%.%w+$")
    local extension = fileName:sub(extensionStart)
    
    -- Remove the extension from the fileName
    local base = fileName:sub(1, extensionStart - 1)
    
    -- Split the base name by ' - ' to get the part1 and song part2
    local part1, part2 = base:match("^(.-)%s*%-%s*(.+)$")
    
    -- Return the array with part1, part2, and extension
    return {part1, part2, extension:sub(2)} -- Remove the dot from extension
end

function getFileExtension(fileName)
    return fileName:match("^.+(%..+)$")
end

function convertFile (fileName, fileType, fileFormat)
	local parsedFileName = parsefileName(fileName);
	local fileExtension = parsedFileName[3]

	if (fileExtension == fileType) then
		print("file is already in " .. fileType .. " format")
	else
		if fileFormat == "AN" then
			convertedFileName = parsedFileName[2] .. "." .. fileType
		elseif fileFormat == "NA" then
			convertedFileName = parsedFileName[1] .. "." .. fileType
		end

		-- build the ffmpeg command to convert the file to .fileType and execute
	    local command = string.format("ffmpeg -i \"%s\" \"%s\"", fileName, convertedFileName)
	    local result = os.execute(command)
	end
end

function processDirectory(directory, fileType, fileFormat)
    for file in lfs.dir(directory) do
        -- Skip . and .. (current and parent directory)
        if file ~= "." and file ~= ".." then
            local filePath = directory .. "/" .. file
            local mode = lfs.attributes(filePath, "mode")

            if mode == "file" then
                -- Only process audio files (e.g., .flac, .mp3, etc.)
                if file:match("%.flac$") or file:match("%.mp3$") or file:match("%.wav$") then
                    convertFile(filePath, fileType, fileFormat)
                end
            end
        end
    end
    print("File Formatting Complete")
end

-- MAIN LOGIC
-------------------------------------------
local args = parser:parse()

if args.dir ~= nil and args.dir then 
    -- Loop through all the files in the directory
    print("Converting files in directory: " .. args.path)
    processDirectory(args.path, args.extension, args.name)
elseif args.file ~= nil and args.file then
    -- Convert the single file
    print("Converting file: " .. args.path)
    convertFile(args.path, args.extension, args.name)
end