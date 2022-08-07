.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern fopen: proc
extern fscanf: proc
extern fprintf: proc
extern printf: proc
extern scanf: proc
extern fclose: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
mode_read DB "r", 0
file_namea DB "a.txt", 0
file_nameb DB "b.txt", 0
file_name DB "rezultat.txt", 0
mode_write DB "w", 0
format_s DB "%s",0
format_d DB "%d",0
spatiu DB " ",0
err DB "File error.",0
mesaj DB "> Introduceti o operatie cu matrici:",0
mesaj_scalar DB "> Introduceti scalar: ",0
mesaj_final DB "> Rezultat: rezultat.txt",0
mesaj_indic DB "> ",0
endl DB 10,0
fisiera DB "> A= ",0
fisier_a DB "> a.txt",0
fisierb DB "> B= ",0
fisier_b DB "> b.txt",0
a DD 0 
x DD 0
y DD 0
i DD 0
n DD 0
expresie DB 0 dup(4)
.code
scalar_macro macro a, A

    push offset mesaj_scalar
	push offset format_s
	call printf ;"> Introduceti scalar: "
	add esp,8
	
	push offset a
	push offset format_d
	call scanf ;citire scalar de la tastatura
	add esp,8
	 push offset mode_write
    push offset file_name
    call fopen ;deschidere fisier rezultat in mod scriere
    add esp,8
	mov edi,eax ;muta pointerul din eax in registrul edi
	
    push offset mode_read
    push offset file_namea
    call fopen ;deschidere fisier a in mod citire
    add esp,8
	mov esi,eax ;muta pointerul din eax in registrul esi
	
	cmp esi,0 ;fopen returneaza 0 pe esi in caz de esec
	jz open_error1
	
	 push offset n ;citesc numarul de linii/coloane din fisier
	 push offset format_d
	 push esi
	 call fscanf
	 add esp,12
     
equal:
     inc i ;incrementez o variabila
     push offset x ;citesc pe rand fiecare numar al matricii din fisier
	 push offset format_d
	 push esi
	 call fscanf
	 add esp,12
	 test eax, eax ;daca nu mai exista numere de citit se inchid fisierele
	 js sfarsit
	 
	 mov ebx, x ;mut valoarea elementului citit in registrul ebx
	 imul ebx, a ; ebx<- ebx*a

	 push ebx ;afisez in fisier rezultatul inmultirii
	 push offset format_d
	 push edi
	 call fprintf
	 
	 push offset spatiu ;afisez spatiu " " intre elemente
	 push offset format_s
	 push edi
	 call fprintf
	 
	 mov ecx,i ;mut valoarea variabilei in registrul ecx
	 cmp ecx,n ;compar valoarea din registru cu numarul de linii/coloane
	 je endline ;in cazul in care sunt egale de afiseaza un "\n"
	 
	 xor ebx, ebx ;sterg valoarea din registrul ebx
     jmp equal ;ma intorc la eticheta

sfarsit:
push esi                    
call fclose ;inchid fisierul a.txt                 
add esp, 4 

push edi                    
call fclose ;inchid fisierul rezultat.txt               
add esp, 4   
 
endline:   
     mov i,0 ;initializeaza variabila cuantor cu 0
     push offset endl ;se trece pe linie noua
	 push offset format_s
	 push edi
	 call fprintf
	 jmp equal

open_error:
	push offset err ;afiseaza o eroare in cazul in care nu se poate deschide fisierul
	push offset format_s
	call printf
	add esp,8
	
endm

adunare_macro macro A, B

    push offset mode_write
    push offset file_name
    call fopen ;deschidere fisier rezultat in mod scriere
    add esp,8
	mov edi,eax ;muta pointerul din eax in registrul edi
	
    push offset mode_read
    push offset file_namea
    call fopen ;deschidere fisier a in mod citire
    add esp,8
	mov esi,eax ;muta pointerul din eax in registrul esi
	
	cmp esi,0 ;fopen returneaza 0 pe esi in caz de esec
	jz open_error1

	push offset mode_read
    push offset file_nameb
    call fopen ;deschidere fisier b in mod citire
	add esp,8
	mov ebp,eax ;muta pointerul din eax in registrul ebp
	
	cmp ebp,0 ;fopen returneaza 0 pe ebp in caz de esec
	jz open_error1
	
	 push offset n ;citesc numarul de linii/coloane din fisier
	 push offset format_d
	 push esi
	 call fscanf
	 add esp,12
	
