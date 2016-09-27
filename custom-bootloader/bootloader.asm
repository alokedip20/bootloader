	org 0x7c00
	bits  16

mov [bootdrv],dl

start :
	cli    ; clear the screen
; type my name **************************************************
	mov al,'A'
	mov ah,0Eh
        int 10h

	mov al,'L'
	mov ah,0Eh
        int 10h

	mov al,'O'
	mov ah,0Eh
        int 10h

	mov al,'K'
	mov ah,0Eh
        int 10h

	mov al,'E'
	mov ah,0Eh
        int 10h

	mov al,'D'
	mov ah,0Eh
        int 10h

	mov al,'I'
	mov ah,0Eh
        int 10h

	mov al,'P'
	mov ah,0Eh
        int 10h

	mov al,' '
	mov ah,0Eh
        int 10h

	mov al,'C'
	mov ah,0Eh
        int 10h

	mov al,'H'
	mov ah,0Eh
        int 10h

	mov al,'O'
	mov ah,0Eh
        int 10h

	mov al,'U'
	mov ah,0Eh
        int 10h

	mov al,'D'
	mov ah,0Eh
        int 10h

	mov al,'H'
	mov ah,0Eh
        int 10h

	mov al,'U'
	mov ah,0Eh
        int 10h

	mov al,'R'
	mov ah,0Eh
        int 10h

	mov al,'I'	
	mov ah,0Eh
        int 10h
;******************************** wait for a key press***********************************
	mov si,msg
	mov ah,0x0e
;******************************** print the custom messege stored in the si register*******************************	
.loop	lodsb
	cmp al,0
	je input
	int 0x10 
	jmp .loop
input :	
	mov ah,0
	int 0x16
	mov ah,0x0e
	int 0x10

;********************************** switch to video mode to print the penguine pictures******************************
	mov ah,0x0 ;function name
	mov al,0x13  ; video mode flag is set to 13h
	int 0x10     ;interrupt 10h
palette:
	mov ax,1010h ; Video BIOS function to change palette color
	mov bx,0 ; color number 0 (usually background, black)
	mov dh,0 ; red color value (0-63)
	mov ch, 0 ; green color component (0-63)
	mov cl,0 ; blue color component (0-63)
	int 10h ; Video BIOS interrupt



;****************************read the penguine image using INT 13/AH=02h        ******************************
	mov ax,0x000	; store 0x000 into ax
	mov es,ax       ;move ax to es
	mov bx,0x1000
	mov ah,0x2	; we will read 2nd sectors that has been appended at the end of os.img
	mov al,39	; we have to read total 39 sectors because sectors = ceil(filesize/512)
	mov ch,0x0	;low 8 bits of the cylinder no
	mov cl,0x2	; this is the sector no in this case it is 0x2
	mov dh,0x0	;this is the head number this is 0h because I will read from the first byte of the 2nd sector
	mov dl,[bootdrv]	;this the drive from where we will boot the os.
	int 0x13		;interrupt 0x13


test : 
	mov ax,0xA000 ; this is the starting address of the video buffer and it is stored into the ax register
	mov es,ax
	mov ax,0x1000
	mov si,ax
; offset to display the iamge in the middle

	mov dx,20 ; this is the padding from top
	mov cx,90 ;this the padding from left
	add di,6400 
	add di,100	;right padding

plotpixels:
	mov al,[si] ;mov the content of address si to al so it will display the image because the memory address 0xA000 will be modified
	inc si	    ;increment si
	stosb      ;stop if there is no string byte to read
	inc cx
	cmp cx,210       ;total width = 210-90 = 120
	jne plotpixels
	mov cx,90	; reset the cx for plotting the next row of pixels
	inc dx
	add di,200	;total 200 padding previous line right 100 padding and next line left 100 padding	
	cmp dx,180
	jne plotpixels
	



bootdrv db 0

msg :	
	dw 0x0d0a ; to print the messege into the next line
	db "Press a key to see the linux pengoo.........."	
	times 510-($-$$) db 0  ;we add a padding 512 byte because the data ("ALOKEDIP CHOUDHURI" and msg is not big enought to fill 512 byte
	dw 0xaa55	;last two bytes of the MBR is respectively AA and 55; this is called the boot signature
