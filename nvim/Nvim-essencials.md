# Nvim-Essencials

Guia completo de Neovim para iniciantes absolutos, baseado na sua configuração pessoal (`init.lua`).

---

## 1. O que é o Neovim?

Neovim é um editor de texto moderno, um "fork" do Vim, que roda **dentro do terminal**. Ele é:

- **Modal** — as teclas fazem coisas diferentes dependendo do modo em que você está (normal, insert, visual, terminal)
- **Extensível** — quase tudo é configurável via Lua
- **Rápido** — inicia em milissegundos
- **Programável** — você pode automatizar qualquer tarefa de edição

A sua configuração usa o **lazy.nvim** como gerenciador de plugins (o equivalente ao TPM do Tmux). O arquivo principal é o `~/.config/nvim/init.lua`, que carrega tudo: opções, plugins, atalhos, templates e autocomandos.

---

## 2. Conceitos Fundamentais

### Os modos do Neovim

| Modo | O que é | Como entrar |
|---|---|---|
| **Normal (N)** | Modo padrão. Teclas executam comandos de edição | `Esc` |
| **Insert (I)** | Modo de digitação de texto | `i`, `a`, `o` |
| **Visual (V)** | Modo de seleção de texto | `v` (caractere), `V` (linha), `Ctrl+v` (bloco) |
| **Terminal (T)** | Terminal integrado dentro do Neovim | `:terminal` ou atalho do ToggleTerm |
| **Comando (C)** | Linha de comando (`:`, `/`, `?`) | `:` no modo normal |

### A hierarquia de janelas

```
Sessão do Neovim
 └── Janela (Window) — divisão da tela (split)
      └── Buffer — arquivo aberto na memória
```

- **Buffer**: um arquivo carregado. Pode estar aberto sem estar visível.
- **Janela (split)**: uma divisão da tela mostrando um buffer.
- **Tab**: um conjunto de janelas (a sua config usa bufferline, não tabs).

---

## 3. A Tecla Líder (Leader) e a Notação

### Sua configuração

- **Leader**: `Espaço` (Space) — configurado com `vim.g.mapleader = " "`
- **Local leader**: `Espaço` — configurado com `vim.g.maplocalleader = " "`

Quase todos os seus atalhos personalizados começam com `<leader>` (a tecla Espaço).

### Notação usada neste guia

