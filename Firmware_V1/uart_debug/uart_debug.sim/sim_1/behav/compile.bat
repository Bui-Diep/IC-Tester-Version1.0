@echo off
set xv_path=X:\\Vivado_15.2\\Vivado\\2015.2\\bin
echo "xvhdl -m64 --relax -prj top_com_vhdl.prj"
call %xv_path%/xvhdl  -m64 --relax -prj top_com_vhdl.prj -log compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
