local lfs = require("lfs")

-- ASCII Logo Art :p
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
    for i, line in ipairs(lines) do
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

        if choice == '1' then
            while true do
                io.write("Enter the new money value: ")
                local newMoney = io.read()
                if tonumber(newMoney) then
                    replaceLines(saveFilePath, '"Money"', newMoney)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
            os.execute("timeout /t 1 >nul")
        elseif choice == '2' then
            while true do
                io.write("Enter the new level value: ")
                local newLevel = io.read()
                if tonumber(newLevel) then
                    replaceLines(saveFilePath, '"CurrentStoreLevel"', newLevel)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
            os.execute("timeout /t 1 >nul")
        elseif choice == '3' then
            while true do
                io.write("Enter the number of expansions (max 22): ")
                local newLevel = io.read()
                if tonumber(newLevel) and tonumber(newLevel) >= 0 and tonumber(newLevel) <= 22 then
                    replaceLines(saveFilePath, '"StoreUpgradeLevel"', newLevel)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
            os.execute("timeout /t 1 >nul")
        elseif choice == '4' then
            while true do
                io.write("Enter the number of expansions (max 6): ")
                local newLevel = io.read()
                if tonumber(newLevel) and tonumber(newLevel) >= 0 and tonumber(newLevel) <= 5 then
                    replaceLines(saveFilePath, '"StorageLevel"', newLevel)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
            os.execute("timeout /t 1 >nul")
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
            os.execute("timeout /t 1 >nul")
        elseif choice == '6' then
            while true do
                io.write("Enter the number of days: ")
                local newLevel = io.read()
                if tonumber(newLevel) then
                    replaceLines(saveFilePath, '"CurrentDay"', newLevel)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
            os.execute("timeout /t 1 >nul")
        elseif choice == '7' then
            while true do
                io.write("Enter the number of checkouts: ")
                local newLevel = io.read()
                if tonumber(newLevel) then
                    replaceLines(saveFilePath, '"CompletedCheckoutCount"', newLevel)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
            os.execute("timeout /t 1 >nul")
        elseif choice == '8' then
            while true do
                io.write("Enter the amount of xp: ")
                local newLevel = io.read()
                if tonumber(newLevel) then
                    replaceLines(saveFilePath, '"CurrentStorePoint"', newLevel)
                    break
                else
                    print("Invalid input. Please enter a valid number.")
                end
            end
            os.execute("timeout /t 1 >nul")
        elseif choice == '9' then
            backupFile(saveFilePath)
            os.execute("timeout /t 1 >nul")
        elseif choice == '10' then
            print("Exiting program...")
            os.execute("timeout /t 2 >nul")
            break
        else
            print("Invalid choice. Please choose again.")
            os.execute("timeout /t 1 >nul")
        end
    end
end

main()
