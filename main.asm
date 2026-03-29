; Heyyyy
org 100h        
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
menuOperation db "Opt: Sum:s Subtract:r Multiplication:m",13,10,0

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
     Subtractions:
     Multiplications:
        
        

ART:
    ;Su codigo
    
    jmp continuePrincipal
    ;parapapapapapararapapapapa 
