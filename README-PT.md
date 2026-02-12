# Tech Playground Challenge

**[English version (README.md)](README.md)**

Bem-vindo ao **Tech Playground Challenge**!

## Sobre o desafio

Esta é a sua oportunidade de mergulhar em um conjunto de dados real e criar algo extraordinário. Seja sua paixão análise de dados, visualização, desenvolvimento backend ou exploração criativa, há uma tarefa aqui perfeita para você. Escolha os desafios que mais te animam e deixe suas habilidades brilharem!

## Como participar

- **Escolha suas tarefas**: Selecione qualquer tarefa da lista abaixo que desperte seu interesse. Você pode escolher quantas quiser.
- **Mostre suas habilidades**: Foque em soluções de alta qualidade e bem pensadas.
- **Use suas ferramentas favoritas**: Sinta-se à vontade para usar qualquer linguagem, framework ou ferramenta com que se sinta confortável.

## Visão geral do conjunto de dados

O conjunto de dados fornecido (`data.csv`) contém feedback de colaboradores com campos em português. Os dados incluem:

- **nome**
- **email**
- **email_corporativo**
- **celular** (Celular)
- **area** (Departamento)
- **cargo** (Cargo)
- **funcao** (Função)
- **localidade** (Localidade)
- **tempo_de_empresa** (Tempo de empresa)
- **genero** (Gênero)
- **geracao** (Geração)
- **n0_empresa** (Nível 0 - Empresa)
- **n1_diretoria** (Nível 1 - Diretoria)
- **n2_gerencia** (Nível 2 - Gerência)
- **n3_coordenacao** (Nível 3 - Coordenação)
- **n4_area** (Nível 4 - Área)
- **Data da Resposta**
- **Interesse no Cargo**
- **Comentários - Interesse no Cargo**
- **Contribuição**
- **Comentários - Contribuição**
- **Aprendizado e Desenvolvimento**
- **Comentários - Aprendizado e Desenvolvimento**
- **Feedback**
- **Comentários - Feedback**
- **Interação com Gestor**
- **Comentários - Interação com Gestor**
- **Clareza sobre Possibilidades de Carreira**
- **Comentários - Clareza sobre Possibilidades de Carreira**
- **Expectativa de Permanência**
- **Comentários - Expectativa de Permanência**
- **eNPS** (Employee Net Promoter Score)
- **[Aberta] eNPS** (Comentários abertos - eNPS)

**Observação**: Como os dados estão em português, pode ser necessário tratar o texto adequadamente, principalmente em tarefas de análise de texto ou análise de sentimento.

## Conceitos importantes

Esta seção explica conceitos relacionados ao conjunto de dados para que você tenha clareza sobre os termos usados:

### 1. **Escala Likert**
A escala Likert é uma forma comum de medir atitudes ou opiniões. Os respondentes geralmente avaliam seu grau de concordância ou discordância com uma afirmação em uma escala (usamos de 1 a 5). Por exemplo:
- 1: Discordo totalmente
- 2: Discordo
- 3: Neutro
- 4: Concordo
- 5: Concordo totalmente

Neste conjunto de dados, escalas Likert são usadas para capturar feedback sobre diversos aspectos, como clareza de carreira, interação com o gestor e oportunidades de aprendizado.

---

### 2. **Favorabilidade**
Favorabilidade mede a porcentagem de respostas positivas a uma pergunta da pesquisa. Por exemplo:
- Em uma escala Likert de 5 pontos:
  - Respostas 4 (Concordo) e 5 (Concordo totalmente) são consideradas favoráveis.
  - Resposta 3 (Neutro) é considerada neutra.
  - Respostas 1 (Discordo totalmente) e 2 (Discordo) são consideradas desfavoráveis.

A favorabilidade ajuda a identificar áreas em que os colaboradores se sentem positivos em relação à sua experiência.

---

### 3. **Net Promoter Score (NPS)**
O NPS é uma métrica usada para medir lealdade e satisfação, frequentemente representada por um número entre -100 e 100. Baseia-se na pergunta:
*"De 0 a 10, qual a probabilidade de você recomendar esta empresa como um ótimo lugar para trabalhar?"*
- Os respondentes são categorizados como:
  - **Promotores** (9-10): Entusiastas leais que recomendam a empresa.
  - **Passivos** (7-8): Respondentes neutros.
  - **Detratores** (0-6): Respondentes insatisfeitos que podem desencorajar outros.
- **Cálculo**:

```
NPS = (% Promotores) - (% Detratores)
```

O NPS fornece uma visão do sentimento geral dos colaboradores em uma escala de -100 (100% detratores) a +100 (100% promotores), em que quanto maior, melhor.

---

### 4. **Conversão da pesquisa**
Conversão da pesquisa refere-se à porcentagem de colaboradores que concluíram a pesquisa entre os que foram convidados a participar. Por exemplo:
- Se 500 colaboradores foram convidados e 350 concluíram a pesquisa, a taxa de conversão é:

```
Taxa de conversão = (350 / 500) * 100 = 70%
```

Uma alta taxa de conversão indica boa participação e engajamento com o processo da pesquisa.

---

