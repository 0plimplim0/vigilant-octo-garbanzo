.intel_syntax noprefix

.global strcmp
strcmp:
  # strcmp(rdi = str1_start | rsi = str2_start | rdx = chars_limit(default=no_limit))
  #Prologue
  push rbp
  mov rbp, rsp
  
  xor ecx, ecx      # iterator
.loop:
  cmp rdx, 0
  je .no_limit
  cmp rcx, rdx
  jb .no_limit
  xor eax, eax
  jmp .epilogue
.no_limit:
  cmp byte ptr [rdi+rcx], 0
  je .strend
  xor r8, r8
  mov r8b, byte ptr [rsi+rcx]
  cmp byte ptr [rdi+rcx], r8b
  jne .end0
  inc ecx
  jmp .loop

  # Epilogue
.epilogue:
  mov rsp, rbp
  pop rbp
  ret

.strend:
  cmp byte ptr [rsi+rcx], 0
  jne .end0
  xor eax, eax
  jmp .epilogue

.end0:
  mov eax, -1
  jmp .epilogue