equal1:
     inc i ;incrementez o variabila
     push offset x ;citesc pe rand fiecare numar al matricii din fisierul a.txt
	 push offset format_d
	 push esi
	 call fscanf
	 add esp,12
	 test eax, eax ;daca nu mai exista numere de citit se inchid fisierele
	 js sfarsit1
	 
	 push offset y ;citesc pe rand fiecare numar al matricii din fisierul b.txt
	 push offset format_d
	 push ebp
	 call fscanf
	 add esp,12
	 
	 mov ebx, x ;mut valoarea elementului citit din a.txt in registrul ebx
	 mov edx, y ;mut valoarea elementului citit din b.txt in registrul edx
	 add ebx, edx ;ebx<- ebx+edx

	 push ebx ;afisez in fisier rezultatul adunarii
	 push offset format_d
	 push edi
	 call fprintf
	 
	 push offset spatiu ;afisez spatiu " " intre elemente
	 push offset format_s
	 push edi
	 call fprintf
	 
	 mov ecx,i ;mut valoarea variabilei in registrul ecx
	 cmp ecx,n ;compar valoarea din registru cu numarul de linii/coloane
	 je endline1 ;in cazul in care sunt egale de afiseaza un "\n"
	 
	 xor ebx, ebx ;sterg valoarea din registrul ebx
     jmp equal1 ;ma intorc la eticheta

sfarsit1:
push esi                    
call fclose ;inchid fisierul a.txt                   
add esp, 4 

push edi                    
call fclose ;inchid fisierul rezultat.txt                 
add esp, 4   
 
endline1:   
     mov i,0 ;initializeaza variabila cuantor cu 0
     push offset endl ;se trece pe linie noua
	 push offset format_s
	 push edi
	 call fprintf
     jmp equal1
	 
open_error1:
	push offset err ;afiseaza o eroare in cazul in care nu se poate deschide fisierul
	push offset format_s
	call printf
	add esp,8
	
endm
scadere_macro macro A, B

    push offset mode_write
    push offset file_name
    call fopen ;deschidere fisier rezultat in mod scriere
	add esp,8
	mov edi,eax ;muta pointerul din eax in registrul edi
	
    push offset mode_read
    push offset file_namea
    call fopen ;deschidere fisier a in mod citire
	add esp,8
	mov esi,eax ;muta pointerul din eax in registrul esi
	
	cmp esi,0 ;fopen returneaza 0 pe esi in caz de esec
	jz open_error2

	push offset mode_read
    push offset file_nameb
    call fopen ;deschidere fisier b in mod citire
	add esp,8
	mov ebp,eax ;muta pointerul din eax in registrul ebp
	
	cmp ebp,0 ;fopen returneaza 0 pe ebp in caz de esec
	jz open_error2
	
	push offset n ;citesc numarul de linii/coloane din fisier
	 push offset format_d
	 push esi
	 call fscanf
	 add esp,12
	 