### Como esses conceitos se aplicam
Essas métricas são essenciais para entender o conjunto de dados e obter insights acionáveis. Ao trabalhar no desafio, considere como as respostas em escala Likert, a favorabilidade, o NPS e a conversão da pesquisa refletem o sentimento dos colaboradores e ajudam a embasar decisões.

---

## Lista de tarefas

Selecione as tarefas que deseja realizar marcando com um `X` entre os colchetes `[ ]`.

### **Suas tarefas selecionadas**

- [ ] **Tarefa 1**: Criar um banco de dados básico
- [ ] **Tarefa 2**: Criar um dashboard básico
- [ ] **Tarefa 3**: Criar uma suíte de testes
- [ ] **Tarefa 4**: Criar configuração Docker Compose
- [ ] **Tarefa 5**: Análise exploratória de dados
- [ ] **Tarefa 6**: Visualização de dados - Nível empresa
- [ ] **Tarefa 7**: Visualização de dados - Nível área
- [ ] **Tarefa 8**: Visualização de dados - Nível colaborador
- [ ] **Tarefa 9**: Construir uma API simples
- [ ] **Tarefa 10**: Análise de sentimento
- [ ] **Tarefa 11**: Geração de relatórios
- [ ] **Tarefa 12**: Exploração criativa

---

## Descrição das tarefas

### **Tarefa 1: Criar um banco de dados básico**

**Objetivo**: Projetar e implementar um banco de dados para estruturar os dados do arquivo CSV.

**Requisitos**:

- Escolher um sistema de banco de dados adequado (relacional ou não relacional), como MySQL, PostgreSQL, MongoDB, etc.
- Projetar um schema ou modelo de dados que represente com precisão os dados, considerando os nomes dos campos em português.
- Escrever scripts ou usar ferramentas para importar os dados do CSV para o banco.
- Garantir integridade dos dados e tipos adequados para cada campo.
- Fornecer scripts ou configurações de criação do banco e instruções de configuração.

**Bônus**:

- Implementar indexação ou outras otimizações para consultas mais rápidas.
- Organizar os dados de forma eficiente para reduzir redundância e melhorar a velocidade de acesso.

---

### **Tarefa 2: Criar um dashboard básico**

**Objetivo**: Desenvolver um dashboard simples para exibir insights importantes dos dados.

**Requisitos**:

- Usar qualquer tecnologia de frontend (ex.: HTML/CSS, JavaScript, React, Angular, Vue.js).
- Conectar o dashboard ao seu banco de dados ou usar o arquivo CSV diretamente.
- Exibir métricas principais como:
  - Número de colaboradores por departamento (**area**).
  - Médias dos scores de feedback.
  - Distribuição do eNPS.
- Incluir elementos interativos como filtros por departamento (**area**) ou cargo (**cargo**).
- Garantir que o dashboard seja fácil de usar e visualmente atraente.

**Bônus**:

- Implementar design responsivo para uso em mobile.
- Adicionar visualizações avançadas com bibliotecas de gráficos (ex.: D3.js, Chart.js).

---

### **Tarefa 3: Criar uma suíte de testes**

**Objetivo**: Escrever testes para garantir a confiabilidade e a correção do código.

**Requisitos**:

- Usar um framework de testes adequado à linguagem escolhida (ex.: pytest para Python, JUnit para Java, Jest para JavaScript).
- Escrever testes unitários para funções ou componentes principais.
- Incluir testes para casos extremos e tratamento de erros.
- Fornecer instruções para executar os testes.

**Bônus**:

- Alcançar alta cobertura de código.
- Implementar testes de integração para testar a interação entre componentes.

---

### **Tarefa 4: Criar configuração Docker Compose**

**Objetivo**: Containerizar sua aplicação e seus serviços com Docker Compose.

**Requisitos**:

- Escrever um `Dockerfile` para sua aplicação.
- Criar um arquivo `docker-compose.yml` para definir os serviços (ex.: servidor da aplicação, banco de dados).
- Garantir que `docker-compose up` configure todo o ambiente.
- Fornecer instruções para build e execução dos containers.

**Bônus**:

- Usar variáveis de ambiente para configuração.
- Implementar multi-stage builds para otimizar o tamanho da imagem.

---

### **Tarefa 5: Análise exploratória de dados**

**Objetivo**: Analisar o conjunto de dados para extrair insights relevantes.

**Requisitos**:

- Calcular estatísticas resumidas (média, mediana, moda, etc.) para os campos numéricos.
- Identificar tendências ou padrões (ex.: média dos scores de feedback por departamento (**area**)).
- Visualizar os principais achados com gráficos.
- Fornecer um breve relatório resumindo seus insights.

---

### **Tarefa 6: Visualização de dados - Nível empresa**

**Objetivo**: Criar visualizações que forneçam insights em nível de empresa.

**Requisitos**:

- Desenvolver pelo menos duas visualizações que representem dados de toda a empresa.
- Exemplos incluem:
  - Scores gerais de satisfação dos colaboradores.
  - eNPS da empresa como um todo.
  - Distribuição do tempo de empresa entre todos os colaboradores.
