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
    ;Su codigo
    
    jmp continuePrincipal
    ;parapapapapapararapapapapa 
