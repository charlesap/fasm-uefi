;for 32/64 portability and automatic natural align in structure definitions

struc int8 {
  . db ?
}
struc int16 {
  align 2
  . dw ?
}
struc int32 {
  align 4
  . dd ?
}
struc int64 {
  align 8
  . dq ?
}
struc intn {
  align 8
  . dq ?
}
struc dptr {
  align 8
  . dq ?
}
struc POINTER {
  align 8
  . dq ?
}


;symbols

EFIERR = 0x8000000000000000
EFI_SUCCESS			= 0
EFI_LOAD_ERROR			= EFIERR or 1
EFI_INVALID_PARAMETER		= EFIERR or 2
EFI_UNSUPPORTED 		= EFIERR or 3
EFI_BAD_BUFFER_SIZE		= EFIERR or 4
EFI_BUFFER_TOO_SMALL		= EFIERR or 5
EFI_NOT_READY			= EFIERR or 6
EFI_DEVICE_ERROR		= EFIERR or 7
EFI_WRITE_PROTECTED		= EFIERR or 8
EFI_OUT_OF_RESOURCES		= EFIERR or 9
EFI_VOLUME_CORRUPTED		= EFIERR or 10
EFI_VOLUME_FULL 		= EFIERR or 11
EFI_NO_MEDIA			= EFIERR or 12
EFI_MEDIA_CHANGED		= EFIERR or 13
EFI_NOT_FOUND			= EFIERR or 14
EFI_ACCESS_DENIED		= EFIERR or 15
EFI_NO_RESPONSE 		= EFIERR or 16
EFI_NO_MAPPING			= EFIERR or 17
EFI_TIMEOUT			= EFIERR or 18
EFI_NOT_STARTED 		= EFIERR or 19
EFI_ALREADY_STARTED		= EFIERR or 20
EFI_ABORTED			= EFIERR or 21
EFI_ICMP_ERROR			= EFIERR or 22
EFI_TFTP_ERROR			= EFIERR or 23
EFI_PROTOCOL_ERROR		= EFIERR or 24

EfiResetCold            = 0
EfiResetWarm            = 1
EfiResetShutdown        = 2

;helper macro for definition of relative structure member offsets

macro struct name
{
  virtual at 0
    name name
  end virtual
}

;structures

struc EFI_TABLE_HEADER {
 .Signature    int64
 .Revision     int32
 .HeaderSize   int32
 .CRC32        int32
 .Reserved     int32
}
struct EFI_TABLE_HEADER

struc EFI_SYSTEM_TABLE {
 .Hdr		       EFI_TABLE_HEADER
 .FirmwareVendor       dptr
 .FirmwareRevision     int32
 .ConsoleInHandle      dptr
 .ConIn 	       dptr
 .ConsoleOutHandle     dptr
 .ConOut	       dptr
 .StandardErrorHandle  dptr
 .StdErr	       dptr
 .RuntimeServices      dptr
 .BootServices	       dptr
 .NumberOfTableEntries intn
 .ConfigurationTable   dptr
}
struct EFI_SYSTEM_TABLE

struc SIMPLE_TEXT_OUTPUT_INTERFACE {
 .Reset 	    dptr
 .OutputString	    dptr
 .TestString	    dptr
 .QueryMode	    dptr
 .SetMode	    dptr
 .SetAttribute	    dptr
 .ClearScreen	    dptr
 .SetCursorPosition dptr
 .EnableCursor	    dptr
 .Mode		    dptr
}
struct SIMPLE_TEXT_OUTPUT_INTERFACE

struc EFI_BOOT_SERVICES {
 .Hdr                                 EFI_TABLE_HEADER
 .RaiseTPL                            POINTER
 .RestoreTPL                          POINTER
 .AllocatePages                       POINTER
 .FreePages                           POINTER
 .GetMemoryMap                        POINTER
 .AllocatePool                        POINTER
 .FreePool                            POINTER
 .CreateEvent                         POINTER
 .SetTimer                            POINTER
 .WaitForEvent                        POINTER
 .SignalEvent                         POINTER
 .CloseEvent                          POINTER
 .CheckEvent                          POINTER
 .InstallProtocolInterface            POINTER
 .ReinstallProtocolInterface          POINTER
 .UninstallProtocolInterface          POINTER
 .HandleProtocol                      POINTER
 .Reserved                            POINTER
 .RegisterProtocolNotify              POINTER
 .LocateHandle                        POINTER
 .LocateDevicePath                    POINTER
 .InstallConfigurationTable           POINTER
 .LoadImage                           POINTER
 .StartImage                          POINTER
 .Exit                                POINTER
 .UnloadImage                         POINTER
 .ExitBootServices                    POINTER
 .GetNextMonotonicCount               POINTER
 .Stall                               POINTER
 .SetWatchdogTimer                    POINTER
 .ConnectController                   POINTER
 .DisconnectController                POINTER
 .OpenProtocol                        POINTER
 .CloseProtocol                       POINTER
 .OpenProtocolInformation             POINTER
 .ProtocolsPerHandle                  POINTER
 .LocateHandleBuffer                  POINTER
 .LocateProtocol                      POINTER
 .InstallMultipleProtocolInterfaces   POINTER
 .UninstallMultipleProtocolInterfaces POINTER
 .CalculateCrc32                      POINTER
 .CopyMem                             POINTER
 .SetMem                              POINTER
 .CreateEventEx                       POINTER
}
struct EFI_BOOT_SERVICES

struc EFI_RUNTIME_SERVICES {
 .Hdr                       EFI_TABLE_HEADER
 .GetTime                   POINTER
 .SetTime                   POINTER
 .GetWakeupTime             POINTER
 .SetWakeupTime             POINTER
 .SetVirtualAddressMap      POINTER
 .ConvertPointer            POINTER
 .GetVariable               POINTER
 .GetNextVariableName       POINTER
 .SetVariable               POINTER
 .GetNextHighMonotonicCount POINTER
 .ResetSystem               POINTER
 .UpdateCapsule             POINTER
 .QueryCapsuleCapabilities  POINTER
 .QueryVariableInfo         POINTER
}
struct EFI_RUNTIME_SERVICES 

struc EFI_GRAPHICS_OUTPUT_PROTOCOL {
 .QueryMode POINTER
 .SetMode   POINTER
 .Blt       POINTER
 .Mode      POINTER
}
struct EFI_GRAPHICS_OUTPUT_PROTOCOL

struc EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE {
 .MaxMode         int32
 .Mode            int32
 .Info            POINTER
 .SizeOfInfo      intn
 .FrameBufferBase int64
 .FrameBufferSize intn
}
struct EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE

