@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 9ec5c2bbfcec493c9bc26b2461348983 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot ELE112_LAB_5_tb_behav xil_defaultlib.ELE112_LAB_5_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
