
@REM https://github.com/lexiforest/curl-impersonate/blob/v1.2.0/win/deps.sh
mkdir deps
@echo off
setlocal enabledelayedexpansion

@REM https://github.com/lexiforest/curl-impersonate/blob/v1.2.0/.github/workflows/build-win.yaml#L18
set ZLIB_COMMIT=09155eaa2f9270dc4ed1fa13e2b4b2613e6e4851
set ZSTD_COMMIT=794ea1b0afca0f020f4e57b6732332231fb23c70
set BROTLI_COMMIT=ed738e842d2fbdf2d6459e39267a633c4a9b2f5d
set BORINGSSL_COMMIT=673e61fc215b178a90c0e67858bbf162c8158993
set CURL_TAG=curl-8_15_0
set NGHTTP2_COMMIT=8f44147c385fb1ed93a6f39911eeb30279bfd2dd
set NGHTTP3_TAG=v1.9.0
set NGTCP2_TAG=v1.11.0

call :get_dep "https://github.com/madler/zlib.git" "zlib" "%ZLIB_COMMIT%"
call :get_dep "https://github.com/madler/zlib.git" "zlib" "%ZLIB_COMMIT%"
call :get_dep "https://github.com/facebook/zstd.git" "zstd" "%ZSTD_COMMIT%"
call :get_dep "https://github.com/google/brotli.git" "brotli" "%BROTLI_COMMIT%"
call :get_dep "https://boringssl.googlesource.com/boringssl.git" "boringssl" "%BORINGSSL_COMMIT%"
call :get_dep "https://github.com/curl/curl.git" "curl" "%CURL_TAG%"
call :get_dep "https://github.com/nghttp2/nghttp2.git" "nghttp2" "%NGHTTP2_COMMIT%"
call :get_dep "https://github.com/ngtcp2/nghttp3.git" "nghttp3" "%NGHTTP3_TAG%"
call :get_dep "https://github.com/ngtcp2/ngtcp2.git" "ngtcp2" "%NGTCP2_TAG%"

@REM --- Update submodules ---
echo Updating submodules...
git -C "deps\nghttp2" submodule update --init
git -C "deps\nghttp3" submodule update --init
git -C "deps\ngtcp2" submodule update --init

@REM --- Apply patches ---
echo Applying patches...
patch -p1 -d "deps\boringssl" < "patches\boringssl.patch"
patch -p1 -d "deps\curl" < "patches\curl.patch"
patch -p1 < "win\deps.patch"

%SRC_DIR%\win\build.bat

@REM --- function get_dep ---
@REM %1 = repo URL
@REM %2 = destination
@REM %3 = commit
:get_dep
git clone "%~1" "deps\%~2"
if not "%~3"=="" (
    git -C "deps\%~2" checkout "%~3"
)
goto :eof


endlocal

