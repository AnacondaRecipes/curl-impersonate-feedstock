@REM This script is a rewritten version of deps.sh.
@REM https://github.com/lexiforest/curl-impersonate/blob/v1.2.0/win/deps.sh
@echo on

@REM --- Update submodules ---
echo Updating submodules...
git -C "deps\nghttp2" submodule update --init
if errorlevel 1 exit 1
git -C "deps\nghttp3" submodule update --init
if errorlevel 1 exit 1
git -C "deps\ngtcp2" submodule update --init
if errorlevel 1 exit 1

@REM --- Apply patches ---
@REM https://github.com/lexiforest/curl-impersonate/tree/v1.2.0/patches
echo Applying patches...
patch -p1 -d "deps\boringssl" < "patches\boringssl.patch"
if errorlevel 1 exit 1
patch -p1 -d "deps\curl" < "patches\curl.patch"
if errorlevel 1 exit 1
patch -p1 < "win\deps.patch"
if errorlevel 1 exit 1

call %SRC_DIR%\win\build.bat

robocopy "%SRC_DIR%\packages\bin" "%LIBRARY_BIN%" /E
if %ERRORLEVEL% GEQ 8 exit 1
robocopy "%SRC_DIR%\packages\include" "%LIBRARY_INC%" /E
if %ERRORLEVEL% GEQ 8 exit 1
robocopy "%SRC_DIR%\packages\lib" "%LIBRARY_LIB%" /E
if %ERRORLEVEL% GEQ 8 exit 1