@echo off
chcp 65001 > nul
title Розширена інформація про накопичувачі

echo =====================================================
echo           РОЗШИРЕНА ІНФОРМАЦІЯ ПРО ДИСКИ
echo =====================================================
echo.

REM --- Фізичні диски ---
echo --- ФІЗИЧНІ ДИСКИ ---
wmic diskdrive get Index,Model,Manufacturer,SerialNumber,InterfaceType,MediaType,Size,Partitions,FirmwareRevision,Status
echo.

REM --- SMART / статус ---
echo --- SMART / СТАН ДИСКІВ ---
wmic diskdrive get Model,SerialNumber,Status,PNPDeviceID
echo.

REM --- Розділи ---
echo --- РОЗДІЛИ ---
wmic partition get DiskIndex,Name,Type,Size,Bootable,PrimaryPartition
echo.

REM --- Логічні томи ---
echo --- ЛОГІЧНІ ТОМи ---
wmic logicaldisk get DeviceID,VolumeName,FileSystem,Size,FreeSpace,DriveType
echo.

REM --- Стиль розділу (MBR/GPT) ---
echo --- СТИЛЬ РОЗДІЛУ (MBR/GPT) ---
echo list disk > temp_disk.txt
echo exit >> temp_disk.txt
diskpart /s temp_disk.txt
del temp_disk.txt
echo.

REM --- Додаткові властивості дисків ---
echo --- ДОДАТКОВІ ВЛАСТИВОСТІ ---
for /f "skip=1 tokens=1" %%D in ('wmic diskdrive get Index') do (
    if not "%%D"=="" (
        echo Інформація про диск %%D:
        wmic diskdrive where Index=%%D get /value
        echo.
    )
)

REM --- Швидкісний тест диску через winsat ---
echo --- ТЕСТ ШВИДКОСТІ ДИСКУ (читання) ---
echo (Цей тест може зайняти декілька хвилин)
winsat disk -seq -read
echo.

echo --- ТЕСТ ШВИДКОСТІ ДИСКУ (запис) ---
echo (Цей тест може зайняти декілька хвилин)
winsat disk -seq -write
echo.

echo =====================================================
echo                 ЗАВЕРШЕНО
echo =====================================================
pause