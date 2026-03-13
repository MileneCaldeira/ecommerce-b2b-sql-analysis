-- ============================================================
-- ANÁLISE: Comportamento de Clientes, Produtos e Fornecedores
-- Modelo: E-commerce B2B | Q1 2024
-- Autor: Milene Caldeira
-- ============================================================
-- Todas as análises cruzam múltiplas tabelas via JOIN.
-- O modelo relacional é: pedidos ←→ clientes, produtos ←→ fornecedores
-- ============================================================


-- ============================================================
-- BLOCO 1: VISÃO COMERCIAL — Pedidos com contexto completo
-- ============================================================

-- Qual foi o histórico de pedidos com informações de cliente e produto?
-- Base para qualquer análise de receita ou comportamento.
SELECT
    p.id_pedido,
    p.data_pedido,
    c.nome                                           AS cliente,
    c.segmento,
    pr.nome_produto,
    pr.categoria,
    p.quantidade,
    pr.preco,
    p.desconto_pct,
    ROUND(
        pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0), 2
    )                                                AS receita_liquida,
    p.status
FROM pedidos p
INNER JOIN clientes c  ON p.id_cliente = c.id_cliente
INNER JOIN produtos pr ON p.id_produto = pr.id_produto
ORDER BY p.data_pedido;


-- ============================================================
-- BLOCO 2: ANÁLISE DE CLIENTES — Quem compra, quanto e com que frequência
-- ============================================================

-- Receita e volume por cliente — identifica os mais valiosos
SELECT
    c.nome,
    c.segmento,
    c.estado,
    COUNT(p.id_pedido)                                             AS total_pedidos,
    SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS receita_total,
    AVG(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS ticket_medio
FROM clientes c
INNER JOIN pedidos p  ON c.id_cliente = p.id_cliente
INNER JOIN produtos pr ON p.id_produto = pr.id_produto
WHERE p.status = 'Concluído'
GROUP BY c.nome, c.segmento, c.estado
ORDER BY receita_total DESC;


-- Clientes cadastrados que ainda não realizaram nenhum pedido
-- Oportunidade de ativação / reengajamento
SELECT
    c.nome,
    c.email,
    c.segmento,
    c.data_cadastro
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_pedido IS NULL
ORDER BY c.data_cadastro;


-- Comparativo de receita entre segmentos Premium vs Standard
SELECT
    c.segmento,
    COUNT(DISTINCT c.id_cliente)                                   AS clientes_ativos,
    COUNT(p.id_pedido)                                             AS pedidos_concluidos,
    SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS receita_total,
    AVG(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS ticket_medio
FROM clientes c
INNER JOIN pedidos p   ON c.id_cliente = p.id_cliente
INNER JOIN produtos pr ON p.id_produto = pr.id_produto
WHERE p.status = 'Concluído'
GROUP BY c.segmento;


-- ============================================================
-- BLOCO 3: ANÁLISE DE PRODUTOS — Performance e giro de catálogo
-- ============================================================

-- Produtos com receita e volume de pedidos — ranking de performance
SELECT
    pr.nome_produto,
    pr.categoria,
    pr.preco                                                       AS preco_unitario,
    COUNT(p.id_pedido)                                             AS pedidos,
    SUM(p.quantidade)                                              AS unidades_vendidas,
    SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS receita_gerada
FROM produtos pr
INNER JOIN pedidos p ON pr.id_produto = p.id_produto
WHERE p.status = 'Concluído'
GROUP BY pr.nome_produto, pr.categoria, pr.preco
ORDER BY receita_gerada DESC;


-- Produtos do catálogo que nunca foram pedidos
-- Ajuda a identificar itens sem giro para revisão de mix
SELECT
    pr.nome_produto,
    pr.categoria,
    pr.preco,
    pr.estoque,
    f.nome_fornecedor
FROM produtos pr
LEFT JOIN pedidos p ON pr.id_produto = p.id_produto
LEFT JOIN fornecedores f ON pr.fornecedor_id = f.id_fornecedor
WHERE p.id_pedido IS NULL
ORDER BY pr.categoria;


-- Receita por categoria de produto
SELECT
    pr.categoria,
    COUNT(DISTINCT pr.id_produto)                                  AS produtos_vendidos,
    SUM(p.quantidade)                                              AS unidades_vendidas,
    SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS receita_total,
    AVG(pr.preco)                                                  AS preco_medio_categoria
FROM produtos pr
INNER JOIN pedidos p ON pr.id_produto = p.id_produto
WHERE p.status = 'Concluído'
GROUP BY pr.categoria
ORDER BY receita_total DESC;


-- ============================================================
-- BLOCO 4: ANÁLISE DE FORNECEDORES — Contribuição e cobertura
-- ============================================================

-- Receita gerada por fornecedor — mede o peso de cada parceiro
SELECT
    f.nome_fornecedor,
    f.pais,
    COUNT(DISTINCT pr.id_produto)                                  AS produtos_no_mix,
    SUM(p.quantidade)                                              AS unidades_vendidas,
    SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS receita_gerada
FROM fornecedores f
INNER JOIN produtos pr ON f.id_fornecedor = pr.fornecedor_id
INNER JOIN pedidos p   ON pr.id_produto = p.id_produto
WHERE p.status = 'Concluído'
GROUP BY f.nome_fornecedor, f.pais
ORDER BY receita_gerada DESC;


-- Fornecedores inativos que ainda têm produtos no catálogo ativo
-- Risco operacional: produtos sem suporte de reposição
SELECT
    f.nome_fornecedor,
    f.pais,
    COUNT(pr.id_produto) AS produtos_em_catalogo,
    SUM(pr.estoque)      AS estoque_total_restante
FROM fornecedores f
INNER JOIN produtos pr ON f.id_fornecedor = pr.fornecedor_id
WHERE f.ativo = 0
GROUP BY f.nome_fornecedor, f.pais;


-- Visão completa: produto + fornecedor + desempenho de vendas
-- Útil para reuniões de revisão de mix e negociação com fornecedores
SELECT
    f.nome_fornecedor,
    f.pais,
    CASE WHEN f.ativo = 1 THEN 'Ativo' ELSE 'Inativo' END AS situacao_fornecedor,
    pr.nome_produto,
    pr.categoria,
    pr.estoque,
    COALESCE(SUM(p.quantidade), 0)                         AS unidades_vendidas,
    COALESCE(
        SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0)), 0
    )                                                      AS receita
