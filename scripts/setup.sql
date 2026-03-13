-- ============================================================
-- SETUP: Modelo relacional — E-commerce B2B
-- Execute este script antes de analise_clientes_pedidos.sql
-- ============================================================

DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS fornecedores;

CREATE TABLE clientes (
    id_cliente    INT PRIMARY KEY,
    nome          VARCHAR(100),
    email         VARCHAR(100),
    cidade        VARCHAR(80),
    estado        CHAR(2),
    segmento      VARCHAR(20),  -- Premium | Standard
    data_cadastro DATE
);

CREATE TABLE fornecedores (
    id_fornecedor   INT PRIMARY KEY,
    nome_fornecedor VARCHAR(100),
    pais            VARCHAR(50),
    contato         VARCHAR(100),
    ativo           BIT           -- 1 = ativo, 0 = inativo
);

CREATE TABLE produtos (
    id_produto    INT PRIMARY KEY,
    nome_produto  VARCHAR(100),
    categoria     VARCHAR(50),
    preco         DECIMAL(10,2),
    estoque       INT,
    fornecedor_id INT REFERENCES fornecedores(id_fornecedor)
);

CREATE TABLE pedidos (
    id_pedido    INT PRIMARY KEY,
    id_cliente   INT REFERENCES clientes(id_cliente),
    id_produto   INT REFERENCES produtos(id_produto),
    data_pedido  DATE,
    quantidade   INT,
    desconto_pct INT DEFAULT 0,
    status       VARCHAR(20)   -- Concluído | Cancelado | Pendente
);

-- ============================================================
-- CARGA
-- ============================================================

INSERT INTO clientes VALUES
(1,'Ana Souza','ana.souza@email.com','São Paulo','SP','Premium','2023-01-15'),
(2,'Carlos Lima','carlos.lima@email.com','Rio de Janeiro','RJ','Standard','2023-02-20'),
(3,'Beatriz Costa','beatriz.costa@email.com','Belo Horizonte','MG','Premium','2023-01-30'),
(4,'Diego Alves','diego.alves@email.com','São Paulo','SP','Standard','2023-03-10'),
(5,'Elena Ferreira','elena.ferreira@email.com','Porto Alegre','RS','Premium','2023-04-05'),
(6,'Fábio Gomes','fabio.gomes@email.com','Salvador','BA','Standard','2023-02-14'),
(7,'Gabriela Nunes','gabriela.nunes@email.com','São Paulo','SP','Premium','2023-05-20'),
(8,'Henrique Pinto','henrique.pinto@email.com','Fortaleza','CE','Standard','2023-06-01'),
(9,'Isabela Rocha','isabela.rocha@email.com','Curitiba','PR','Standard','2023-03-25'),
(10,'João Martins','joao.martins@email.com','São Paulo','SP','Premium','2023-07-10'),
(11,'Kleber Santos','kleber.santos@email.com','Goiânia','GO','Standard','2023-08-15'),
(12,'Laura Mendes','laura.mendes@email.com','São Paulo','SP','Premium','2023-09-01'),
(13,'Marcos Oliveira','marcos.oliveira@email.com','Manaus','AM','Standard','2023-10-20'),
(14,'Natália Cruz','natalia.cruz@email.com','São Paulo','SP','Premium','2023-11-05'),
(15,'Otávio Lima','otavio.lima@email.com','Belo Horizonte','MG','Standard','2023-12-01'),
(16,'Paula Vieira','paula.vieira@email.com','Rio de Janeiro','RJ','Standard','2024-01-10'),
(17,'Rafael Barbosa','rafael.barbosa@email.com','São Paulo','SP','Premium','2024-02-15'),
(18,'Sônia Campos','sonia.campos@email.com','Curitiba','PR','Standard','2024-01-20'),
(19,'Tiago Freitas','tiago.freitas@email.com','São Paulo','SP','Premium','2023-05-30'),
(20,'Uma Cardoso','uma.cardoso@email.com','Salvador','BA','Standard','2023-06-18');

INSERT INTO fornecedores VALUES
(1,'TechBrasil Ltda','Brasil','techbrasil@email.com',1),
(2,'PerifericosMax','Brasil','perimax@email.com',1),
(3,'SoundGear Corp','EUA','soundgear@email.com',1),
(4,'StoragePlus','China','storageplus@email.com',1),
(5,'PrintMasters','Brasil','printmasters@email.com',0),
(6,'OldSupplier SA','Argentina','old@email.com',0);

