@echo off
set xv_path=X:\\Vivado_15.2\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto 1ace430777254e9b9b80dac46ddd9f6e -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot top_com_behav xil_defaultlib.top_com -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