equal2:
     inc i ;incrementez o variabila
     push offset x ;citesc pe rand fiecare numar al matricii din fisierul a.txt
	 push offset format_d
	 push esi
	 call fscanf
	 add esp,12
	 test eax, eax ;daca nu mai exista numere de citit se inchid fisierele
	 js sfarsit2
	 
	 push offset y ;citesc pe rand fiecare numar al matricii din fisierul b.txt
	 push offset format_d
	 push ebp
	 call fscanf
	 add esp,12
	 
	 mov ebx, x ;mut valoarea elementului citit din fisierul a.txt in registrul ebx
	 mov edx, y ;mut valoarea elementului citit din fisierul b.txt in registrul edx
	 sub ebx, edx ;ebx<-ebx-edx

	 push ebx ;afisez in fisier rezultatul scaderii
	 push offset format_d
	 push edi
	 call fprintf
	 
	 push offset spatiu ;afisez spatiu " " intre elemente
	 push offset format_s
	 push edi
	 call fprintf
	 
	 mov ecx,i ;mut valoarea variabilei in registrul ecx
	 cmp ecx,n ;compar valoarea din registru cu numarul de linii/coloane
	 je endline2 ;in cazul in care sunt egale de afiseaza un "\n"
	 
	 xor ebx, ebx ;sterg valoarea din registrul ebx
     jmp equal2 ;ma intorc la eticheta

sfarsit2:
push esi                    
call fclose ;inchid fisierul a.txt                  
add esp, 4 

push edi                    
call fclose ;inchid fisierul rezultat.txt               
add esp, 4   
  
endline2:   
     mov i,0 ;initializeaza variabila cuantor cu 0
     push offset endl ;se trece pe linie noua
	 push offset format_s
	 push edi
	 call fprintf
	 jmp equal2

open_error2:
	push offset err ;afiseaza o eroare in cazul in care nu se poate deschide fisierul
	push offset format_s
	call printf
	add esp,8
endm

start:
	;aici se scrie codul
	push offset mesaj
    call printf ; > Introduceti o operatie cu matrici:
	add esp,4
	
	push offset mode_write
    push offset file_name
    call fopen ;deschidere fisier rezultat in mod scriere
	add esp,8
	
	cmp eax,0 ;daca pointerul la fisier e diferit de 0 se sare la open_good
	jnz open_good

open_good:
	push offset endl ;se trece pe linie noua
	push offset format_s 
	call printf
	add esp,8
	
	push offset mesaj_indic ;afiseaza >
	push offset format_s
	call printf
	add esp,8
	
	push offset expresie ;se citeste expresia
	push offset format_s
	call scanf
	add esp,8
	
scalar:
	cmp expresie, 'a' ;daca expresia nu incepe cu 'a' se sare la operatia de adunare
	jnz adunare
	
    push offset fisiera ;afiseaza A= pe ecren
	push offset format_s
	call printf
	add esp,8
	
    push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	push offset fisier_a ;afiseaza a.txt pe ecran
	push offset format_s
	call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	push offset mesaj_final ;afiseaza > pe ecran
	push offset format_s
	call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	scalar_macro a, A
	 
adunare:
	cmp expresie+1, '+' ;daca al doilea caracter al expresiei nu este + se sare la operatia de scadere
	jnz scadere
	
    push offset fisiera ;afiseaza A= pe ecran
	push offset format_s
	call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	push offset fisier_a ;afiseaza a.txt pe ecran
	push offset format_s
	call printf
	add esp,8
	
    push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8

    push offset fisierb ;afiseaza B= pe ecran
	push offset format_s
	call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	push offset fisier_b ;afiseaza b.txt pe ecran
	push offset format_s
	call printf
	add esp,8

	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
    add esp,8
	
	push offset mesaj_final ;afiseaza Rezultat:rezultat.txt pe ecran
	push offset format_s
	call printf
    add esp,8
	
	adunare_macro A, B
scadere:
	push offset fisiera ;afiseaza A= pe ecran
	push offset format_s
    call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	push offset fisier_a ;afiseaza a.txt pe ecran
	push offset format_s
	call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
    add esp,8
	
    push offset fisierb ;afiseaza B= pe ecran
	push offset format_s
	call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	push offset fisier_b ;afiseaza b.txt pe ecran
	push offset format_s
	call printf
	add esp,8
	
	push offset endl ;se trece pe linie noua
	push offset format_s
	call printf
	add esp,8
	
	push offset mesaj_final ;afiseaza Rezultat:rezultat.txt pe ecran
	push offset format_s
	call printf
	add esp,8
	
	scadere_macro A, B

	;terminarea programului
	push 0
	call exit
end start
