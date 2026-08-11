# RISC — CPU MIPS modificada em pipeline (Trabalho II)

Implementação de uma arquitetura RISC de 5 estágios em pipeline, descrita em Verilog e destinada a
FPGA da família **Cyclone IV GX**, conforme o roteiro do Trabalho II (`RISC.pdf`). Esta pasta segue
exatamente a estrutura de entrega (*deliverables*) exigida pelo roteiro.

## Arquitetura

- Word de 32 bits, **Big Endian**.
- Pipeline completo: Instruction Fetch, Instruction Decode, Execute, Memory, Write Back.
- Todas as instruções têm 4 bytes.
- 32 registradores (`r0`–`r31`); `r0` é *hard-wired* em 0.
- Memória de programa e memória de dados: 1 kWord cada, alocadas a partir de
  `Número do grupo * CteMemProg(h)` e `Número do grupo * CteMemDados(h)` respectivamente
  (fornecidos na tarefa do SIGAA). A decodificação de endereço para escolher entre memória
  interna/externa é feita pelos módulos `ADDRDecoding_Prog` (programa) e `ADDRDecoding` (dados).
- A cada *Reset*, o Program Counter aponta para o endereço inicial do grupo.
- Nas FPGAs Altera, as memórias BRAM são síncronas tanto para leitura quanto para escrita — por
  isso o pipeline real (fig. 1b do roteiro) tem menos registradores de estágio explícitos do que o
  pipeline MIPS "clássico" de 5 estágios (fig. 1a), já que parte desse registro já existe
  internamente nas BRAMs.
- Sinais em verde na fig. 1b (`branchFlag`, `branchOffset`, `jmpFlag`, `jmpAddress`, `zeroFlag`)
  controlam desvio de fluxo (BNE e JMP). Outros sinais de controle não estão todos representados
  no diagrama — ficam a critério da implementação.

## ISA (MIPS modificado)

Formato dos opcodes usa `Grupo` (número do grupo da disciplina) como base:

| Instrução | Mnemônico | Formato | Opcode/Encoding | Operação |
|---|---|---|---|---|
| Load Word | LW | I | Grupo+32 | `R[rt] = M[R[rs] + SignExtImm]` |
| Store Word | SW | I | Grupo+33 | `M[R[rs] + SignExtImm] = R[rt]` |
| Branch on Not Equal | BNE | I | Grupo+34 | `if (R[rs] != R[rt]) PC = PC + 4 + offset` |
| Add Immediate | ADDI | I | Grupo+35 | `R[rt] = R[rs] + SignExtImm` |
| Or Immediate | ORI | I | Grupo+36 | `R[rt] = R[rs] \| SignExtImm` |
| Add | ADD | R | Grupo+10 / calc 32 | `R[rd] = R[rs] + R[rt]` |
| Subtract | SUB | R | Grupo+10 / calc 34 | `R[rd] = R[rs] - R[rt]` |
| Multiplication | MUL | R | Grupo+10 / calc 50 | `R[rd] = lowerHW_R[rs] * lowerHW_R[rt]` |
| And | AND | R | Grupo+10 / calc 36 | `R[rd] = R[rs] & R[rt]` |
| Or | OR | R | Grupo+10 / calc 37 | `R[rd] = R[rs] \| R[rt]` |
| Jump | JMP | J | 2 | `PC = JumpADDR` |

Formato I: 6 bits opcode, 5 bits `rs`, 5 bits `rt`, 16 bits `offset`.
Formato R: 6 bits opcode, 5 bits `rs`, 5 bits `rt`, 5 bits `rd`, 5 bits (não usado), 6 bits `calc`.
Formato J: 6 bits opcode, 26 bits `JumpADDR`.

## Multiplicador (16 bits)

- A instrução `MUL` opera sobre os 16 bits menos significativos de `rs` e `rt`; o resultado (32
  bits) é armazenado em `rd`.
- O hardware é o multiplicador sequencial do Laboratório 4 (ACC + Adder + Counter + CONTROL),
  adaptado para operandos de 16 bits.
- Obrigatoriamente funciona num clock próprio (`CLK_MUL`), diferente do clock do sistema
  (`CLK_SYS`) — mesmo assim o sistema deve manter *throughput* de 1 instrução/clock.
