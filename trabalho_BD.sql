-- PROJETO: Business Intelligence com Views para Relatórios Gerenciais
-- Tema 2 - Views para Relatórios Gerenciais

-- 1. CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE vendas_gerenciais;
USE vendas_gerenciais;

-- 2. CRIAÇÃO DAS TABELAS

-- Vendedores
CREATE TABLE vendedores (
    id_vendedor      INT AUTO_INCREMENT PRIMARY KEY,
    nome             VARCHAR(100) NOT NULL,
    email            VARCHAR(100),
    data_contratacao DATE
);

-- Clientes
CREATE TABLE clientes (
    id_cliente  INT AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    cidade      VARCHAR(100)
);

-- produtos
CREATE TABLE produtos (
    id_produto    INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto  VARCHAR(100) NOT NULL,
    categoria     VARCHAR(50),
    preco_custo   DECIMAL(10,2) NOT NULL,
    preco_venda   DECIMAL(10,2) NOT NULL
);

-- Vendas: cabeçalho da venda (uma venda pode ter vários produtos)
CREATE TABLE vendas (
    id_venda     INT AUTO_INCREMENT PRIMARY KEY,
    data_venda   DATE NOT NULL,
    id_vendedor  INT NOT NULL,
    id_cliente   INT NOT NULL,
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente)
);

-- Itens da venda: "detalhe" da venda (quais produtos e quantidades)

CREATE TABLE itens_venda (
    id_item        INT AUTO_INCREMENT PRIMARY KEY,
    id_venda       INT NOT NULL,
    id_produto     INT NOT NULL,
    quantidade     INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venda)   REFERENCES vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);


-- 3. INSERÇÃO DE DADOS DE EXEMPLO

-- Vendedores
INSERT INTO vendedores (nome, email, data_contratacao) VALUES
('Ana Souza',    'ana.souza@loja.com',    '2024-02-10'),
('Bruno Lima',   'bruno.lima@loja.com',   '2024-05-03'),
('Carla Mendes', 'carla.mendes@loja.com', '2023-11-20'),
('Diego Alves',  'diego.alves@loja.com',  '2025-01-15'),
('Elaine Rocha', 'elaine.rocha@loja.com', '2025-06-01');

-- Clientes
INSERT INTO clientes (nome, cidade) VALUES
('João Pereira',    'Recife'),
('Maria Santos',    'Olinda'),
('Pedro Costa',     'Recife'),
('Fernanda Dias',   'Jaboatão dos Guararapes'),
('Lucas Martins',   'Recife');

-- Produtos
INSERT INTO produtos (nome_produto, categoria, preco_custo, preco_venda) VALUES
('Notebook X1',       'Informática', 2000.00, 2800.00),
('Mouse Wireless',    'Acessórios',    20.00,   45.00),
('Teclado Mecânico',  'Acessórios',    80.00,  150.00),
('Monitor 24"',       'Informática',  500.00,  750.00),
('Smartphone Y2',     'Eletrônicos', 1200.00, 1800.00),
('Fone Bluetooth',    'Acessórios',    60.00,  120.00),
('Impressora Laser',  'Informática',  400.00,  600.00),
('Cadeira Gamer',     'Móveis',       350.00,  550.00);

-- Vendas
INSERT INTO vendas (data_venda, id_vendedor, id_cliente) VALUES
('2026-07-05', 1, 1),  -- id_venda 1
('2026-07-12', 2, 2),  -- id_venda 2
('2026-07-20', 1, 3),  -- id_venda 3
('2026-08-02', 3, 1),  -- id_venda 4
('2026-08-10', 4, 4),  -- id_venda 5
('2026-08-15', 2, 5),  -- id_venda 6
('2026-08-25', 1, 2),  -- id_venda 7
('2026-09-03', 5, 3),  -- id_venda 8
('2026-09-10', 3, 1),  -- id_venda 9
('2026-09-15', 4, 5),  -- id_venda 10
('2026-09-20', 1, 4),  -- id_venda 11
('2026-09-25', 2, 2);  -- id_venda 12

-- --- Itens de venda (detalhe) ---
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 2800.00), (1, 2, 2, 45.00),
(2, 3, 1, 150.00),  (2, 6, 1, 120.00),
(3, 5, 1, 1800.00),
(4, 4, 2, 750.00),
(5, 2, 3, 45.00),   (5, 3, 1, 150.00),
(6, 7, 1, 600.00),
(7, 1, 1, 2800.00), (7, 6, 2, 120.00),
(8, 8, 1, 550.00),
(9, 5, 1, 1800.00), (9, 2, 1, 45.00),
(10, 4, 1, 750.00),
(11, 3, 2, 150.00), (11, 6, 1, 120.00),
(12, 1, 1, 2800.00);


-- 4. CRIAÇÃO DAS VIEWS

