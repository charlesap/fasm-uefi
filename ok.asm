format pe64 dll efi
entry main

section '.text' code executable readable

include 'efi.inc'

main:
 sub rsp, 4*8              ; reserve space for 4 arguments

 mov [Handle], rcx         ; ImageHandle
 mov [SystemTable], rdx    ; pointer to SystemTable

 lea rdx, [_hello]
 mov rcx, [SystemTable]
 mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
 call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]

 ; get the memory map

 mov dword [memmapdescsize], 48
 lea rcx, [memmapsize]
 mov qword [rcx], 4096
 lea rdx, [memmapbuff]
 lea r8, [memmapkey]
 lea r9, [memmapdescsize]
 lea rax, [memmapdescver]
 push rax
 mov rax, [SystemTable]
 mov rax, [rax + EFI_SYSTEM_TABLE.BootServices]
 call [rax + EFI_BOOT_SERVICES.GetMemoryMap]
 pop rcx
 test rax, rax
 jnz oops
 
 mov rcx, [Handle]
 mov rdx, [memmapkey]
 mov rax, [SystemTable]
 mov rax, [rax + EFI_SYSTEM_TABLE.BootServices]
 call [rax + EFI_BOOT_SERVICES.ExitBootServices]
 cmp rax, EFI_SUCCESS
 je reboot

 ; if first time fails, second time is supposed to succeed:

 mov dword [memmapdescsize], 48
 lea rcx, [memmapsize]
 mov qword [rcx], 4096
 lea rdx, [memmapbuff]
 lea r8, [memmapkey]
 lea r9, [memmapdescsize]
 lea rax, [memmapdescver]
 push rax
 mov rax, [SystemTable]
 mov rax, [rax + EFI_SYSTEM_TABLE.BootServices]
 call [rax + EFI_BOOT_SERVICES.GetMemoryMap]
 pop rcx
 test rax, rax
 jnz oops

 mov rcx, [Handle]
 mov rdx, [memmapkey]
 mov rax, [SystemTable]
 mov rax, [rax + EFI_SYSTEM_TABLE.BootServices]
 call [rax + EFI_BOOT_SERVICES.ExitBootServices]
    

reboot:
 mov rax, [SystemTable]
 mov rax, [rax + EFI_SYSTEM_TABLE.RuntimeServices]
 mov rcx, EfiResetShutdown
 mov rdx, EFI_SUCCESS
 xor r8, r8
 xor r9, r9
 call [rax + EFI_RUNTIME_SERVICES.ResetSystem]
 jmp oops

    
oops:
 lea rdx, [_nok]
 mov rcx, [SystemTable]
 mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
 call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]

 jmp $-1

 add rsp, 4*8
 mov eax, 0 ; was EFI_SUCCESS
 retn


section '.data' data readable writeable

memmapbuff: rb 4096

Handle      dq 0
SystemTable dq 0

memmapsize:     dq 4096
memmapkey:      dq 0
memmapdescsize: dq 0
memmapdescver:  dq 0

_yok      du 'ok.',13,10,0
_nok	  du 'not ok.',13,10,0
_hello du 'hello world',13,10,0


section '.reloc' fixups data discardable
