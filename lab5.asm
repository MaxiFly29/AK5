TITLE Lab5

IDEAL
MODEL SMALL
STACK 512

DATASEG
array db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	  db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3

birthday1 db 2, 9, 0, 5, 2, 0, 0, 3
birthday2 db 2, 3, 0, 3, 2, 0, 0, 3

seed dw, 5430
seed2 dw, 24

CODESEG
PROC qsort                    ;void qsort(int *a, int first, int last)
        push    ax              ;{
        push    bx
        push    cx
        push    dx
        push    si
        push    di
 
        cmp     si,     di      ;  if (first < last)
        jae     @@StopQSort     ;  {
        push    di
        push    si
        ;mov si, si             ;        int left = first,
        ;mov di, di             ;        int right = last,
        mov     dx,     di      ;        int middle = a[(left + right) / 2];
        mov     cx,     si
        add si, di
		shr si, 1
        mov     ah,     [bx+si]
        mov     si,     cx
        mov     di,     dx
        @@DoWhile:              ;        do
                                ;        {
                                ;             while (a[left] > middle) left++;
                dec		si
                @@WhileLeft:
                        inc     si
                        mov     ch,     [bx+si]
                        cmp     ah,     ch
                jb      @@WhileLeft
                                ;             while (a[right] < middle) right--;
                inc     di
                @@WhileRight:
                        dec     di
                        mov     ch,     [bx+di]
                        cmp     ah,     ch
                ja      @@WhileRight
                                ;             if (left <= right)
                cmp     si,     di
                ja      @@BreakDoWhile
                                ;             {
                                ;                int tmp = s_arr[left];
                                ;                s_arr[left] = s_arr[right];
                                ;                s_arr[right] = tmp;
                mov     ch,     [bx+si]
                mov     dh,     [bx+di]
				
				cmp dh, ch
				
                mov     [bx+si],dh
                mov     [bx+di],ch
                                ;                left++;
                inc     si
                                ;                right--;
                dec     di
                                ;            }
                                ;        } while (left <= right);
                cmp     si,     di
        jbe     @@DoWhile
        @@BreakDoWhile:
                                ;        qs(s_arr, first, right);
        mov     cx,     si
        pop     si
        call    qsort
                                ;        qs(s_arr, left, last);
        mov     si,     cx
        pop     di
        call    qsort
@@StopQSort:
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
ENDP qsort

PROC Rand 			;Генератор псевдовипадкових чисел приймає мінімальне та максимальтне значення у рееєстрах si та di - відповідно
	push	cx
	push	dx
	push	di
 
	mov	dx, [seed]
	or	dx, dx
	jnz	@@
	in ax, 70h
	mov	dx, ax
@@:	
	mov	ax, [seed2]
	or	ax, ax
	jnz	@1
	in	ax, 40h
@1:		
	mul	dx
	inc	ax
	mov [seed], dx
	mov	[seed2], ax
 
	xor	dx, dx
	sub	di, si
	inc	di
	or di, di
	jnz @2
	inc di
@2:
	div	di
	mov	ax, dx
	add	ax, si
 
	pop	di
	pop	dx
	pop	cx
	ret
ENDP Rand		;На виході у реєстрі ax ми отримуємо випадкове число

Start:
	mov ax, @data
	mov ds, ax
	mov es, ax
	
	mov si, 0
	mov di, 0FFFFh
	mov cx, 16*16-1
	l2:
		call Rand
		mov si, cx
		mov [array + si], ah
		loop l2

	mov di, offset array + 10h * 2 + 2
	mov cx, 7
	l3:
		mov si, offset birthday1
		push cx
		mov cx, 8
		rep movsb
		add di, 10h - 8
		pop cx
		jcxz l4
		dec cx
		mov si, offset birthday1
		push cx
		mov cx, 8
		rep movsb
		add di, 10h - 8
		pop cx
		jcxz l4
		dec cx
		mov si, offset birthday2
		push cx
		mov cx, 8
		rep movsb
		pop cx
		add di, 10h - 8
		loop l3
l4:	
	
	mov si, 0
	mov di, 16*16-1
	mov bx, offset array
	call qsort
	
	mov ah, 4ch
	mov al, 0
	int 21h			;Вихід з програми з кодом 0
end Start