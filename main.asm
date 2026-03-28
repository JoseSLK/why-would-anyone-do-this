; Heyyyy
org 100h        
   ;Imprimo los nombre primero (Flujo Principal)
   mov dx, offset nicolas
   call PrintStringDOS                                      
   
   mov dx, offset jose
   call PrintStringDOS         
   
   ; Aca empieza el bucle del menu principal
continuePrincipal:
    ; Imprimimos el menu
   mov dx, offset menu
   call PrintStringDOS  
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
nicolas db "Nicolas Tinjaca 202210716",13,10,"$"    
jose db "Jose Salamanca 202214283",13,10,"$"
menu db "Opt: 1:Calc 2:ART 3:Byeee",13,10,"$"

; Algunas funciones utiles
PrintCharacter:
    mov ah, 0eh
    int 10h
ret
PrintStringDOS:
    mov ah, 09h
    int 21h
ret

; La calculadora Humilde
calFunction:           
    mov dx, offset jose
    call PrintStringDOS    
    jmp continuePrincipal

ART:
    ;Su codigo
    
    jmp continuePrincipal
    ;parapapapapapararapapapapa 
