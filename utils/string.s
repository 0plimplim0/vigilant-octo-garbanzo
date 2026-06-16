.intel_syntax noprefix

.global strcmp
strcmp:
  # strcmp(rdi = str1_start | rsi = str2_start | rdx = chars_limit(default=no_limit))
  #Prologue
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
