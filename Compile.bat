C:\Dev\asm\AssemblyEnvironment\Masm615\ML.exe -I"C:\Dev\asm\AssemblyEnvironment\Masm615\INCLUDE" -Zi -c -Fl -coff "C:\Dev\asm\AssemblyEnvironment\src\Tron\Tron.asm"
C:\Dev\asm\AssemblyEnvironment\Masm615\LINK32.exe /LIBPATH:"C:\Dev\asm\AssemblyEnvironment\Masm615\LIB" "C:\Dev\asm\AssemblyEnvironment\src/Tron\Tron.obj" irvine32.lib kernel32.lib /SUBSYSTEM:CONSOLE /DEBUG
pause
Tron.exe