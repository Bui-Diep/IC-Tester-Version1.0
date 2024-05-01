@echo off
set xv_path=X:\\Vivado_15.2\\Vivado\\2015.2\\bin
call %xv_path%/xsim top_com_behav -key {Behavioral:sim_1:Functional:top_com} -tclbatch top_com.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
