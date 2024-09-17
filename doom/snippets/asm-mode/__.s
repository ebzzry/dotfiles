    ;;

    .global _start	    ; Provide program starting address to linker
    .align 4

_start:
    // Setup the parameters to exit the program
    // and then call the kernel to do it.
	mov     X0, #0		; Use 0 return code
	mov     X16, #1	; System call number 1 terminates this program
	svc     #0x80		; Call kernel to terminate the program

    .data
