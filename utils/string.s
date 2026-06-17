.intel_syntax noprefix

.global strcmp
strcmp:
  # strcmp(rdi = str1_start | rsi = str2_start | rdx = chars_limit(default=no_limit))
  # Prologue
  push rbp
  mov rbp, rsp
  
  xor ecx, ecx      # iterator
.strcmp_loop:
  cmp rdx, 0
  je .strcmp_no_limit
  cmp rcx, rdx
  jb .strcmp_no_limit
  xor eax, eax
  jmp .strcmp_epilogue
.strcmp_no_limit:
  cmp byte ptr [rdi+rcx], 0
  je .strcmp_strend
  xor r8, r8
  mov r8b, byte ptr [rsi+rcx]
  cmp byte ptr [rdi+rcx], r8b
  jne .strcmp_end0
  inc ecx
  jmp .strcmp_loop

  # Epilogue
.strcmp_epilogue:
  mov rsp, rbp
  pop rbp
  ret

.strcmp_strend:
  cmp byte ptr [rsi+rcx], 0
  jne .strcmp_end0
  xor eax, eax
  jmp .strcmp_epilogue

.strcmp_end0:
  mov eax, -1
  jmp .strcmp_epilogue

.global strlen
strlen:
  # strlen(rdi = str_start | rsi = limiter(default=0x0))
  #Prologue
  push rbp
  mov rbp, rsp

  xor eax, eax      # iterator
.strlen_loop:
  cmp byte ptr [rdi+rax], sil
  je .strlen_end
  inc eax
  jmp .strlen_loop
.strlen_end:
  mov rsp, rbp
  pop rbp
  ret

.global findc
findc:
  # findc(rdi = str_start | rsi = char_obj) | Returns offset
  # Prologue
  push rbp
  mov rbp, rsp
  
  xor eax, eax      # iterator
.findc_loop:
  cmp byte ptr [rdi+rax], sil
  je .findc_epilogue
  inc eax
  jmp .findc_loop

.findc_epilogue:
  mov rsp, rbp
  pop rbp
  ret

.global strrev
strrev:
  # strrev(rdi = str_start | rsi = str_len)
  # Prologue
  push rbp
  mov rbp, rsp
  
  xor ecx, ecx      # Ptr1
  xor edx, edx      # Temp1
  xor r8d, r8d      # Temp2
  dec esi        # Ptr2
.strrev_loop:
  cmp ecx, esi
  jae .strrev_epilogue
  mov dl, byte ptr [rdi+rcx]
  mov r8b, byte ptr [rdi+rsi]
  mov byte ptr [rdi+rcx], r8b
  mov byte ptr [rdi+rsi], dl
  inc ecx
  dec esi
  jmp .strrev_loop

.strrev_epilogue:
  mov rsp, rbp
  pop rbp
  ret

.global atoi
atoi:
  # atoi(rdi = str_start)
  # Prologue
  push rbx
  push rbp
  mov rbp, rsp

  xor eax, eax      # Sum
  xor ecx, ecx      # Iterator
  mov ebx, 10
  xor esi, esi
.atoi_loop:
  mov sil, byte ptr [rdi+rcx]
  cmp sil, 0x0
  je .atoi_epilogue
  sub sil, 0x30
  mul rbx
  add eax, esi
  inc ecx
  jmp .atoi_loop

.atoi_epilogue:
  mov rsp, rbp
  pop rbp
  pop rbx
  ret

.global itoa
itoa:
  # itoa(rdi = integer | rsi = buff_start)
  # Prologue
  push rbx
  push rbp
  mov rbp, rsp
  
  xor ecx, ecx      # Temp 1
  xor edx, edx
  mov eax, edi
  xor edi, edi      # Iterator
  mov bl, 10
.itoa_loop:
  div bl
  mov cl, ah
  add cl, 0x30
  mov byte ptr [rsi+rdi], cl
  inc edi 
  cmp al, 0x0
  je .itoa_epilogue
  movzx ax, al
  jmp .itoa_loop

.itoa_epilogue:
  mov rcx, rdi
  mov rdi, rsi
  mov rsi, rcx
  call strrev
  mov rsp, rbp
  pop rbp
  pop rbx
  ret
