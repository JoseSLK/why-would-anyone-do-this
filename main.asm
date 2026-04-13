; Heyyyy - Version Compatible con Restricciones del Taller
org 100h   
    mov si, offset warningMsg
    call PrintString
         
   ;Imprimo los nombres primero (Flujo Principal)
   mov si, offset nicolas
   call PrintString                                    
   
   mov si, offset jose
   call PrintString        
   
   ; Aca empieza el bucle del menu principal
continuePrincipal:
    ; Imprimimos el menu
   mov si, offset menu
   call PrintString 
   ; Esperamos entrada
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

; ============================================
; VARIABLES Y DATOS
; ============================================
nicolas db "Nicolas Tinjaca 202210716",13,10,0    
jose db "Jose Salamanca 202214283",13,10,0
menu db "Opt: 1:Calc 2:ART 3:Byeee",13,10,0 
menuOperation db "Opt: Sum:s Subtract:r Multiplication:m Back to main menu:x",13,10,0
resultString db "Wowwww, the result is: ",0 
infoInputNumbers db "Enter a three digit number, followed by the enter key: ",0
subAlert db "Negative result. Please try again.", 13,10,0        
warningMsg db "Hey prof: This is a humble calculator, max result is 255.", 13, 10, 0   

; ============================================
; FUNCIONES BASICAS DE IMPRESION
; ============================================
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

; ============================================
; PRINTNUMBER SIN DIV - Usa restas repetitivas
; Entrada: AL = numero a imprimir (0-255)
; ============================================
PrintNumber:
    mov cl, al         ; CL = numero original (se modificara)
    
    ; 1. Extraer centenas (dividir por 100 via restas)
    mov bl, 0          ; BL = contador de centenas
    
centenas_loop:
    cmp cl, 100
    jb print_centenas  ; Si CL < 100, no cabe mas
    sub cl, 100        ; Restar 100
    inc bl             ; Contar una centena
    jmp centenas_loop
    
print_centenas:
    ; BL = centenas, CL = residuo (0-99)
    cmp bl, 0
    je decenas         ; Si no hay centenas, saltar a decenas
    
    mov al, bl
    add al, '0'        ; Convertir a ASCII
    mov ah, 0eh
    int 10h            ; Imprimir centena

decenas:
    ; 2. Extraer decenas (dividir residuo por 10)
    mov bl, 0          ; BL = contador de decenas
    
decenas_loop:
    cmp cl, 10
    jb print_decenas   ; Si CL < 10, terminar
    sub cl, 10         ; Restar 10
    inc bl             ; Contar una decena
    jmp decenas_loop
    
print_decenas:
    mov al, bl
    add al, '0'        ; Convertir a ASCII
    mov ah, 0eh
    int 10h            ; Imprimir decena (incluso si es 0)
    
    ; 3. Imprimir unidades (quedan en CL)
    mov al, cl
    add al, '0'        ; Convertir a ASCII
    mov ah, 0eh
    int 10h            ; Imprimir unidad

ret

; ============================================
; ENTERNUMBERS SIN MUL - Multiplica por 10 via sumas
; ============================================
EnterNumbers:
    mov si, offset infoInputNumbers
    call PrintString
    
    mov bl, 0          ; RESULTADO FINAL
    mov cl, 0          ; Contador de digitos
    
loopNumbers:
    ; Entrada
    mov ah, 0
    int 16h
    
    ;Es un enter? Si, se sale
    cmp al, 13
    je exitInput                              
    
    ;Validar que sea numero (0-9)
    cmp al, '0'
    jl loopNumbers
    cmp al, '9'
    jg loopNumbers                        
    
    ;Imprimir la entrada       
    mov ah, 0eh
    int 10h
     
    ;Convertir ASCII a numero
    sub al, '0'
    mov dl, al         ; Guardar digito nuevo en DL
    
    ;MULTIPLICAR BL POR 10 usando solo ADD
    ;Numero * 10 = Numero sumado 10 veces
    mov ch, 10         ; Contador de sumas
    mov al, bl         ; AL = valor actual (a multiplicar)
    mov bl, 0          ; BL = acumulador (resetear a 0)
    
multiply_loop:
    add bl, al         ; Sumar valor original
    dec ch             ; Decrementar contador
    cmp ch, 0
    jne multiply_loop  ; Si aun no es 0, seguir sumando
    
    ;Ahora sumar el nuevo digito
    add bl, dl         ; BL = (BL * 10) + digito_nuevo
    
    inc cl             ; Incrementar contador de digitos
    cmp cl, 3          ; Si ya van 3 cifras, terminar
    je exitInput
    
    jmp loopNumbers

exitInput:
    mov al, 13
    call PrintCharacter
    mov al, 10
    call PrintCharacter
ret

; ============================================
; CALCULADORA
; ============================================
calFunction:
continueOperations:           
    mov si, offset menuOperation
    call PrintString
    
    ;Leer opcion
    mov ah, 0
    int 16h
    
    ;Validar opciones
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
    mov bh, bl         ; Primer numero en BH
    
    mov al, "+"       
    call PrintCharacter 
    mov al, 13
    call PrintCharacter
    mov al, 10
    call PrintCharacter
      
    call EnterNumbers  ; Segundo numero en BL
    
    add bh, bl         ; Sumar
    
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
    mov bh, bl         ; Primer numero en BH
    
    mov al, "-"       
    call PrintCharacter 
    mov al, 13
    call PrintCharacter
    mov al, 10
    call PrintCharacter
      
    call EnterNumbers  ; Segundo numero en BL
    
    cmp bh, bl
    jl alertImpossible ; Si BH < BL, resultado negativo (no permitido)
    
    sub bh, bl         ; Restar
    
    mov si, offset resultString
    call PrintString
    
    mov al, bh
    call PrintNumber
           
    mov al, 13
    call PrintCharacter
    mov al, 10
    call PrintCharacter
     
    jmp continueOperations
    
alertImpossible:
    mov si, offset subAlert
    call PrintString
    jmp continueOperations

; ============================================
; MULTIPLICACION SIN MUL - Usa sumas repetitivas
; ============================================
Multiplications:
    call EnterNumbers
    mov bh, bl         ; Primer numero en BH
    
    mov al, "*"       
    call PrintCharacter 
    mov al, 13
    call PrintCharacter
    mov al, 10
    call PrintCharacter
      
    call EnterNumbers  ; Segundo numero en BL
    
    ;MULTIPLICACION via sumas: BH * BL
    ;Si BL es 0, resultado es 0
    mov al, bh         ; AL = multiplicando (primer numero)
    mov ch, bl         ; CH = multiplicador/contador (segundo numero)
    mov bl, 0          ; BL = acumulador del resultado (inicia en 0)
    
    cmp ch, 0          ; Si multiplicador es 0, resultado es 0
    je multi_done
    
multi_loop:
    add bl, al         ; Sumar multiplicando al resultado
    dec ch             ; Decrementar contador
    cmp ch, 0
    jne multi_loop     ; Mientras no sea 0, seguir sumando
    
multi_done:
    mov bh, bl         ; Mover resultado a BH para imprimir
    
    mov si, offset resultString
    call PrintString
    
    mov al, bh
    call PrintNumber
           
    mov al, 13
    call PrintCharacter
    mov al, 10
    call PrintCharacter
    
    jmp continueOperations

; ============================================
; ASCII ART (Sin cambios, ya cumple restricciones)
; ============================================
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
    
    ;Dibujar figura pixel por pixel usando colores
    
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
    
    ;Limpiar la pantalla antes de volver
    mov ax, 0003h
    int 10h

    ;Resetear colores a normal
    mov ah, 09h
    mov al, ' '    
    mov bh, 0
    mov bl, 07h
    mov cx, 2000 
    int 10h

    jmp continuePrincipal

; Funcion para pintar multiples bloques de color
DibujarSegmento:
    mov ah, 02h
    mov bh, 0
    int 10h  
    
    mov ah, 09h    
    mov al, 219    
    mov cx, 1      
    int 10h
    
    inc dl             
    dec si             
    cmp si, 0          
    jne DibujarSegmento
ret