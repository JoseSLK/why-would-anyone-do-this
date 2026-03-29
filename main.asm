; Heyyyy
org 100h   
    mov si, offset warningMsg
    call PrintString
         
   ;Imprimo los nombre primero (Flujo Principal)
   mov si, offset nicolas
   call PrintString                                    
   
   mov si, offset jose
   call PrintString        
   
   ; Aca empieza el bucle del menu principal
continuePrincipal:
    ; Imprimimos el menu
   mov si, offset menu
   call PrintString 
   ; Esperamos al entrada
   mov ah, 0
   int 16h
   
   ;Aqui toy comparando si la opcion es la 1
   cmp al, '1'
   je calFunction
   
   ;Aqui toy comparando si la opcion es 2
   cmp  al, '2'
   je ART
                  
   ; Aqui toy comparando si la entrada es la opcion 3, osea la de salir
   cmp al, '3'
   je exitProgram
   
   jmp continuePrincipal
  
exitProgram:
   
   
ret    
; Algunas variables
nicolas db "Nicolas Tinjaca 202210716",13,10,0    
jose db "Jose Salamanca 202214283",13,10,0
menu db "Opt: 1:Calc 2:ART 3:Byeee",13,10,0 
menuOperation db "Opt: Sum:s Subtract:r Multiplication:m Back to main menu:x",13,10,0
resultString db "Wowwww, the result is: ",0 
infoInputNumbers db "Enter a three digit number, followed by the enter key: ",0
subAlert db "Negative result. Please try again.", 13,10,0        
warningMsg db "Hey prof: This is a humble calculator, max result is 255.", 13, 10, 0   

; Algunas funciones utiles
PrintCharacter:
    mov ah, 0eh
    int 10h
ret
PrintString:
    mov ah, 0eh
    stringLoop:    
        mov al, [si]
        cmp al, 0
        je finLoop
        int 10h
        inc si
        jmp stringLoop
    finLoop: 
ret

PrintNumber:
    ; 1. Obtener Centenas
    mov ah, 0         
    mov bl, 100
    div bl             ; AL = Cociente (Centenas), AH = Residuo (Resto)
    
    mov dl, ah         ; Guardamos el residuo
    cmp al, 0       
    je decenas         ; Si es 0, no imprimimos nada y pasamos a las decenas
    
    add al, '0'        ; Convertir a ASCII
    mov ah, 0eh
    int 10h            ; Imprimir la centena 

    decenas:
        ; 2. Obtener Decenas
        mov al, dl         ; Traemos lo que quedó (decenas y unidades)
        mov ah, 0
        mov bl, 10
        div bl             ; AL = Cociente (Decenas), AH = Residuo (Unidades)
        
        mov dl, ah         ; Guardamos las unidades en DL
        
        add al, '0'        ; Convertir a ASCII
        mov ah, 0eh
        int 10h            ; Imprimir la decena
    
    unidades:
        ; 3. Obtener Unidades
        mov al, dl         ; Traemos el último residuo
        add al, '0'        ; Convertir a ASCII
        mov ah, 0eh
        int 10h            ; Imprimir la unidad

ret

EnterNumbers:
    
    mov si, offset infoInputNumbers
    call PrintString
    
    mov bl, 0 ;RESULTADO FINAL
    mov cl, 0 ;Contador
    
    loopNumbers:
        
        ; Entrada
        mov ah, 0
        int 16h
        
        ;Esta monda es un enter?Si, si, se sale
        cmp al, 13
        je exitInput                              
        
        ;Es un numero es un caracter numero?
        ;Depende del assci, si no pertenece a un numero, paila
        cmp al, '0'
        jl loopNumbers
        
        ;Lo mismo, pero con el limite superior
        cmp al, '9'
        jg loopNumbers                        
        
        ;Imprime la entrada       
        mov ah, 0eh
        int 10h
         
        ;Primero convierto el caracter en numero real
        sub al, '0'
        ;guardo la entrada en dl
        mov dl, al
        
        ;Ahora, traigo el total actual
        mov al, bl ; 
        mov dh, 10
        mul dh ; Multiplico lo que esta en al por 10
        
        add al, dl ; Se suma el nuevo digito
        mov bl, al ; Guardo el nuevo digito en bl
        
        inc cl ; Incremento el contador para ver cuantas cifras vamos
        cmp cl, 3 ; Si vamos tres cifras, se termina el loop
        je exitInput
        
        jmp loopNumbers
    
    exitInput:
    mov al, 13
    call PrintCharacter
    mov al, 10
    call PrintCharacter