- `CLK_SYS` e `CLK_MUL` são gerados pelo IP `ALTPLL` (pasta `PLL/`).
- Latência do multiplicador: `2N + 2` ciclos de `CLK_MUL` (N = nº de bits do operando, aqui 16),
  seguindo exatamente a máquina de estados do Lab04 (com estado `S0`/sinal `start` e estado
  `S3`/sinal `done`). Se algum desses sinais/estados for omitido, a latência cai para `2N + 1` ou
  `2N`.
- Como o multiplicador tem latência alta em relação ao pipeline do MIPS, a frequência máxima do
  sistema completo tende a ser limitada pela razão entre a frequência máxima do multiplicador e o
  número de ciclos de `CLK_MUL` que cabem dentro de um ciclo de `CLK_SYS` (ver seção de Avaliação).

## Estrutura da pasta (conforme deliverables do roteiro)

```
RISC/
├─ risc.v              — topo (descrição estrutural, liga todos os módulos)
├─ risc_TB.v            — testbench estrutural (instancia risc como DUT)
├─ datamemory.v / datamemory_TB.v
├─ Data.hex             — conteúdo inicial da memória de dados
├─ InstMem.v / InstMem_TB.v
├─ Code.hex             — programa codificado (memória de instruções)
├─ mux.v / mux_TB.v
├─ pc.v / pc_TB.v
├─ alu.v / alu_TB.v
├─ Multiplicador/       — arquivos direto na pasta (sem subpastas por módulo)
│  ├─ Multiplicador.v / Multiplicador_TB.v
│  ├─ Adder.v / Adder_TB.v
│  ├─ CONTROL.v / CONTROL_TB.v
│  ├─ Counter.v / Counter_TB.v
│  └─ ACC.v / ACC_TB.v
├─ control.v / control_TB.v
├─ registerfile.v / registerfile_TB.v
├─ extend.v / extend_TB.v
├─ register.v / register_TB.v
├─ ADDRDecoding.v / ADDRDecoding_TB.v         — decodificação de endereço (memória de dados)
├─ ADDRDecoding_Prog.v / ADDRDecoding_Prog_TB.v — decodificação de endereço (memória de programa)
└─ PLL/                 — arquivos gerados pelo IP ALTPLL (CLK_SYS e CLK_MUL)
```

`Code.hex` e `Data.hex` já sobem sintetizados com o conteúdo codificado — o testbench não faz
*boot* das memórias, elas já sobem inicializadas.

## Testes

- Programa de teste gerado com o assembler disponível em
  [odutra00/assemblerRISC](https://github.com/odutra00/assemblerRISC).
- `risc_TB` deve expor entradas/saídas e sinais internos com os nomes exatamente como na fig. 1b do
  roteiro (usando `$init_signal_spy` e `(*keep=1*)` para preservar nomes de sinais internos também
  na simulação Gate Level).
- Simulação obrigatoriamente em **Gate Level** (mais fiel, considera os atrasos dos gates); a
  simulação RTL não reflete timing real e por isso não vale como validação final.
- O clock aplicado no testbench para a PLL deve ser igual ao definido como entrada da PLL no IP
  Catalog, e a frequência de simulação deve respeitar a máxima frequência de operação encontrada no
  TimeQuest.

## Avaliação (responder como comentário no início de `risc.v`)

1. Qual a latência do sistema?
2. Qual o *throughput* do sistema?
3. Qual a máxima frequência operacional (TimeQuest) para o multiplicador e para o sistema?
   (indicar a FPGA usada)
4. Qual a máxima frequência de operação do sistema? (indicar a FPGA usada)
5. Há problemas de metaestabilidade entre os dois domínios de clock? Por quê?
6. O multiplicador utilizado é eficiente em velocidade para este sistema? Por quê?
7. Que modificações tornariam o sistema mais rápido? Qual a nova latência/throughput para cada
   modificação sugerida?

## Notas

- Esta pasta corresponde à estrutura de entrega exigida no roteiro (item *Deliverables*): pasta
  `RISC` zipada, com `risc.v`/`risc_TB.v` como topo/testbench e os módulos do multiplicador soltos
  dentro de `Multiplicador/` (sem subpastas por módulo, diferente do Trabalho 1).
- Os arquivos de projeto Quartus (`.qpf`/`.qsf`/`.qws`) e artefatos de build/simulação
  (`db/`, `incremental_db/`, `output_files/`, `simulation/`) não fazem parte da entrega e não
  ficam nesta pasta — eles são recriados localmente ao abrir/compilar o projeto no Quartus.
