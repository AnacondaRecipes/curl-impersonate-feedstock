@REM This script is a rewritten version of deps.sh.
@REM https://github.com/lexiforest/curl-impersonate/blob/v1.2.0/win/deps.sh
@echo on

mkdir deps

@REM https://github.com/lexiforest/curl-impersonate/blob/v1.2.0/.github/workflows/build-win.yaml#L18
set BROTLI_COMMIT=ed738e842d2fbdf2d6459e39267a633c4a9b2f5d
set BORINGSSL_COMMIT=673e61fc215b178a90c0e67858bbf162c8158993
set CURL_TAG=curl-8_15_0
set NGHTTP2_COMMIT=8f44147c385fb1ed93a6f39911eeb30279bfd2dd
set NGHTTP3_TAG=v1.9.0
set NGTCP2_TAG=v1.11.0

@REM --- Download brotli ---
git clone "https://github.com/google/brotli.git" "deps\brotli"
if errorlevel 1 exit 1
git -C "deps\brotli" checkout "%BROTLI_COMMIT%"
if errorlevel 1 exit 1

@REM --- Download boringssl ---
git clone "https://boringssl.googlesource.com/boringssl.git" "deps\boringssl"
if errorlevel 1 exit 1
git -C "deps\boringssl" checkout "%BORINGSSL_COMMIT%"
if errorlevel 1 exit 1

@REM --- Download curl ---
git clone "https://github.com/curl/curl.git" "deps\curl"
if errorlevel 1 exit 1
git -C "deps\curl" checkout "%CURL_TAG%"
if errorlevel 1 exit 1

@REM --- Download nghttp2 ---
git clone "https://github.com/nghttp2/nghttp2.git" "deps\nghttp2"
if errorlevel 1 exit 1
git -C "deps\nghttp2" checkout "%NGHTTP2_COMMIT%"
if errorlevel 1 exit 1

@REM --- Download nghttp3 ---
git clone "https://github.com/ngtcp2/nghttp3.git" "deps\nghttp3"
if errorlevel 1 exit 1
git -C "deps\nghttp3" checkout "%NGHTTP3_TAG%"
if errorlevel 1 exit 1

@REM --- Download ngtcp2 ---
git clone "https://github.com/ngtcp2/ngtcp2.git" "deps\ngtcp2"
if errorlevel 1 exit 1
git -C "deps\ngtcp2" checkout "%NGTCP2_TAG%"
if errorlevel 1 exit 1

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