::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFDpQQQ2MNXiuFLQI5/rHy++UqVkSRN4+aJ/nXXJvpxTbY7Eq8m3V6v+yTk/R8Jyen5VfpobAZ+m5TuF+6UFcVEHoSUfp
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDpQQQ2MNXiuFLQI5/rHy++UqVkSRN4+aJ/nXXJvpxTbY7Eq8m3V6v2ceUz4xJKssJVQlkExsWsi
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal enabledelayedexpansion

:: 检查是否以管理员权限运行
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员身份运行此脚本！
    pause
    exit /b 1
)

:: 获取当前服务启动类型
for /f "tokens=2 delims=: " %%a in ('sc qc i8042prt ^| find "START_TYPE"') do (
    set "start_type=%%a"
)

:: 将启动类型转换为可读格式
if "!start_type!"=="3" set "current_status=DEMAND_START"
if "!start_type!"=="2" set "current_status=AUTO_START"
if "!start_type!"=="4" set "current_status=DISABLED"
if "!start_type!"=="" (
    echo 无法获取服务状态，服务可能不存在
    pause
    exit /b 1
)

echo ========================================
echo i8042prt 服务当前状态: !current_status!
echo ========================================
echo.

:: 判断当前状态并执行相应操作
if "!current_status!"=="DEMAND_START" (
    echo 服务已设置为手动启动，无需修改
    echo.
    pause
    exit /b 0
)

if "!current_status!"=="AUTO_START" (
    echo 服务当前为自动启动
    echo 是否将其改为手动启动？
    echo.
    set /p confirm1="请输入 Y 确认修改，N 取消，然后按回车: "
    
    if /i "!confirm1!"=="Y" (
        echo.
        set /p confirm2="再次确认：是否将服务改为手动启动？(Y/N，然后按回车): "
        
        if /i "!confirm2!"=="Y" (
            echo.
            echo 正在修改服务启动类型...
            sc config i8042prt start= demand
            if !errorlevel! equ 0 (
                echo 修改成功！服务已设为手动启动
            ) else (
                echo 修改失败，请检查权限或服务状态
            )
        ) else (
            echo 操作已取消
        )
    ) else (
        echo 操作已取消
    )
    pause
    exit /b 0
)

if "!current_status!"=="DISABLED" (
    echo 服务当前为禁用状态
    echo.
    echo 检测到服务已被禁用，是否需要改为手动启动？
    echo.
    set /p confirm1="请输入 Y 改为手动启动，N 保持禁用状态，然后按回车: "
    
    if /i "!confirm1!"=="Y" (
        echo.
        set /p confirm2="再次确认：是否将服务改为手动启动？(Y/N，然后按回车): "
        
        if /i "!confirm2!"=="Y" (
            echo.
            echo 正在修改服务启动类型...
            sc config i8042prt start= demand
            if !errorlevel! equ 0 (
                echo 修改成功！服务已设为手动启动
            ) else (
                echo 修改失败，请检查权限或服务状态
            )
        ) else (
            echo 操作已取消，保持禁用状态
        )
    ) else (
        echo 保持禁用状态
    )
    pause
    exit /b 0
)

:: 如果状态未知，显示错误信息
echo 未知的服务状态
pause
exit /b 1