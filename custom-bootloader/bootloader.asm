	org 0x7c00
	bits  16

mov [bootdrv],dl

start :
;*********************************** type my name **************************************************
	mov si,msg
	call messege
	call wait_input
	call palette
	call copy
	call drawimage
;******************************** print the custom messege stored in the si register*******************************	
messege:
	.loop	
		lodsb
		cmp al,0
		je wait_input
		mov ah,0x0e		; function for printing string.
		int 0x10 		; interupt 10h
		jmp .loop
;********************************* WAIT FOR A KEY PRESS **********************************************************
wait_input :	
	mov ah,0		; function for waiting for a key press
	int 0x16		; interupt for executing the function int 16h

;********************************** Switch to video mode to print the penguine pictures******************************
	;mov ah,0x0 		;function name
	;mov al,0x13  		; video mode flag is set to 13h
	mov ax,13h		; as ah=0h and al=13h so ax=13h as ax is the 16bit register ah+al
	int 0x10     		;interupt 10h to execute the function 

palette:
	mov ax,1010h 		; Video BIOS function to change palette color
	mov bx,0 		; color number 0 (usually background, black)
	mov dh,0 		; red color value (0-63)
	mov ch, 0 		; green color component (0-63)
	mov cl,0 		; blue color component (0-63)
	int 10h 		; Video BIOS interrupt



;****************************     Read the penguine image using INT 13/AH=02h        ******************************
	
	mov ax,0x000		; store 0x000 into ax
	mov es,ax       	;move ax to es
	mov bx,0x1000		;IN THIS ADDRESS WE COPY THE BIT BY BIT INFORMATION FROM PENGOO IMAGE
	mov ah,0x2		; we will read 2nd sectors that has been appended at the end of os.img
	mov al,38		; we have to read total 39 sectors because sectors = ceil(filesize/512)
;	mov ch,0x0		;low 8 bits of the cylinder no and we will read the lower most track of the hard disk
;	mov cl,0x2		; this is the sector no in this case it is 0x2
	mov cx,02h		; so cx content ch+cl=02h
	mov dh,0x0		;this is the head number this is 0h because I will read from the first byte of the 2nd sector
	mov dl,[bootdrv]	;this the drive from where we will boot the os.
	int 0x13		;interrupt 0x13


copy : 
	mov ax,0xA000 		; this is the starting offset address of the video buffer and it is stored into the ax register
	mov es,ax
	mov ax,0x1000		
	mov si,ax		;si will have the copy of the read image 

;*****************************************  offset to display the image in the middle ****************************************

	mov dx,0 		; this is the padding from top( not top of the screen)
	mov cx,0 		;this the padding from left (not from left end of the screen)
	add di,6400		;total padding from right end of the virtual machine monitor and modified the destination register
	add di,100		;right padding

drawimage:
	mov al,[si] 		;mov the content of si to al and al contains the starting address of video buffer so pixel will be displayed
	inc si	    		;increment si
	stosb      		;stop if there is no string byte to read
	inc cx			
	cmp cx,120      	;total width = 120-0 = 120
	jne drawimage
	mov cx,0		; reset the cx for plotting the next row of pixels
	inc dx
	add di,200		;total 200 padding previous line right 100 padding and next line left 100 padding	
	cmp dx,160		; because my image is of size 120 X 160
	jne drawimage
	



bootdrv db 0

msg :	
	db "ALOKEDIP CHOUDHURI :)"
	dw 0x0d0a 		; to print the messege into the next line
	db "Press a key to see the linux pengoo.........."	
	times 510-($-$$) db 0  	;we add a padding 510 byte because the data ("ALOKEDIP CHOUDHURI" and msg is not big enought to fill 510 bytes
	dw 0xaa55		;last two bytes of the MBR is respectively AA and 55; this is called the boot signature and MBR = 512 bytes