FROM fornecedores f
INNER JOIN produtos pr ON f.id_fornecedor = pr.fornecedor_id
LEFT  JOIN pedidos  p  ON pr.id_produto = p.id_produto
                       AND p.status = 'Concluído'
GROUP BY f.nome_fornecedor, f.pais, f.ativo, pr.nome_produto, pr.categoria, pr.estoque
ORDER BY f.nome_fornecedor, receita DESC;


-- ============================================================
-- BLOCO 5: VISÃO EXECUTIVA — Consolidado para apresentação
-- ============================================================

-- KPIs gerais do período Q1 2024
SELECT
    COUNT(DISTINCT p.id_cliente)                                   AS clientes_compradores,
    COUNT(p.id_pedido)                                             AS total_pedidos,
    SUM(CASE WHEN p.status = 'Concluído'  THEN 1 ELSE 0 END)      AS pedidos_concluidos,
    SUM(CASE WHEN p.status = 'Cancelado'  THEN 1 ELSE 0 END)      AS pedidos_cancelados,
    SUM(CASE WHEN p.status = 'Pendente'   THEN 1 ELSE 0 END)      AS pedidos_pendentes,
    ROUND(
        SUM(CASE WHEN p.status = 'Cancelado' THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1
    )                                                              AS taxa_cancelamento_pct,
    SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS receita_bruta_total
FROM pedidos p
INNER JOIN produtos pr ON p.id_produto = pr.id_produto;


-- Receita mensal com evolução — base para gráfico de linha
SELECT
    FORMAT(p.data_pedido, 'yyyy-MM')                               AS mes,
    COUNT(p.id_pedido)                                             AS pedidos,
    SUM(pr.preco * p.quantidade * (1 - p.desconto_pct / 100.0))   AS receita_liquida
FROM pedidos p
INNER JOIN produtos pr ON p.id_produto = pr.id_produto
WHERE p.status = 'Concluído'
GROUP BY FORMAT(p.data_pedido, 'yyyy-MM')
ORDER BY mes;