| Notação | Significado |
|---|---|
| `<leader>` | Tecla **Espaço** |
| `<C-x>` | Segure `Ctrl` e pressione `x` |
| `<S-x>` | Segure `Shift` e pressione `x` |
| `<CR>` | Enter |
| `<Tab>` / `<S-Tab>` | Tab / Shift+Tab |
| `<Esc>` | Escape |
| `<C-\>` | Ctrl + `\` |

### Como ler um atalho

`<leader>ff` significa: pressione **Espaço**, solte, depois pressione `f` duas vezes.

> **Dica**: `timeoutlen = 300` significa que você tem 300ms para completar a sequência após o `<leader>`. Se demorar mais, o Neovim interpreta como o primeiro comando isolado.

---

## 4. Configurações Básicas (Opções)

Todas as opções abaixo estão definidas no `init.lua` (linhas 4–31):

| Opção | Valor | Efeito |
|---|---|---|
| `number` | `true` | Mostra números de linha |
| `relativenumber` | `false` | Números relativos **desligados** (só número absoluto) |
| `mouse` | `"a"` | Mouse ativo em todos os modos |
| `showmode` | `false` | Não mostra `-- INSERT --` (o lualine mostra o modo) |
| `clipboard` | `"unnamedplus"` | Yank/copy e paste usam o **clipboard do sistema** |
| `breakindent` | `true` | Linhas quebradas alinham com a indentação |
| `undofile` | `true` | Histórico de undo **persistente** entre sessões |
| `ignorecase` | `true` | Busca ignora maiúsculas/minúsculas |
| `smartcase` | `true` | Se a busca tiver maiúscula, vira sensível a caixa |
| `signcolumn` | `"yes"` | Coluna de sinais (git, diagnóstico) sempre visível |
| `updatetime` | `250` | Tempo (ms) para eventos de "CursorHold" (git, TODO) |
| `timeoutlen` | `300` | Tempo (ms) para completar sequências de teclas |
| `splitright` | `true` | Novos splits abrem **à direita** |
| `splitbelow` | `true` | Novos splits abrem **abaixo** |
| `list` | `true` | Mostra caracteres invisíveis |
| `listchars` | `tab="» "`, `trail="·"`, `nbsp="␣"` | Símbolos dos caracteres invisíveis |
| `inccommand` | `"split"` | Preview ao vivo de substituições (`:s/...`) |
| `cursorline` | `true` | Destaca a linha atual |
| `scrolloff` | `10` | Mantém 10 linhas de contexto ao rolar |
| `hlsearch` | `true` | Destaca resultados de busca |
| `termguicolors` | `true` | Cores truecolor (24-bit) |
| `expandtab` | `true` | Tab vira espaços |
| `tabstop` | `4` | Largura do tab = 4 |
| `shiftwidth` | `4` | Indentação = 4 espaços |
| `smartindent` | `true` | Indentação inteligente |

### O que isso significa na prática

- **Clipboard**: `y` copia para o clipboard do sistema e `p` cola de lá. (Requer um provedor como `xclip`, `wl-clipboard` ou `pbcopy`.)
- **Busca**: `/palavra` ignora caixa, mas `/Palavra` (com maiúscula) é sensível. `Esc` limpa o destaque.
- **Indentação**: 4 espaços, sem tabs. `>>` e `<<` indentam 4 espaços.
- **Undo persistente**: feche e reabra o Neovim — o `u` continua desfazendo.

---

## 5. Navegação de Arquivos (Neo-tree)

O **neo-tree.nvim** é o explorador de arquivos. Ele abre à **esquerda**, com **30 colunas** de largura, e **segue o arquivo atual** automaticamente.

### Atalhos configurados

| Atalho | Modo | O que faz |
|---|---|---|
| `<C-e>` | Normal | **Toggle** do explorador (abre/fecha) |
| `<C-f>` | Normal | **Foca** o explorador (move o cursor para ele) |

> **Nota**: `<C-e>` e `<C-f>` no modo normal foram **substituídos** — não fazem mais "scroll down" / "page down".

### Comportamento configurado

- `follow_current_file = true` — o explorador destaca o arquivo que você está editando
- `hijack_netrw_behavior = "open_current"` — ao abrir um diretório (`nvim .`), o Neo-tree abre mostrando o diretório atual
- O bufferline reserva um espaço ("File Explorer") para o explorador

### Atalhos padrão do plugin (dentro do explorador)

| Tecla | O que faz |
|---|---|
| `a` | Cria arquivo/pasta |
| `d` | Deleta |
| `r` | Renomeia |
| `x` / `y` / `p` | Recorta / copia / cola |
| `R` | Atualiza (refresh) |
| `H` | Mostra/oculta arquivos ocultos |
| `q` | Fecha o explorador |
| `?` | Ajuda com todos os atalhos |

---

## 6. Buffers (bufferline.nvim)

O **bufferline.nvim** mostra os buffers abertos como "abas" no topo da tela. A barra fica **sempre visível** e mostra os **diagnósticos LSP** de cada buffer.

### Atalhos configurados

| Atalho | Modo | O que faz |
|---|---|---|
| `<Tab>` | Normal | Próximo buffer |
| `<S-Tab>` | Normal | Buffer anterior |
| `<leader>bd` | Normal | **Deleta** o buffer atual |
| `<leader>bo` | Normal | Fecha **todos os outros** buffers |

> **Nota**: `<Tab>` no modo normal troca de buffer. No modo **insert**, `<Tab>` é usado pelo autocompletar (ver seção 12).

---

## 7. Busca com Telescope

O **telescope.nvim** é a ferramenta de busca "fuzzy" (busca difusa). Ele usa o **fzf-native** (compilado em C) para busca mais rápida — instalado automaticamente se `make` estiver disponível.

### Atalhos configurados

| Atalho | Modo | O que faz |
|---|---|---|
| `<leader>ff` | Normal | **Find Files** — busca arquivos do projeto |
| `<leader>fg` | Normal | **Live Grep** — busca texto dentro dos arquivos |
| `<leader>fb` | Normal | **Buffers** — lista buffers abertos |
| `<leader>fh` | Normal | **Help Tags** — busca na documentação do Vim |
| `<leader>fr` | Normal | **Recent Files** — arquivos abertos recentemente |

### Comportamento configurado

- `<C-u>` **habilitado** — meia página para cima na lista de resultados
- `<C-d>` **desabilitado** — meia página para baixo foi desligada de propósito

### Atalhos padrão dentro do Telescope

| Tecla | O que faz |
|---|---|
| `<C-n>` / `<C-p>` | Próximo / anterior resultado |
| `<C-j>` / `<C-k>` | Próximo / anterior resultado |
| `<CR>` | Seleciona o resultado |
| `<C-c>` | Fecha |
| `<C-u>` | Meia página para cima (configurado) |

---

## 8. Interface e Tema

### Tema — tokyonight

O tema **tokyonight-night** é aplicado automaticamente (carregado com prioridade máxima):

- Comentários em **itálico**
- Palavras-chave e funções em **negrito**

### Statusline — lualine

A barra inferior mostra: modo atual, nome do arquivo, branch git, diagnóstico, posição do cursor, etc. Tema automático (combina com o tokyonight), separadores `|`.

### Notificações — noice + nvim-notify

O **noice.nvim** moderniza a interface:

- **Linha de comando** (`:`) vira um **popup** estilizado
- **Mensagens** do Neovim viram **notificações** (nvim-notify)
- **Menu de autocompletar** usa o backend `nui`
- **Hover e assinatura LSP** aparecem em janelas estilizadas
- **Busca** (`/`) mostra o resultado como **virtualtext** (não no rodapé)
- Mensagens longas abrem em um **split** (`long_message_to_split`)
- **Command palette** habilitado — abra com `:NoiceCommandPalette`

O nvim-notify é configurado com: timeout de 3 segundos, altura/largura máximas de 75% da tela, fundo preto.

### Ajuda de atalhos — which-key

O **which-key.nvim** mostra um popup com os atalhos disponíveis quando você pressiona `<leader>` e espera um instante. Grupos configurados:

| Prefixo | Grupo |
|---|---|
| `<leader>c` | Code |
| `<leader>d` | Document |
| `<leader>f` | Find |
| `<leader>m` | Markdown |
| `<leader>w` | Workspace |
| `<leader>b` | Buffer |
| `<leader>t` | Terminal |
| `<leader>x` | Diagnostics |

### Guias de indentação — indent-blankline

Mostra linhas verticais (`│`) indicando o nível de indentação. O destaque de "escopo" está desligado.

### Colchetes coloridos — rainbow-delimiters

Parênteses, chaves e colchetes ganham **cores diferentes** por nível de aninhamento.

---

## 9. Treesitter (Sintaxe Avançada)

O **nvim-treesitter** fornece realce de sintaxe e indentação muito mais precisos que o Vim padrão.

### Configuração

- **Parsers instalados automaticamente**: `lua`, `python`, `c`, `cpp`, `java`, `vim`, `vimdoc`, `markdown`, `markdown_inline`
- **`auto_install = true`** — ao abrir um arquivo de uma linguagem sem parser, ele instala na hora
- **Highlight** habilitado
- **Indentação** habilitada

### Comandos úteis

| Comando | O que faz |
|---|---|
| `:TSInstall <linguagem>` | Instala um parser manualmente |
| `:TSUpdate` | Atualiza todos os parsers |
| `:TSInstallInfo` | Mostra parsers instalados/disponíveis |

---

## 10. LSP e Mason (Linguagens)

O **Mason** instala servidores de linguagem (LSP). O **mason-lspconfig** conecta cada servidor ao Neovim. O **nvim-lspconfig** configura os servidores.

### Servidores instalados automaticamente pelo Mason

| Servidor | Linguagem | Como é configurado |
|---|---|---|
| `jdtls` | Java | Pelo plugin `nvim-jdtls` (seção 11) |
| `clangd` | C / C++ | Pelo lspconfig |
| `pyright` | Python | Pelo lspconfig |
| `lua-language-server` | Lua | Pelo lspconfig |

### Configurações específicas dos servidores

- **clangd**: estilo de fallback **Google**, indentação 4, **tabs** (`UseTab: Always`), sem limite de coluna
- **lua_ls**: runtime **LuaJIT**, bibliotecas do Neovim carregadas, snippets de chamada com `Replace`
- **pyright**: configuração padrão

### Atalhos LSP (configurados no `LspAttach`)

Estes atalhos são **locais ao buffer** e só funcionam quando um servidor LSP está ativo no arquivo. Todos no **modo normal**:

| Atalho | O que faz |
|---|---|
| `gd` | Ir para **definição** (via Telescope) |
| `gr` | Ver **referências** (via Telescope) |
| `gI` | Ver **implementações** (via Telescope) |
| `gD` | Ir para **declaração** |
| `<leader>D` | **Definição de tipo** (via Telescope) |
| `<leader>ds` | **Símbolos** do documento (via Telescope) |
| `<leader>ws` | **Símbolos** do workspace (via Telescope) |
| `<leader>rn` | **Renomear** símbolo |
| `<leader>ca` | **Code action** (correções sugeridas) |
| `K` | **Hover** — documentação sob o cursor |

> **Nota**: `K` substitui o comportamento padrão (página de manual). `gd`, `gr`, `gI`, `gD` também são substituídos para usar o Telescope.

### Comandos do Mason

| Comando | O que faz |
|---|---|
| `<leader>cm` | Abre a interface do **Mason** |
| `:MasonInstall <pkg>` | Instala um servidor |
| `:MasonUninstall <pkg>` | Remove um servidor |
| `:MasonUpdate` | Atualiza o registro de pacotes |
| `:LspInfo` | Mostra servidores ativos no buffer |

---

## 11. Java com jdtls

O **nvim-jdtls** é carregado automaticamente ao abrir arquivos `.java` (`ft = "java"`).

### Comportamento configurado

- **Workspace por projeto**: cada projeto tem seu próprio diretório de workspace em `~/.local/share/nvim/site/java/workspace-root/<nome-do-projeto>`
- **Raiz do projeto** detectada por: `.git`, `mvnw` ou `gradlew`
- **Launcher jar** localizado automaticamente dentro dos pacotes do Mason (`org.eclipse.equinox.launcher_*.jar`)
- Configuração Linux (`config_linux`)
- Heap inicial de **1GB** (`-Xms1g`)
- Usa `start_or_attach` — inicia o servidor ou conecta se já estiver rodando

### Requisitos

- **Java instalado** no sistema (o comando `java` deve existir no PATH)
- O `jdtls` instalado via Mason (já está no `ensure_installed`)

### Comandos do jdtls (padrão do plugin)

| Comando | O que faz |
|---|---|
| `:JdtCompile` | Compila o projeto |
| `:JdtJunit` | Roda testes JUnit |
| `:JdtSetRuntime` | Define o runtime Java |
| `:JdtUpdateConfig` | Atualiza a configuração do projeto |
| `:JdtRestart` | Reinicia o servidor |
| `:JdtWipeDataAndRestart` | Limpa dados e reinicia (útil em bugs) |
| `:JdtShowLogs` | Mostra os logs do servidor |

---

## 12. Autocompletar, Snippets e Autopairs

### nvim-cmp — autocompletar

O **nvim-cmp** é o motor de autocompletar. Fontes de sugestão configuradas:

| Fonte | O que sugere |
|---|---|
| `nvim_lsp` | Símbolos do servidor LSP |
| `luasnip` | Snippets |
| `path` | Caminhos de arquivos |
| `buffer` | Palavras do buffer atual |

### Atalhos de autocompletar (modo insert)

| Atalho | O que faz |
|---|---|
| `<C-n>` / `<C-p>` | Próximo / anterior item |
| `<C-b>` / `<C-f>` | Rola a documentação (para cima/baixo) |
| `<C-y>` / `<CR>` | Confirma a seleção |
| `<C-Space>` | Abre o menu manualmente |
| `<Tab>` | Próximo item, ou **expande snippet**, ou pula para o próximo campo do snippet |
| `<S-Tab>` | Item anterior, ou volta para o campo anterior do snippet |

> **Nota**: `<Tab>` e `<S-Tab>` funcionam nos modos **insert e select**. Se o menu estiver aberto, navegam; se houver snippet, expandem/pulam; senão, fazem o comportamento padrão (tab).

### Snippets — LuaSnip + friendly-snippets

- **LuaSnip** é o motor de snippets
- **friendly-snippets** fornece milhares de snippets prontos no estilo VS Code (carregados sob demanda)
- Exemplo: digite `for` e pressione `<Tab>` para expandir um loop

### Autopairs — nvim-autopairs

Ao digitar `(`, `[`, `{`, `"`, `'`, o par de fechamento é criado automaticamente e o cursor fica dentro. Configuração padrão (sem customizações).

### Autocompletar na linha de comando

- **`:`** — sugere caminhos de arquivos e comandos
- **`/` e `?`** — sugere palavras do buffer para busca

---

## 13. Autosave e Formatação

### Autosave — autosave.nvim

O arquivo é salvo **automaticamente**:

| Opção | Valor | Efeito |
|---|---|---|
| `save_on_text_changed` | `true` | Salva quando o texto muda |
| `debounce_delay` | `500` | Espera 500ms após a última mudança |
| `save_in_insert` | `false` | **Não** salva enquanto você digita (só no modo normal) |
| `save_on_exit` | `true` | Salva ao sair |
| `silent` | `false` | Mostra notificação ao salvar |

**Excluídos do autosave** (não são salvos automaticamente):

- Tipos de buffer: `nofile`, `prompt`, `help`, `quickfix`, `terminal`
- Tipos de arquivo: `neo-tree`, `toggleterm`, `noice`, `trouble`, `TelescopePrompt`, `notify`, `dashboard`

> O plugin fornece o comando `:Autosave toggle` para ligar/desligar manualmente.

### Formatação ao salvar

Um autocomando (`BufWritePre`) formata o arquivo **antes de cada salvamento** — mas **somente se** um servidor LSP ativo suportar `textDocument/formatting`:

| Linguagem | Servidor | Formata ao salvar? |
|---|---|---|
| C / C++ | clangd | ✅ Sim |
| Lua | lua_ls | ✅ Sim |
| Java | jdtls | ✅ Sim |
| Python | pyright | ❌ Não (pyright não formata) |

> **Nota**: como o autosave salva sozinho, a formatação acontece automaticamente também. A formatação é **síncrona** (`async = false`).

---

## 14. Comentários (Comment.nvim)

O **Comment.nvim** comenta/descomenta código com um atalho. Configuração padrão:

| Atalho | Modo | O que faz |
|---|---|---|
| `gcc` | Normal | Comenta/descomenta a linha atual |
| `gc` | Visual | Comenta/descomenta a seleção |
| `gbc` | Normal | Comenta/descomenta em bloco |
| `gb` | Visual | Comenta/descomenta a seleção em bloco |

---

## 15. Diagnósticos e Trouble

### Navegação de diagnósticos (configurada)

| Atalho | Modo | O que faz |
|---|---|---|
| `]d` | Normal | Próximo diagnóstico |
| `[d` | Normal | Diagnóstico anterior |
| `gl` | Normal | Mostra o diagnóstico em janela flutuante |

### Trouble — lista de problemas

O **trouble.nvim** mostra erros/avisos em uma lista navegável.

| Atalho | Modo | O que faz |
|---|---|---|
| `<leader>xx` | Normal | Alterna a lista de **diagnósticos** (todos os buffers) |
| `<leader>xX` | Normal | Diagnósticos **do buffer atual** |
| `<leader>xL` | Normal | **Location list** |
| `<leader>xQ` | Normal | **Quickfix list** |
| `[q` | Normal | Item **anterior** na lista |
| `]q` | Normal | Próximo **item** na lista |

Comportamento configurado: a lista de diagnósticos **não abre nem fecha automaticamente** (`auto_open = false`, `auto_close = false`).

---

## 16. Git (gitsigns) e TODO Comments

### gitsigns.nvim — sinais de git

Mostra na coluna de sinais as mudanças em relação ao git:

| Sinal | Significado |
|---|---|
  `+` | Linha adicionada |
| `~` | Linha modificada |
| `_` | Linha deletada |
| `‾` | Linha deletada no topo |

## Atalhos padrão do gitsigns

| Atalho | O que faz |
|---|---|
| `]c` / `[c` | Próximo / anterior hunk (trecho alterado) |
| `<leader>hs` | **Stage** o hunk |
| `<leader>hr` | **Reset** o hunk |
| `<leader>hp` | **Preview** do hunk |
| `<leader>hu` | Desfaz o stage do hunk |
| `<leader>hd` | Diff do arquivo |
| `<leader>hb` | **Blame** da linha |

### todo-comments.nvim — comentários TODO

Destaca comentários como `TODO`, `FIXME`, `HACK`, `WARN`, `PERF`, `NOTE` com cores próprias.

### Atalhos padrão do todo-comments

| Atalho | O que faz |
|---|---|
| `]t` / `[t` | Próximo / anterior comentário TODO |
| `<leader>st` | Busca TODOs (via Telescope) |
| `<leader>xt` | Lista TODOs no Trouble |

---

## 17. Terminal Integrado (toggleterm.nvim)

O **toggleterm.nvim** abre um terminal dentro do Neovim.

### Atalhos configurados

| Atalho | Modo | O que faz |
|---|---|---|
| `<C-\>` | Normal e Terminal | Alterna o terminal (abre/fecha) |
| `<leader>tf` | Normal | Terminal **flutuante** |
| `<leader>th` | Normal | Terminal **horizontal** (15 linhas) |
| `<leader>tv` | Normal | Terminal **vertical** (40% da largura) |

### Comportamento configurado

- Direção padrão: **flutuante**, com borda curva
- Entra em modo **insert** automaticamente ao abrir
- Fecha automaticamente quando o processo termina (`close_on_exit`)
- Usa o shell padrão do sistema
- Números de linha ocultos no terminal

> **Dica**: dentro do terminal, `<C-\>` fecha o terminal. Para voltar ao modo normal dentro do terminal, use `<C-\><C-n>` (padrão do Neovim).

---

## 18. Clipboard

O clipboard do sistema está integrado de duas formas:

1. **`clipboard = "unnamedplus"`** — `y`, `p`, `d` já usam o clipboard do sistema automaticamente
2. **Atalhos explícitos**:

| Atalho | Modo | O que faz |
|---|---|---|
| `<leader>y` | Normal e Visual | Copia para o clipboard do sistema (`"+y`) |
| `<leader>p` | Normal e Visual | Cola do clipboard do sistema (`"+p`) |

> **Requisito**: no Linux, é preciso ter `xclip` ou `wl-clipboard` instalado.

---

## 19. Templates de Arquivo

Ao criar um arquivo novo, um template é inserido automaticamente e o cursor entra em modo insert.

### C++ (`*.cpp`)

```cpp
#include <bits/stdc++.h>

using namespace std;

int main() {
    
    return 0;
}
```

- Cursor posicionado dentro do `main` (linha 6, coluna 4)
- Entra em modo **insert** automaticamente

### Java (`*.java`)

```java
public class NomeDoArquivo {
    public static void main(String[] args) {
        
    }
}
```

- O nome da classe é o nome do arquivo com a **primeira letra maiúscula** (ex.: `main.java` → `public class Main`)
- Cursor posicionado dentro do `main` (linha 3, coluna 8)
- Entra em modo **insert** automaticamente

---

## 20. Autocomandos (Autocmds)

### Destaque ao copiar (TextYankPost)

Ao copiar texto (`y`), o trecho copiado fica **destacado** brevemente.

### Formatação ao salvar (BufWritePre)

Formata o arquivo antes de salvar se o LSP suportar (ver seção 13).

### Restaurar cursor ao sair (VimLeave)

Ao fechar o Neovim, o cursor do terminal volta ao formato **ibeam** (barra vertical).

---

## 21. Lista Completa de Plugins

### Plugins principais (configurados no `init.lua`)

| Plugin | O que faz | Configurado? |
|---|---|---|
| `folke/tokyonight.nvim` | Tema escuro "night" | ✅ Sim (estilo, itálico/negrito) |
| `HiPhish/rainbow-delimiters.nvim` | Colchetes coloridos | ✅ Sim (padrão) |
| `folke/noice.nvim` | UI moderna (cmdline popup, notificações) | ✅ Sim (extenso) |
| `rcarriga/nvim-notify` | Notificações bonitas | ✅ Sim (timeout, tamanho) |
| `nvim-neo-tree/neo-tree.nvim` | Explorador de arquivos | ✅ Sim (atalhos, posição, largura) |
| `akinsho/bufferline.nvim` | Barra de buffers no topo | ✅ Sim (atalhos, diagnóstico) |
| `nvim-lualine/lualine.nvim` | Statusline | ✅ Sim (tema, separadores) |
| `nvim-telescope/telescope.nvim` | Busca fuzzy | ✅ Sim (atalhos, mappings) |
| `nvim-treesitter/nvim-treesitter` | Sintaxe avançada | ✅ Sim (parsers, highlight, indent) |
| `williamboman/mason.nvim` | Instalador de LSP | ✅ Sim (servidores) |
| `neovim/nvim-lspconfig` | Configuração de LSP | ✅ Sim (servidores, atalhos) |
| `williamboman/mason-lspconfig.nvim` | Ponte Mason ↔ lspconfig | ✅ Sim (servidores) |
| `mfussenegger/nvim-jdtls` | LSP Java | ✅ Sim (workspace, cmd) |
| `hrsh7th/nvim-cmp` | Autocompletar | ✅ Sim (mappings, fontes) |
| `windwp/nvim-autopairs` | Fecha parênteses/chaves automaticamente | ✅ Sim (padrão) |
| `0x00-ketsu/autosave.nvim` | Salva automaticamente | ✅ Sim (debounce, exclusões) |
| `numToStr/Comment.nvim` | Comentários rápidos | ✅ Sim (padrão) |
| `lukas-reineke/indent-blankline.nvim` | Guias de indentação | ✅ Sim (caractere, escopo) |
| `folke/which-key.nvim` | Popup de atalhos | ✅ Sim (grupos) |
| `lewis6991/gitsigns.nvim` | Sinais de git | ✅ Sim (símbolos) |
| `folke/todo-comments.nvim` | Destaca TODO/FIXME | ✅ Sim (padrão) |
| `folke/trouble.nvim` | Lista de problemas | ✅ Sim (atalhos, auto_open) |
| `akinsho/toggleterm.nvim` | Terminal integrado | ✅ Sim (atalhos, direção, tamanho) |
| `MeanderingProgrammer/render-markdown.nvim` | Renderização de Markdown no buffer | ✅ Sim (opts padrão, atalho) |
| `iamcco/markdown-preview.nvim` | Preview do Markdown no navegador | ✅ Sim (comandos, atalho, build) |

### Dependências (instaladas automaticamente)

| Plugin | Para que serve |
|---|---|
| `nvim-lua/plenary.nvim` | Biblioteca de utilidades (Telescope, todo-comments) |
| `nvim-tree/nvim-web-devicons` | Ícones de arquivos |
| `MunifTanjim/nui.nvim` | Biblioteca de UI (noice, neo-tree) |
| `j-hui/fidget.nvim` | Indicador de progresso do LSP |
| `folke/neodev.nvim` | Configuração Lua para o lua_ls |
| `L3MON4D3/LuaSnip` | Motor de snippets |
| `saadparwaiz1/cmp_luasnip` | Fonte de snippets para o cmp |
| `hrsh7th/cmp-nvim-lsp` | Fonte LSP para o cmp |
| `hrsh7th/cmp-path` | Fonte de caminhos para o cmp |
| `hrsh7th/cmp-buffer` | Fonte do buffer para o cmp |
| `hrsh7th/cmp-cmdline` | Autocompletar na linha de comando |
| `rafamadriz/friendly-snippets` | Coleção de snippets prontos |
| `nvim-telescope/telescope-fzf-native.nvim` | Busca fzf em C (se `make` existir) |

---


## 22. Comandos Úteis

| Comando | O que faz |
|---|---|
| `:Lazy` | Abre o gerenciador de plugins |
| `:Lazy update` | Atualiza todos os plugins |
| `:Lazy sync` | Instala/atualiza conforme o `init.lua` |
| `:Mason` | Abre o instalador de LSP |
| `:TSUpdate` | Atualiza parsers do Treesitter |
| `:Telescope find_files` | Busca de arquivos (igual `<leader>ff`) |
| `:Neotree` | Abre o explorador |
| `:Trouble diagnostics toggle` | Abre a lista de diagnósticos |
| `:ToggleTerm` | Abre o terminal |
| `:NoiceCommandPalette` | Abre a paleta de comandos |
| `:Autosave toggle` | Liga/desliga o autosave |
| `:MarkdownPreview` | Abre o preview do Markdown no navegador |
| `:MarkdownPreviewStop` | Fecha o preview do Markdown |
| `:MarkdownPreviewToggle` | Alterna o preview do Markdown (abre/fecha) |
| `:RenderMarkdown toggle` | Alterna a renderização do Markdown no buffer |
| `:LspInfo` | Mostra servidores LSP ativos |
| `:checkhealth` | Diagnóstico completo da configuração |

---

## 23. Atalhos Gerais Configurados

| Atalho | Modo | O que faz |
|---|---|---|
| `<Esc>` | Normal | Limpa o destaque de busca |
| `<C-h>` | Normal | Foco na janela à esquerda |
| `<C-j>` | Normal | Foco na janela abaixo |
| `<C-k>` | Normal | Foco na janela acima |
| `<C-l>` | Normal | Foco na janela à direita |
| `<leader>w` | Normal | **Salva** o arquivo |
| `<leader>q` | Normal | **Fecha** a janela atual |

> **Nota**: `<C-h/j/k/l>` funcionam no modo **normal** (navegação entre splits). No modo insert, `<C-h>` continua sendo backspace.

---

## 24. Caveats e Observações

1. **`<leader>w` é salvar E prefixo de "Workspace"**: pressionar `<leader>w` sozinho salva o arquivo (após 300ms). Pressionar `<leader>w` seguido de outra tecla (ex.: `s` para `<leader>ws`) mostra os comandos do grupo Workspace. Não confunda.

2. **`<C-e>` e `<C-f>` no modo normal** foram substituídos pelo explorador de arquivos — não fazem mais scroll.

3. **`<Tab>` no modo normal** troca de buffer; no modo **insert** é usado pelo autocompletar/snippets.

4. **`K`** agora mostra hover LSP, não a página de manual.

5. **`gd`, `gr`, `gI`, `gD`** usam o Telescope (janela de resultados) em vez do salto direto.

6. **Python não é formatado ao salvar** — o pyright não suporta formatação.

7. **`relativenumber` está desligado** de propósito — só números absolutos.

8. **`wrap` não foi configurado** — o padrão do Neovim (quebrar linhas longas) permanece.

9. **Clipboard** depende de `xclip`/`wl-clipboard` no Linux.

10. **jdtls (Java)** exige Java instalado no sistema; o workspace é criado por projeto.

11. **fzf-native** só é compilado se `make` estiver disponível; sem ele, o Telescope funciona mais lento.

12. **Autosave não salva** buffers de terminal, help, quickfix, etc. (ver seção 13).

13. **`timeoutlen = 300`**: sequências com `<leader>` precisam ser digitadas em 300ms.

14. **`updatetime = 250`**: os sinais de git e os destaques TODO atualizam a cada 250ms de inatividade.

15. **Formatação ao salvar é síncrona** — arquivos grandes podem travar brevemente.

16. **Markdown tem dois modos independentes**: a renderização no buffer (`<leader>mr`) e o preview no navegador (`<leader>mp`) podem ser usados juntos ou separadamente — um não depende do outro.

17. **`<leader>mp` (preview no navegador)** requer **Node.js/npm** (para o build do plugin) e um **navegador** instalado no sistema. O preview não abre automaticamente — só com o atalho ou comando.

18. **`<leader>mr` (renderização no buffer)** requer os parsers `markdown` e `markdown_inline` do Treesitter (já incluídos no `ensure_installed`). A renderização é apenas visual — o texto-fonte permanece intacto e editável.

---

## 25. Fluxos de Trabalho Práticos

### Cenário 1: Dia de trabalho em um projeto

```text
# 1. Abrir o projeto
nvim .

# 2. Abrir o explorador de arquivos
<C-e>                    # toggle do Neo-tree
# Navegue com setas, Enter abre o arquivo

# 3. Buscar um arquivo pelo nome
<leader>ff               # digite parte do nome, Enter

# 4. Buscar texto dentro dos arquivos
<leader>fg               # digite o texto, Enter

# 5. Navegar entre buffers abertos
<Tab>                    # próximo buffer
<S-Tab>                  # buffer anterior
<leader>fb               # lista de buffers (Telescope)

# 6. Fechar buffers que não usa mais
<leader>bd               # fecha o buffer atual
<leader>bo               # fecha todos os outros
```

### Cenário 2: Edição com LSP (ex.: C++)

```text
# 1. Abrir um arquivo .cpp — o clangd inicia sozinho
# 2. Ir para a definição de uma função
gd

# 3. Ver quem usa essa função
gr

# 4. Renomear um símbolo em todo o projeto
<leader>rn               # digite o novo nome, Enter

# 5. Ver a documentação
K

# 6. Aplicar uma correção sugerida
<leader>ca

# 7. Ver erros e avisos
<leader>xx               # Trouble com todos os diagnósticos
]d                       # próximo diagnóstico
gl                       # detalhe do diagnóstico em janela flutuante
```

### Cenário 3: Terminal integrado

```text
# 1. Abrir um terminal flutuante
<C-\>                    # ou <leader>tf

# 2. Rodar um comando (ex.: compilar)
g++ main.cpp -o main

# 3. Fechar o terminal
<C-\>

# 4. Terminal horizontal (para ver código e terminal juntos)
<leader>th

# 5. Terminal vertical
<leader>tv
```

### Cenário 4: Git

```text
# 1. Ver as mudanças na coluna de sinais
#    + = adicionado, ~ = modificado, _ = deletado

# 2. Navegar entre trechos alterados
]c                       # próximo hunk
[c                       # hunk anterior

# 3. Stage de um trecho
<leader>hs

# 4. Ver o diff do arquivo
<leader>hd

# 5. Ver quem escreveu uma linha
<leader>hb               # blame
```

### Cenário 5: Java

```text
# 1. Criar um arquivo novo
:e Main.java             # template é inserido automaticamente

# 2. O jdtls inicia (requer Java instalado)
# 3. Compilar o projeto
:JdtCompile

# 4. Rodar testes
:JdtJunit

# 5. Se o servidor travar
:JdtWipeDataAndRestart
```

---

## 26. Markdown (renderização e preview)

O Neovim tem **dois modos independentes** para trabalhar com Markdown, ambos carregados automaticamente ao abrir um arquivo `.md` (`ft = "markdown"`):

1. **Renderização no buffer** — `render-markdown.nvim`
2. **Preview no navegador** — `markdown-preview.nvim`

Você pode usar os dois ao mesmo tempo, ou apenas um deles — eles não interferem entre si.

### Renderização no buffer — render-markdown.nvim

O **render-markdown.nvim** renderiza o Markdown **dentro do próprio buffer**, usando o Treesitter. Em vez de ver o texto cru (`# Título`, `**negrito**`, `- item`), você vê o resultado visual: títulos destacados, negrito/itálico aplicados, listas com marcadores, blocos de código com fundo próprio, etc.

- **`<leader>mr`** — alterna entre a **visualização renderizada** e o **texto cru** (toggle)
- O **código-fonte continua intacto e editável** — a renderização é apenas visual; o texto no arquivo não muda
- Ao desligar a renderização, o texto volta ao formato cru original

### Preview no navegador — markdown-preview.nvim

O **markdown-preview.nvim** abre o documento em um **navegador web**, com atualização automática conforme você edita e salva.

- **`<leader>mp`** — abre o preview no navegador; pressione de novo para **fechar** (toggle)
- O preview **não abre automaticamente** ao entrar no arquivo — só quando você pressiona `<leader>mp` ou usa um comando

### Comandos

| Comando | O que faz |
|---|---|
| `:MarkdownPreview` | Abre o preview no navegador |
| `:MarkdownPreviewStop` | Fecha o preview |
| `:MarkdownPreviewToggle` | Alterna o preview (abre/fecha) |
| `:RenderMarkdown toggle` | Alterna a renderização no buffer |

### Requisitos

- **Treesitter**: parsers `markdown` e `markdown_inline` (já incluídos no `ensure_installed`)
- **Node.js/npm**: necessários para o build do `markdown-preview.nvim` (`cd app && npm install`)
- **Navegador**: o preview abre no navegador padrão do sistema

### Instalação e atualização

Os dois plugins são gerenciados pelo **lazy.nvim**:

- **Instalar**: `:Lazy sync` (ou `:Lazy install`)
- **Atualizar**: `:Lazy update`
- O build do `markdown-preview.nvim` roda automaticamente na instalação/atualização

### Caveats

- A renderização no buffer depende do **highlight do Treesitter** estar ativo para Markdown
- O preview no navegador precisa que **Node/npm** estejam disponíveis; sem eles, o build falha
- O preview abre no **navegador padrão** do sistema — não há janela dentro do Neovim
- Os dois modos são **independentes**: você pode renderizar no buffer sem abrir o navegador, e vice-versa

---

## Referência Rápida

### Os atalhos que você mais vai usar

| Ação | Atalho | Modo |
|---|---|---|
| **Salvar arquivo** | `<leader>w` | Normal |
| **Fechar janela** | `<leader>q` | Normal |
| **Explorador de arquivos** | `<C-e>` | Normal |
| **Buscar arquivos** | `<leader>ff` | Normal |
| **Buscar texto** | `<leader>fg` | Normal |
| **Buffers abertos** | `<leader>fb` | Normal |
| **Arquivos recentes** | `<leader>fr` | Normal |
| **Próximo/anterior buffer** | `<Tab>` / `<S-Tab>` | Normal |
| **Deletar buffer** | `<leader>bd` | Normal |
| **Fechar outros buffers** | `<leader>bo` | Normal |
| **Ir para definição** | `gd` | Normal |
| **Referências** | `gr` | Normal |
| **Renomear símbolo** | `<leader>rn` | Normal |
| **Code action** | `<leader>ca` | Normal |
| **Hover (documentação)** | `K` | Normal |
| **Próximo/anterior diagnóstico** | `]d` / `[d` | Normal |
| **Diagnóstico em janela** | `gl` | Normal |
| **Lista de diagnósticos (Trouble)** | `<leader>xx` | Normal |
| **Comentar/descomentar linha** | `gcc` | Normal |
| **Comentar seleção** | `gc` | Visual |
| **Terminal flutuante** | `<C-\>` ou `<leader>tf` | Normal/Terminal |
| **Terminal horizontal** | `<leader>th` | Normal |
| **Terminal vertical** | `<leader>tv` | Normal |
| **Copiar para clipboard** | `<leader>y` | Normal/Visual |
| **Colar do clipboard** | `<leader>p` | Normal/Visual |
| **Limpar destaque de busca** | `<Esc>` | Normal |
| **Navegar entre splits** | `<C-h/j/k/l>` | Normal |
| **Próximo/anterior hunk git** | `]c` / `[c` | Normal |
| **Stage hunk** | `<leader>hs` | Normal |
| **Próximo/anterior TODO** | `]t` / `[t` | Normal |
| **Autocompletar (manual)** | `<C-Space>` | Insert |
| **Confirmar autocompletar** | `<CR>` ou `<C-y>` | Insert |
| **Expandir snippet / pular campo** | `<Tab>` | Insert |
| **Abrir Mason (LSP)** | `<leader>cm` | Normal |
| **Alternar renderização Markdown no buffer** | `<leader>mr` | Normal |
| **Alternar preview Markdown no navegador** | `<leader>mp` | Normal |