ret

; La calculadora Humilde
calFunction:
    continueOperations:           
        mov si, offset menuOperation
        call PrintString
        ;Las opciones de la calculadora
        mov ah, 0
        int 16h
        ;Lo que se debe ejecutar
        cmp al, 's'
        je Sums
        cmp al, 'r'
        je Subtractions
        cmp al, 'm'    
        je Multiplications
        cmp al, 'x'
        je continuePrincipal
        
        jmp continueOperations
       
     Sums:
        call EnterNumbers
        mov bh, bl
        
        mov al, "+"       
        call PrintCharacter 
        mov al, 13
        call PrintCharacter
        mov al, 10
        call PrintCharacter
          
        call EnterNumbers
        
        add bh, bl
        
        mov si, offset resultString
        call PrintString
        
        mov al, bh
        call PrintNumber
               
        mov al, 13
        call PrintCharacter
        mov al, 10
        call PrintCharacter
        
        
        jmp continueOperations
        
     Subtractions:
        call EnterNumbers
        mov bh, bl
        
        mov al, "-"       
        call PrintCharacter 
        mov al, 13
        call PrintCharacter
        mov al, 10
        call PrintCharacter
          
        call EnterNumbers
        
        cmp bh, bl
        jl alertImpossible
        
        sub bh, bl
        
        mov si, offset resultString
        call PrintString
        
        mov al, bh
        call PrintNumber
               
        mov al, 13
        call PrintCharacter
        mov al, 10
        call PrintCharacter
         
         alertImpossible:
            mov si, offset subAlert
            call PrintString
        
        jmp continueOperations
     Multiplications:
        call EnterNumbers
        mov bh, bl
        
        mov al, "*"       
        call PrintCharacter 
        mov al, 13
        call PrintCharacter
        mov al, 10
        call PrintCharacter
          
        call EnterNumbers
        
        mov al, bh
        mul bl
        
        mov bh, al
        
        mov si, offset resultString
        call PrintString
        
        mov al, bh
        call PrintNumber
               
        mov al, 13
        call PrintCharacter
        mov al, 10
        call PrintCharacter
        
        jmp continueOperations

ART:
   
    mov ax, 0003h
    int 10h

    
    mov dh, 0      
    mov si, 30     

