# 🛒 Análise de Clientes, Produtos e Fornecedores — E-commerce B2B

![SQL](https://img.shields.io/badge/SQL-Server-blue?style=flat-square&logo=microsoftsqlserver)
![Modelo](https://img.shields.io/badge/modelo-relacional-informational?style=flat-square)
![Período](https://img.shields.io/badge/período-Q1%202024-lightgrey?style=flat-square)

> Análise exploratória de um modelo relacional de e-commerce B2B com foco em comportamento de compra, performance de produtos e cobertura de fornecedores — usando SQL para responder perguntas reais de negócio.

---

## 🎯 Contexto

Num cenário B2B, entender **quem compra**, **o que compra** e **de onde vem o produto** é essencial para decisões comerciais. Este projeto parte de um modelo com 4 tabelas relacionadas e responde perguntas que surgem no dia a dia de times de dados, comercial e supply chain.

---

## 🗂️ Modelo de Dados

```
clientes ──────────────────┐
                           ▼
                        pedidos
                           ▲
produtos ──────────────────┘
    ▲
    │
fornecedores
```

| Tabela | Descrição | Registros |
|--------|-----------|-----------|
| `clientes` | Base de clientes com segmento e localização | 20 |
| `fornecedores` | Parceiros ativos e inativos | 6 |
| `produtos` | Catálogo com preço, estoque e vínculo ao fornecedor | 22 |
| `pedidos` | Transações do Q1 2024 com status e desconto | 30 |

---

## 🔍 Perguntas Respondidas

### 👤 Clientes
- Quais clientes geraram mais receita no período?
- Qual o ticket médio por segmento (Premium vs Standard)?
- Existem clientes cadastrados que nunca compraram? Quantos?

### 📦 Produtos
- Quais produtos lideram em receita e volume?
- Há produtos no catálogo sem nenhuma venda? Qual o risco de estoque parado?
- Qual categoria tem melhor desempenho?

### 🏭 Fornecedores
- Qual fornecedor contribui mais para a receita?
- Existem fornecedores inativos com produtos ainda em catálogo?
- Como está a cobertura de estoque por parceiro?

### 📊 Visão Executiva
- KPIs gerais do Q1: pedidos, receita, taxa de cancelamento
- Evolução mensal de receita — base para dashboard

---

## 📁 Estrutura do Repositório

```
sql-joins-pratica/
│
├── data/
│   ├── clientes.csv
│   ├── fornecedores.csv
│   ├── produtos.csv
│   └── pedidos.csv
│
├── scripts/
│   ├── setup.sql                    # Criação das tabelas e carga dos dados
│   └── analise_clientes_pedidos.sql # Todas as análises por bloco temático
│
└── README.md
```

---

## 💡 Destaques Técnicos

**INNER JOIN** — cruza apenas registros com correspondência em ambas as tabelas:
```sql
-- Receita por cliente considerando apenas pedidos concluídos
SELECT c.nome, c.segmento,
       SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0)) AS receita_total
FROM clientes c
INNER JOIN pedidos  p  ON c.id_cliente = p.id_cliente
INNER JOIN produtos pr ON p.id_produto = pr.id_produto
WHERE p.status = 'Concluído'
GROUP BY c.nome, c.segmento
ORDER BY receita_total DESC;
```

**LEFT JOIN** — mantém todos os registros da tabela à esquerda, mesmo sem correspondência. Essencial para identificar gaps:
```sql
-- Clientes sem nenhum pedido registrado
SELECT c.nome, c.email, c.segmento, c.data_cadastro
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_pedido IS NULL;
```

**LEFT JOIN com filtro na direita** — produtos sem vendas (estoque parado):
```sql
SELECT pr.nome_produto, pr.estoque, f.nome_fornecedor
FROM produtos pr
LEFT JOIN pedidos p ON pr.id_produto = p.id_produto
LEFT JOIN fornecedores f ON pr.fornecedor_id = f.id_fornecedor
WHERE p.id_pedido IS NULL;
```

---

## 🚀 Como Executar

```bash
# 1. Clone o repositório
git clone https://github.com/MileneCaldeira/sql-joins-pratica.git

# 2. No seu client SQL (SSMS, DBeaver, Azure Data Studio):
#    → Execute scripts/setup.sql para criar e carregar as tabelas
#    → Execute scripts/analise_clientes_pedidos.sql por bloco
```

Compatível com **SQL Server**, **PostgreSQL** e **MySQL**.  
Teste online em [db-fiddle.com](https://www.db-fiddle.com) sem instalação.

---

## 📅 Série: 28 Dias de Dados

| Dia | Projeto | Foco |
|-----|---------|------|
| ✅ 01 | [sql-consultas-basicas](https://github.com/MileneCaldeira/sql-consultas-basicas) | Filtragem e ordenação |
| ✅ 02 | [sql-joins-pratica](.) | Modelo relacional e cruzamento de tabelas |
| 🔜 03 | sql-agrupamentos | Agregações e métricas de negócio |
| 🔜 04 | sql-subqueries | Subconsultas para análises avançadas |
| 🔜 ... | ... | ... |

---

## 👩‍💻 Sobre

**Milene Caldeira** — BI Analyst com foco em dados comerciais, SQL, Power BI e cloud.

[![GitHub](https://img.shields.io/badge/GitHub-MileneCaldeira-black?style=flat-square&logo=github)](https://github.com/MileneCaldeira)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/milenecaldeira)
