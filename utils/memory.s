.intel_syntax noprefix

.global memset
memset:
  # memset(rdi = frame_start | rsi = n_bytes | rdx = byte)
  # Prologue
  push rbp
  mov rbp, rsp
  
  # Setup
  xor ecx, ecx      # Iterator
  mov rax, 0x0101010101010101
  imul rax, rdx     # RAX = Container(?)
  mov r8, rsi      # Temp

.memset_loop:
  cmp rcx, rsi
  jae .memset_epilogue
  cmp r8, 8
  jb .memset_n64b
  mov [rdi+rcx], rax
  add rcx, 8
  sub r8, 8
  jmp .memset_loop
.memset_n64b:
  mov byte ptr [rdi+rcx], al
  inc rcx
  jmp .memset_loop

.memset_epilogue:
  mov rax, rcx
  mov rsp, rbp
  pop rbp
  ret