dibujar_fondo:
    mov ah, 02h
    mov bh, 0
    mov dl, 25     
    int 10h

    mov ah, 09h
    mov al, ' '    
    mov bh, 0
    mov bl, 0F0h   
    mov cx, 30 
    int 10h
    
    inc dh         
    dec si   
    cmp si, 0  
    jne dibujar_fondo
    
    ;Dibujar a Ado

    ; --- Fila 1 ---
    mov dh, 1
    mov dl, 37 
    mov bl, 00h 
    mov si, 7 
    call DibujarSegmento

    ; --- Fila 2 ---
    mov dh, 2
    mov dl, 35 
    mov bl, 00h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 37 
    mov bl, 01h 
    mov si, 7 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 00h 
    mov si, 2 
    call DibujarSegmento 

    ; --- Fila 3 ---
    mov dh, 3
    mov dl, 34 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 35 
    mov bl, 01h 
    mov si, 11
    call DibujarSegmento 
    
    mov dl, 46 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 4 ---
    mov dh, 4
    mov dl, 33 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 34 
    mov bl, 01h 
    mov si, 13
    call DibujarSegmento 
    
    mov dl, 47 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 5 ---
    mov dh, 5
    mov dl, 33 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 34 
    mov bl, 01h 
    mov si, 13
    call DibujarSegmento 
    
    mov dl, 47 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 6 ---
    mov dh, 6
    mov dl, 32 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 33 
    mov bl, 01h 
    mov si, 9 
    call DibujarSegmento 
    
    mov dl, 42 
    mov bl, 00h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 01h 
    mov si, 4 
    call DibujarSegmento 
    
    mov dl, 48 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 7 ---
    mov dh, 7
    mov dl, 32 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 33 
    mov bl, 01h 
    mov si, 8 
    call DibujarSegmento 
    
    mov dl, 41 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 42 
    mov bl, 07h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 43 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 01h 
    mov si, 4 
    call DibujarSegmento 
    
    mov dl, 48 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 8 ---
    mov dh, 8
    mov dl, 32 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 33 
    mov bl, 01h 
    mov si, 8 
    call DibujarSegmento 
    
    mov dl, 41 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 42 
    mov bl, 07h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 43 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 01h 
    mov si, 4 
    call DibujarSegmento 
    
    mov dl, 48 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 9 ---
    mov dh, 9
    mov dl, 31 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 32 
    mov bl, 01h 
    mov si, 4 
    call DibujarSegmento 
    
    mov dl, 36 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 37 
    mov bl, 01h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 38 
    mov bl, 00h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 41 
    mov bl, 07h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 00h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 46 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 49 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 10 ---
    mov dh, 10
    mov dl, 31 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 32 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 35 
    mov bl, 00h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 38 
    mov bl, 07h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 40 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 41 
    mov bl, 07h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 43 
    mov bl, 03h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 07h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 45 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 46 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 49 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 11 ---
    mov dh, 11
    mov dl, 31 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 32 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 35 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 36 
    mov bl, 07h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 37 
    mov bl, 03h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 38 
    mov bl, 07h 
    mov si, 5 
    call DibujarSegmento 
    
    mov dl, 43 
    mov bl, 03h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 07h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 45 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 46 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 49 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 12 ---
    mov dh, 12
    mov dl, 31 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 32 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 35 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 36 
    mov bl, 07h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 37 
    mov bl, 03h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 38 
    mov bl, 07h 
    mov si, 5 
    call DibujarSegmento 
    
    mov dl, 43 
    mov bl, 03h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 07h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 45 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 46 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 49 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 13 ---
    mov dh, 13
    mov dl, 32 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 33 
    mov bl, 01h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 35 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 36 
    mov bl, 07h 
    mov si, 9 
    call DibujarSegmento 
    
    mov dl, 45 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 46 
    mov bl, 01h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 48 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 14 ---
    mov dh, 14
    mov dl, 32 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 33 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 36 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 37 
    mov bl, 07h 
    mov si, 7 
    call DibujarSegmento 
    
    mov dl, 44 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 45 
    mov bl, 01h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 48 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 15 ---
    mov dh, 15
    mov dl, 32 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 
    
    mov dl, 33 
    mov bl, 01h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 35 
    mov bl, 00h 
    mov si, 11
    call DibujarSegmento 
    
    mov dl, 46 
    mov bl, 01h 
    mov si, 2 
    call DibujarSegmento 
    
    mov dl, 48 
    mov bl, 00h 
    mov si, 1 
    call DibujarSegmento 

    ; --- Fila 16 ---
    mov dh, 16
    mov dl, 33 
    mov bl, 00h 
    mov si, 3 
    call DibujarSegmento 
    
    mov dl, 45 
    mov bl, 00h 
    mov si, 4 
    call DibujarSegmento 

    ; --- Terminar y Esperar tecla ---
    mov ah, 00h
    int 16h
    
    ;Limpiar la pantalla antes de volver para resetear colores
    mov ax, 0003h
    int 10h

    ;Asegurarnos de que el atributo de color vuelva a ser normal
    mov ah, 09h
    mov al, ' '    
    mov bh, 0
    mov bl, 07h
    mov cx, 2000 
    int 10h

    jmp continuePrincipal


; Funcion para pintar multiples bloques
DibujarSegmento:
    ; Guardamos DH/DL
    mov ah, 02h
    mov bh, 0
    int 10h  
    
    ; Pintamos carácter con atributo
    mov ah, 09h    
    mov al, 219    
    mov cx, 1      
    int 10h
    
    inc dl             
    dec si             
    cmp si, 0          
    jne DibujarSegmento
ret                