- Garantir que as visualizações sejam claras, legendadas e fáceis de entender.
- Explicar o que cada visualização revela sobre a empresa.

**Bônus**:

- Usar dashboards interativos ou técnicas avançadas de visualização.
- Incorporar análise de série temporal se houver dados temporais.

---

### **Tarefa 7: Visualização de dados - Nível área**

**Objetivo**: Criar visualizações focadas em áreas ou departamentos específicos da empresa.

**Requisitos**:

- Desenvolver pelo menos duas visualizações com insights em nível de área ou departamento.
- Exemplos incluem:
  - Média dos scores de feedback por departamento (**area**).
  - eNPS segmentado por departamento.
  - Comparação das expectativas de carreira entre diferentes áreas.
- Incluir elementos interativos como filtros ou hover para exibir mais informações.
- Garantir que as visualizações sejam claras, legendadas e fáceis de entender.
- Explicar o que cada visualização revela sobre as diferentes áreas.

**Bônus**:

- Destacar diferenças ou tendências significativas entre departamentos.
- Sugerir possíveis razões para os padrões observados com base nos dados.

---

### **Tarefa 8: Visualização de dados - Nível colaborador**

**Objetivo**: Criar visualizações focadas nos dados de cada colaborador.

**Requisitos**:

- Desenvolver visualizações que forneçam insights em nível de colaborador.
- Exemplos incluem:
  - Scores de feedback de um colaborador em diferentes categorias.
  - Perfil resumindo tempo de empresa, cargo e feedback do colaborador.
  - Comparação dos scores do colaborador com as médias do departamento ou da empresa.
- Respeitar a privacidade (ex.: anonimizar dados quando necessário).
- Explicar como essas visualizações podem ser usadas para desenvolvimento ou gestão de pessoas.

**Bônus**:

- Criar um template que gere relatórios individuais para qualquer colaborador.
- Incluir recomendações ou ações com base nos dados.

---

### **Tarefa 9: Construir uma API simples**

**Objetivo**: Desenvolver uma API para servir dados do conjunto de dados.

**Requisitos**:

- Implementar pelo menos um endpoint que retorne dados em formato JSON.
- Usar qualquer framework ou linguagem com que você se sinta confortável.
- Incluir instruções para executar e testar a API.

**Bônus**:

- Implementar vários endpoints para diferentes consultas.
- Incluir paginação ou opções de filtro.

---

### **Tarefa 10: Análise de sentimento**

**Objetivo**: Realizar análise de sentimento nos campos de comentários.

**Requisitos**:

- Pré-processar o texto (ex.: tokenização, remoção de stop words).
- Usar qualquer método ou biblioteca para analisar sentimento em português (ex.: NLTK com suporte a português, spaCy com modelos em português).
- Resumir o sentimento geral e fornecer exemplos.
- Documentar sua abordagem e achados.

**Observação**: Como os comentários estão em português, garanta que suas ferramentas e métodos suportem o processamento de texto em português.

---

### **Tarefa 11: Geração de relatórios**

**Objetivo**: Gerar um relatório destacando aspectos principais dos dados.

**Requisitos**:

- Incluir tabelas, gráficos ou figuras que sustentem seus achados.
- Resumir métricas importantes como eNPS ou tendências de feedback.
- O relatório pode ser em qualquer formato (PDF, Markdown, HTML).

---

### **Tarefa 12: Exploração criativa**

**Objetivo**: Explorar o conjunto de dados da forma que lhe interessar.

**Requisitos**:

- Levantar uma pergunta ou hipótese relacionada aos dados.
- Usar os dados para responder à pergunta ou testar a hipótese.
- Documentar seu processo, achados e conclusões.

---

## Começando

1. **Baixe o conjunto de dados**: Acesse o arquivo `data.csv` no repositório.
2. **Escolha sua jornada**: Selecione as tarefas que te animam e marque-as na lista acima.
3. **Crie seu trabalho**: Desenvolva suas soluções com as ferramentas e tecnologias de sua preferência.
4. **Compartilhe**: Organize seu código e documentação e prepare-se para mostrar o que construiu.
5. **Atenção**: Não inclua informações sensíveis no repositório (ex.: chaves de API, dados pessoais).

## Diretrizes de submissão

- **Crie um novo repositório**: Use uma plataforma como GitHub, GitLab ou Bitbucket para hospedar seu repositório.
- **Código e arquivos**: Inclua todo o código, scripts e demais arquivos usados na sua solução.
- **README**: Forneça um README que:
  - Liste as tarefas que você concluiu.
  - Explique como executar o código e visualizar os resultados.
  - Comente premissas ou decisões que você tomou.
- **Documentação**: Inclua relatórios ou visualizações que você criou.
- **Instruções**: Forneça instruções claras para configurar e rodar o projeto.
- **Compartilhe seu repositório**: Envie o link do repositório conforme as instruções de submissão.

## Solte a criatividade!

Este é mais do que um desafio—é um playground para suas ideias. Sinta-se à vontade para ir além das tarefas, dar seu toque pessoal e se divertir explorando as possibilidades!

---

Esperamos que você aproveite o desafio e estamos ansiosos para ver o que você criar. Bom código!
