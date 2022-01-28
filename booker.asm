.model small
.Stack 64
.Data
titles db "Trip booker","$"
;============================================== Registeration
ropeartions db "1: Registerion",0ah,0dh,"2: Sign in",0ah,0dh,"$"
askName db "Enter the username in 8 charcters : ","$"
askPassword db "Enter the password in 8 charcters : ","$"
askPhone db "Enter the phone : ","$"
spassword db "Password : ","$"
rcomplate db "Registeration is completed","$"
swrong db "Wrong password please try again",0ah,0dh,"press 1 if you want to register or any key to continue : ","$"
;============================================== end
;============================================== Program operations
choose db "Choose your operation ^-^: ","$"
operations db "1: Show details",0ah,0dh,"2: Book a ticket",0ah,0dh,"3: Send Complaiment",0ah,0dh,"4: Show Trips History",0ah,0dh,"$"
askToFinish db "If you want to end the program press 'f' or any key to continue : ","$"
tripTypes db "Trip typs",0ah,0dh,0ah,0dh,"1: Sea Trip",0ah,0dh,"2: Air Trip",0ah,0dh,"3: Wild Trip",0ah,0dh,"$"
askTicketsNumber db "Enter the number of tickets : ","$"
finishMsg db "The ticket is pooked successfully",0ah,0dh,"Number of tickets: ","$"
askComplaint db "Please write your complaint here and press Enter twice to finish writing","$"
tripsNumber db "Number of trips: ","$"
tripTitle db "-Trip",0ah,0dh,"$"
tripType db "Type: ","$"
ticketNumber db "Number of tickets: ","$"
;==============================================
;============================================== User data
counter dw 0
password db 9 dup("$")
user db 9 dup("$")
phone db 12 dup("$")
namef db "Name: ","$"
phonef db "Phone: ","$"
trips dw 20 dup ("$")
two db 2
nl db 0ah,0dh,"$"
;==============================================
;==============================================
;==============================================
.Code
main proc far
   .startup
   ;=================================== start
   lea dx,titles
   call print
   start:
   call newline
   call newline
   lea dx,ropeartions
   call print
   lea dx,choose
   call print
   call char_input
   call newline
   cmp al,"1"
   je registerions
   jne signing_in
   ;=================================== registerion
   registerions: 
   call register
   jmp operating
   signing_in:
   call signin
   ;=================================== operating
   operating:
   lea dx,operations
   call print
   lea dx,choose
   call print
   call char_input
   call newline
   cmp al,"1"
   je showdetails
   cmp al,"2"
   je book
   cmp al,"3"
   je complain
   cmp al,"4"
   je history
   ;========================= showdetails
   showdetails:
   call newline
   call show_details
   jmp bye
   ;========================= book
   book:
   call booking
   jmp bye
   ;========================= complain
   complain:
   call complaint
   jmp bye
   ;========================= history
   history:
   call show_history
   jmp bye
   ;========================= bye
   bye:
   lea dx,askToFinish
   call print
   call char_input
   cmp al,'f'
   jne start
   .exit
main endp
;=================================
;=================================
print proc
    mov ah,09h
    int 21h
    ret
print endp
;=================================
;=================================
print_c proc
    mov ah,02h
    int 21h
    ret
print_c endp
;=================================
;=================================
newline proc
    lea dx,nl
    call print
    ret
newline endp
;=================================
;=================================
char_input proc 
    mov ax,0100h
    int 21h
    mov ah,00h
    ret
char_input endp
;=================================
;=================================
register proc near
    lea dx,askName
    call print
    mov bx,0
    ;================================= name
    fillName:
    cmp bx,8
    je fillPassword
    call char_input
    cmp al,0dh
    je fillPassword
    mov user[bx],al
    inc bx
    jmp fillName
    ;================================= password
    fillPassword:
    call newline
    lea dx,askPassword
    call print
    mov bx,0
    pa:
    cmp bx,8
    je fillPhone
    call char_input
    
    cmp al,0dh
    je fillPhone
    mov password[bx],al
    inc bx
    jmp pa
    ;================================= phone
    fillPhone:
    call newline
    lea dx,askPhone
    call print
    mov bx,0
    ph:
    cmp bx,11
    je finish
    call char_input
    cmp al,0dh
    je finish
    mov phone[bx],al
    inc bx
    jmp ph
    finish:
    call newline
    lea dx,rcomplate
    call print
    call newline
    ret
register endp
;=================================
;=================================
signin proc
   mov bx,0
   init:
   lea dx,spassword
   call print
   star:
   cmp bx,8
   je finis
   call char_input
   cmp al,password[bx]
   jne denied
   inc bx
   jmp star
   denied:
   mov bx,0
   call newline
   lea dx,swrong
   call print
   call char_input
   call newline
   cmp al,"1"
   jne init
   call newline
   call register
   jmp finis
   finis:
   call newline
   ret
signin endp
;=================================
;=================================
show_details proc near
    lea dx,namef
    call print
    lea dx,user
    call print
    call newline
    lea dx,phonef
    call print
    lea dx,phone
    call print
    call newline
    ret
show_details endp
;=================================
;=================================
booking proc near
   lea dx,tripTypes
   call print
   lea dx,choose
   call print
   call char_input
   mov bh,al
   call newline
   lea dx,askTicketsNumber
   call print
   call char_input
   ;push ax
   call newline
   mov bl,al
   mov di,counter
   mov trips[0+di],bx
   lea dx,finishMsg
   call print
   mov dl,bl
   mov ax,0200h
   int 21h
   call newline
   add counter,2
   ret
booking endp
;=================================
;=================================
complaint proc near
    lea dx,askComplaint
    call print
    mov cx,0
    start1:
    mov bx,0
    call newline
    start2:
    call char_input
    inc bx
    cmp bx,30
    je start1
    cmp al,0dh
    je check
    jne check2
    check:
    inc cx
    cmp cx,2
    je close
    jne start1
    check2:
    mov cx,0
    jmp start2
    close:
    ret
complaint endp
show_history proc
    cmp counter,0
    je ff
    call newline
    lea dx,tripsNumber
    call print
    mov ax,counter
    div two
    mov dl,al
    mov cl,al
    mov bx,counter
    add dl,48
    call print_c
    call newline
    add cl,48
    printTrips:
    sub bx,2
    mov dl,cl
    call print_c
    lea dx,tripTitle
    call print
    lea dx,tripType
    call print
    mov ax,trips[bx]
    mov dl,ah
    call print_c
    call newline
    lea dx,ticketNumber
    call print
    mov ax,trips[bx]
    mov dl,al
    call print_C
    call newline
    call newline
    dec cl
    cmp bx,0
    jne printTrips
    ff:
    ret
show_history endp
end main