-- ---------------------------------------------------------------------
-- VIEW 1: Relatório de Vendas
-- Mostra cada item vendido em detalhe: data, vendedor, cliente, produto,
-- quantidade, preço e subtotal. É a base para os outros relatórios.
-- ---------------------------------------------------------------------
CREATE VIEW vw_relatorio_vendas AS
SELECT
    v.id_venda,
    v.data_venda,
    ve.nome        AS vendedor,
    c.nome         AS cliente,
    p.nome_produto AS produto,
    iv.quantidade,
    iv.preco_unitario,
    (iv.quantidade * iv.preco_unitario) AS subtotal
FROM vendas v
JOIN vendedores ve ON v.id_vendedor = ve.id_vendedor
JOIN clientes   c  ON v.id_cliente  = c.id_cliente
JOIN itens_venda iv ON v.id_venda   = iv.id_venda
JOIN produtos    p  ON iv.id_produto = p.id_produto;


-- ---------------------------------------------------------------------
-- VIEW 2: Lucro por Período
-- Agrupa as vendas por mês (formato AAAA-MM) e calcula receita,
-- custo e lucro totais de cada período.
-- ---------------------------------------------------------------------
CREATE VIEW vw_lucro_por_periodo AS
SELECT
    DATE_FORMAT(v.data_venda, '%Y-%m') AS periodo,
    SUM(iv.quantidade * iv.preco_unitario)              AS receita_total,
    SUM(iv.quantidade * p.preco_custo)                  AS custo_total,
    SUM(iv.quantidade * (iv.preco_unitario - p.preco_custo)) AS lucro_total
FROM vendas v
JOIN itens_venda iv ON v.id_venda    = iv.id_venda
JOIN produtos    p  ON iv.id_produto = p.id_produto
GROUP BY DATE_FORMAT(v.data_venda, '%Y-%m');


-- ---------------------------------------------------------------------
-- VIEW 3: Produtos Mais Vendidos
-- Agrupa por produto, somando quantidade vendida e receita gerada.
-- ---------------------------------------------------------------------
CREATE VIEW vw_produtos_mais_vendidos AS
SELECT
    p.id_produto,
    p.nome_produto,
    p.categoria,
    SUM(iv.quantidade)                     AS quantidade_total_vendida,
    SUM(iv.quantidade * iv.preco_unitario) AS receita_total
FROM itens_venda iv
JOIN produtos p ON iv.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome_produto, p.categoria;


-- ---------------------------------------------------------------------
-- VIEW 4: Desempenho dos Vendedores
-- Agrupa por vendedor, mostrando total de vendas, receita e lucro gerado.
-- ---------------------------------------------------------------------
CREATE VIEW vw_desempenho_vendedores AS
SELECT
    ve.id_vendedor,
    ve.nome AS vendedor,
    COUNT(DISTINCT v.id_venda)             AS total_vendas,
    SUM(iv.quantidade * iv.preco_unitario) AS receita_total,
    SUM(iv.quantidade * (iv.preco_unitario - p.preco_custo)) AS lucro_total
FROM vendedores ve
JOIN vendas v       ON ve.id_vendedor = v.id_vendedor
JOIN itens_venda iv ON v.id_venda     = iv.id_venda
JOIN produtos p     ON iv.id_produto  = p.id_produto
GROUP BY ve.id_vendedor, ve.nome;


-- =====================================================================
-- 5. CONSULTAS DE EXEMPLO (usando as Views)
-- =====================================================================

-- --- 5.1 Relatório de Vendas ---

-- Todas as vendas, das mais recentes para as mais antigas
SELECT * FROM vw_relatorio_vendas
ORDER BY data_venda DESC;

-- Vendas de um vendedor específico
SELECT * FROM vw_relatorio_vendas
WHERE vendedor = 'Ana Souza';

-- --- 5.2 Lucro por Período ---

-- Lucro de todos os meses, em ordem cronológica
SELECT * FROM vw_lucro_por_periodo
ORDER BY periodo;

-- Apenas os períodos com lucro acima de 1500
SELECT * FROM vw_lucro_por_periodo
WHERE lucro_total > 1500
ORDER BY periodo;

-- --- 5.3 Produtos Mais Vendidos ---

-- Top 5 produtos por quantidade vendida
SELECT * FROM vw_produtos_mais_vendidos
ORDER BY quantidade_total_vendida DESC
LIMIT 5;

-- Produtos mais vendidos filtrando por categoria
SELECT * FROM vw_produtos_mais_vendidos
WHERE categoria = 'Acessórios'
ORDER BY receita_total DESC;

-- --- 5.4 Desempenho dos Vendedores ---

-- Ranking de vendedores por receita total
SELECT * FROM vw_desempenho_vendedores
ORDER BY receita_total DESC;

-- Vendedor com maior lucro gerado (destaque)
SELECT vendedor, lucro_total
FROM vw_desempenho_vendedores
ORDER BY lucro_total DESC
LIMIT 1;

