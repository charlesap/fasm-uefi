format pe64 dll efi
entry main

section '.text' code executable readable

include 'efi.inc'

main:
 sub rsp, 6*8              ; reserve space for 6 arguments

 mov [Handle], rcx         ; ImageHandle
 mov [SystemTable], rdx    ; pointer to SystemTable

 lea rdx, [_hello]
 mov rcx, [SystemTable]
 mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
 call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]

 mov qword [memmapsize], 4096
 lea rcx, [memmapsize]
 lea rdx, [memmap]
 lea r8, [memmapkey]
 lea r9, [memmapdescsize]
 lea r10, [memmapdescver]
 mov [STK],rsp
 push r10
 sub rsp, 4*8
 mov rbx, [SystemTable]
 mov rbx, [rbx + EFI_SYSTEM_TABLE.BootServices]
 call [rbx + EFI_BOOT_SERVICES.GetMemoryMap]
 add rsp, 4*8
 pop r10
 mov rsp, [STK]
 cmp rax, EFI_SUCCESS
 jne oops

       mov rbx, [memmapkey]
       push rax
       push rcx
       push rdx
       call printhex
       pop rdx
       pop rcx
       pop rax


 mov rcx, [Handle]
 mov rdx, [memmapkey]
 mov rbx, [SystemTable]
 mov rbx, [rbx + EFI_SYSTEM_TABLE.BootServices]
 call [rbx + EFI_BOOT_SERVICES.ExitBootServices]
 cmp rax, EFI_SUCCESS
 je reboot

 ; if first time fails, second time is supposed to succeed:

 mov qword [memmapsize], 4096
 lea rcx, [memmapsize]
 lea rdx, [memmap]
 lea r8, [memmapkey]
 lea r9, [memmapdescsize]
 lea r10, [memmapdescver]
 mov [STK],rsp
 push r10
 sub rsp, 4*8
 mov rax, 5
 mov rbx, [SystemTable]
 mov rbx, [rbx + EFI_SYSTEM_TABLE.BootServices]
 call [rbx + EFI_BOOT_SERVICES.GetMemoryMap]
 add rsp, 4*8
 pop r10
 mov rsp, [STK]
 cmp rax, EFI_SUCCESS
 jne oops

       mov rbx, [memmapkey]
       push rax
       push rcx
       push rdx
       call printhex
       pop rdx
       pop rcx
       pop rax

 mov rcx, [Handle]
 mov rdx, [memmapkey]
 mov rbx, [SystemTable]
 mov rbx, [rbx + EFI_SYSTEM_TABLE.BootServices]
 call [rbx + EFI_BOOT_SERVICES.ExitBootServices]
 
reboot:

 mov rbx, [SystemTable]
 mov rbx, [rbx + EFI_SYSTEM_TABLE.RuntimeServices]

 mov rcx, EfiResetShutdown
 mov rdx, EFI_SUCCESS
 xor r8, r8
 call [rbx + EFI_RUNTIME_SERVICES.ResetSystem]
 jmp oops

    
oops:
 lea rdx, [_nok]
 mov rcx, [SystemTable]
 mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
 call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]
A:
 jmp A

eek:
 lea rdx, [_eek]
 mov rcx, [SystemTable]
 mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
 call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]
B:
 jmp B


boop:
 lea rdx, [_boop]
 mov rcx, [SystemTable]
 mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
 call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]
ret


 add rsp, 6*8
 mov eax, 0 ; was EFI_SUCCESS
 retn

printhex:
 mov rbp, 16
.loop:
	rol rbx, 4
	mov rax, rbx
	and rax, 0Fh
	lea rcx, [_Hex]
	mov rax, [rax + rcx]
	mov byte [_Num], al
        lea rdx, [_Num]
        mov rcx, [SystemTable]
        mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut]
        call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]
	dec rbp
 jnz .loop
 lea rdx, [_Nl]
 mov rcx, [SystemTable]
 mov rcx, [rcx + EFI_SYSTEM_TABLE.ConOut] 
 call [rcx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]

 ret


section '.data' data readable writeable
memmap:	    times 4096 db 0
Handle      dq 0
SystemTable dq 0
;RTS	    dq 0
;BS	    dq 0
STK	    dq 0
ptrmemmap:	dq 0
memmapsize:     dq 0
memmapkey:      dq 0
memmapdescsize: dq 0
memmapdescver:  dq 0

_yok      du 'ok.',13,10,0
_nok	  du 'not ok.',13,10,0
_eek      du 'eek!',13,10,0
_boop     du 'boop',13,10,0
_hello du 'hello world',13,10,0
_Hex					db '0123456789ABCDEF'
_Num					dw 0,0
_Nl					dw 13,10,0



section '.reloc' fixups data discardable
