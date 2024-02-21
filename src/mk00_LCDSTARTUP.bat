REM LCDSTARTUP Program for WDC65C02SXB
REM 02/20/2024

del *.bin
del *.obj
del *.lst

C:\wdc\Tools\bin\WDC02AS.exe -g -l -DUSING_02 LCDSTARTUP.asm
WDCLN -g -sz -t -HZ LCDSTARTUP
WDCDB.exe
pause