INSERT INTO produtos VALUES
(1,'Notebook Dell','Eletrônicos',3200.00,15,1),
(2,'Mouse Logitech','Periféricos',150.00,80,2),
(3,'Teclado Mecânico','Periféricos',380.00,45,2),
(4,'Monitor LG 27"','Eletrônicos',1800.00,20,1),
(5,'Headset Gamer','Periféricos',250.00,60,3),
(6,'SSD 1TB','Armazenamento',420.00,50,4),
(7,'Webcam HD','Periféricos',320.00,35,3),
(8,'Notebook Lenovo','Eletrônicos',2900.00,12,1),
(9,'HD Externo 2TB','Armazenamento',550.00,25,4),
(10,'Impressora HP','Outros',890.00,18,5),
(11,'SSD 512GB','Armazenamento',280.00,70,4),
(12,'Monitor Samsung','Eletrônicos',1500.00,22,1),
(13,'Teclado Sem Fio','Periféricos',220.00,55,2),
(14,'Webcam 4K','Periféricos',680.00,20,3),
(15,'Notebook Acer','Eletrônicos',2600.00,10,1),
(16,'HD Externo 1TB','Armazenamento',380.00,30,4),
(17,'Headset Sony','Periféricos',450.00,40,3),
(18,'Impressora Epson','Outros',1200.00,14,5),
(19,'Mouse Sem Fio','Periféricos',120.00,90,2),
(20,'SSD 2TB','Armazenamento',780.00,15,4),
(21,'Smartwatch Samsung','Eletrônicos',1100.00,0,1),
(22,'Cabo HDMI','Periféricos',45.00,0,2);

INSERT INTO pedidos VALUES
(1,1,1,'2024-01-05',1,0,'Concluído'),
(2,2,2,'2024-01-07',2,5,'Concluído'),
(3,3,3,'2024-01-10',1,0,'Concluído'),
(4,4,4,'2024-01-12',1,10,'Concluído'),
(5,5,5,'2024-01-15',3,0,'Cancelado'),
(6,6,6,'2024-01-18',2,0,'Concluído'),
(7,7,7,'2024-01-20',1,5,'Concluído'),
(8,8,8,'2024-01-22',1,0,'Concluído'),
(9,9,9,'2024-01-25',1,0,'Pendente'),
(10,10,10,'2024-01-28',1,10,'Concluído'),
(11,1,2,'2024-02-02',1,0,'Concluído'),
(12,2,1,'2024-02-05',1,0,'Cancelado'),
(13,11,11,'2024-02-08',3,5,'Concluído'),
(14,12,12,'2024-02-11',2,0,'Concluído'),
(15,13,13,'2024-02-14',1,0,'Concluído'),
(16,14,14,'2024-02-17',1,15,'Concluído'),
(17,15,15,'2024-02-20',1,0,'Concluído'),
(18,16,16,'2024-02-23',2,0,'Concluído'),
(19,17,17,'2024-02-26',1,5,'Concluído'),
(20,18,18,'2024-02-28',1,0,'Pendente'),
(21,19,1,'2024-03-03',2,10,'Concluído'),
(22,20,19,'2024-03-06',4,0,'Concluído'),
(23,1,20,'2024-03-09',1,0,'Concluído'),
(24,3,3,'2024-03-12',2,5,'Concluído'),
(25,4,12,'2024-03-15',3,0,'Concluído'),
(26,7,1,'2024-03-18',1,0,'Concluído'),
(27,9,20,'2024-03-21',1,0,'Cancelado'),
(28,1,5,'2024-03-24',1,0,'Concluído'),
(29,2,7,'2024-03-27',2,5,'Concluído'),
(30,3,12,'2024-03-30',1,0,'Concluído');

SELECT 'Clientes' AS tabela, COUNT(*) AS registros FROM clientes
UNION ALL
SELECT 'Fornecedores', COUNT(*) FROM fornecedores
UNION ALL
SELECT 'Produtos', COUNT(*) FROM produtos
UNION ALL
SELECT 'Pedidos', COUNT(*) FROM pedidos;
