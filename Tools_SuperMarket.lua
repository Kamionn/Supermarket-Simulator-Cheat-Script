local lfs = require("lfs")

local logo = [[
                                                    1  - Money Giver      
                                                    2  - Level Giver
                                                    3  - Store Expander
                                                    4  - Storage Expander
                                                    5  - License Unlocker
                                                    6  - Day Count Changer
                                                    7  - Completed Checkouts Giver
                                                    8  - Xp Giver
                                                    9  - Backup File
                                                    10 - Exit Program
]]

-- Replace Data Function
local function replaceLines(filePath, searchKey, newValue)
    local file = assert(io.open(filePath, "r"))
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    
    local outFile = assert(io.open(filePath, "w"))
    for _, line in ipairs(lines) do
        if string.find(line, searchKey) then
            local old_value = string.match(line, ':(.-),?')
            if not old_value then
                old_value = string.match(line, ':(.+)')
            end
            line = line:gsub(old_value, newValue)
        end
        outFile:write(line, "\n")
    end
    outFile:close()
    print("Successfully modified.")
end

local function backupFile(filePath)
    local backupFolder = "./Backups"
    lfs.mkdir(backupFolder)

    local baseName = string.match(filePath, "[^/]+$")
    local backupFileName = backupFolder .. "/" .. baseName .. "_Backup"

    local index = 1
    while lfs.attributes(backupFileName .. index) do
        index = index + 1
    end

    backupFileName = backupFileName .. index

    local inputFile = assert(io.open(filePath, "rb"))
    local outputFile = assert(io.open(backupFileName, "wb"))

    local content = inputFile:read("*all")
    outputFile:write(content)

    inputFile:close()
    outputFile:close()

    print("Backup created successfully!")
end

-- Main Function
local function main()
    local saveFilePath = os.getenv("APPDATA") .. "\\LocalLow\\Nokta Games\\Supermarket Simulator\\SaveFile.es3"

    if not io.open(saveFilePath, "r") then
        print("Error: Save File doesn't exist. Please open the game, create a new save or continue, close the game then try again.")
        return
    end

    while true do
        os.execute("cls")

        print(logo)

        io.write("Choose an option: ")
        local choice = io.read()

        local valueMapping = {
            ["1"] = {prompt = "Enter the new money value: ", key = '"Money"'},
            ["2"] = {prompt = "Enter the new level value: ", key = '"CurrentStoreLevel"'},
            ["3"] = {prompt = "Enter the number of expansions (max 22): ", key = '"StoreUpgradeLevel"', max = 22},
            ["4"] = {prompt = "Enter the number of expansions (max 6): ", key = '"StorageLevel"', max = 6},
            ["6"] = {prompt = "Enter the number of days: ", key = '"CurrentDay"'},
            ["7"] = {prompt = "Enter the number of checkouts: ", key = '"CompletedCheckoutCount"'},
            ["8"] = {prompt = "Enter the amount of xp: ", key = '"CurrentStorePoint"'},
        }

        if valueMapping[choice] then
            while true do
                io.write(valueMapping[choice].prompt)
                local newValue = io.read()
                if tonumber(newValue) and (not valueMapping[choice].max or tonumber(newValue) <= valueMapping[choice].max) then
                    replaceLines(saveFilePath, valueMapping[choice].key, newValue)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
        elseif choice == '5' then
            io.write("Toggle Cheat (Type: on/off): ")
            local toggle = io.read()
            if toggle == 'on' then
                replaceLines(saveFilePath, '"UnlockedLicenses"', "[21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47")
            elseif toggle == 'off' then
                replaceLines(saveFilePath, '"UnlockedLicenses"', "[21")
            else
                print("Invalid input. Please enter 'on' or 'off'.")
            end
        elseif choice == '9' then
            backupFile(saveFilePath)
        elseif choice == '10' then
            print("Exiting program...")
            os.execute("timeout /t 2 >nul")
            break
        else
            print("Invalid choice. Please choose again.")
        end
        os.execute("timeout /t 1 >nul")
    end
end

main()
