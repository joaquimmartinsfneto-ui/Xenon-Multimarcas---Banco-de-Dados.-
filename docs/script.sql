DROP DATABASE IF EXISTS db_xenon_multimarcas;
CREATE DATABASE db_xenon_multimarcas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_xenon_multimarcas;

CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nm_cliente VARCHAR(100) NOT NULL,
    nr_cpf VARCHAR(11) NOT NULL UNIQUE,
    nr_telefone VARCHAR(20) NOT NULL,
    ds_email VARCHAR(100),
    ds_endereco VARCHAR(255)
);

CREATE TABLE Funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nm_funcionario VARCHAR(100) NOT NULL,
    nr_cpf VARCHAR(11) NOT NULL UNIQUE,
    nr_telefone VARCHAR(20) NOT NULL,
    ds_cargo VARCHAR(50) NOT NULL
);

CREATE TABLE Veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    ds_chassi VARCHAR(17) NOT NULL UNIQUE,
    nm_marca VARCHAR(50) NOT NULL,
    nm_modelo VARCHAR(50) NOT NULL,
    nr_ano INT NOT NULL,
    vl_preco DECIMAL(12, 2) NOT NULL CHECK (vl_preco > 0),
    tp_veiculo VARCHAR(30),
    st_veiculo VARCHAR(30) NOT NULL CHECK (st_veiculo IN ('Disponível', 'Vendido', 'Reservado', 'Em Manutenção'))
);

CREATE TABLE Banco (
    id_banco INT AUTO_INCREMENT PRIMARY KEY,
    nm_banco VARCHAR(100) NOT NULL,
    nr_cnpj VARCHAR(14) NOT NULL UNIQUE,
    nr_telefone VARCHAR(20)
);

CREATE TABLE Venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    id_veiculo INT NOT NULL UNIQUE,
    dt_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vl_total DECIMAL(12, 2) NOT NULL CHECK (vl_total > 0),
    ds_forma_pagamento VARCHAR(30) NOT NULL CHECK (ds_forma_pagamento IN ('À Vista', 'Financiamento', 'Cartão de Crédito', 'PIX', 'Misto')),
    st_venda VARCHAR(30) NOT NULL CHECK (st_venda IN ('Pendente', 'Aprovada', 'Concluída', 'Cancelada')),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_venda_funcionario FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_venda_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Financiamento (
    id_financiamento INT AUTO_INCREMENT PRIMARY KEY,
    id_banco INT NOT NULL,
    id_venda INT NOT NULL UNIQUE,
    vl_financiado DECIMAL(12, 2) NOT NULL CHECK (vl_financiado > 0),
    qt_parcelas INT NOT NULL CHECK (qt_parcelas > 0),
    vl_parcela DECIMAL(12, 2) NOT NULL CHECK (vl_parcela > 0),
    st_financiamento VARCHAR(30) NOT NULL CHECK (st_financiamento IN ('Em Análise', 'Aprovado', 'Recusado', 'Cancelado')),
    CONSTRAINT fk_financiamento_banco FOREIGN KEY (id_banco) REFERENCES Banco(id_banco) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_financiamento_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Pedido_de_venda (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL UNIQUE,
    dt_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nr_nota_fiscal VARCHAR(50) UNIQUE,
    nm_cartorio VARCHAR(100),
    st_pedido VARCHAR(30) NOT NULL CHECK (st_pedido IN ('Em Processamento', 'Aguardando Emissão', 'Faturado', 'Cancelado')),
    CONSTRAINT fk_pedido_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL UNIQUE,
    dt_prevista DATE NOT NULL,
    dt_entrega DATETIME,
    ds_endereco_entrega VARCHAR(255),
    st_entrega VARCHAR(30) NOT NULL CHECK (st_entrega IN ('Agendada', 'Em Preparação', 'Pronto para Retirada', 'Entregue', 'Cancelada')),
    CONSTRAINT fk_entrega_venda FOREIGN KEY (id_venda) REFERENCES Venda(id_venda) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO Cliente (nm_cliente, nr_cpf, nr_telefone, ds_email, ds_endereco) VALUES
('Carlos Alberto Silva', '12345678901', '11988887777', 'carlos.silva@email.com', 'Rua das Flores, 123 - São Paulo/SP'),
('Mariana Souza Costa', '98765432109', '11977776666', 'mariana.costa@email.com', 'Av. Paulista, 1000 - São Paulo/SP'),
('Lucas Pereira Lima', '45678912304', '11966665555', 'lucas.lima@email.com', 'Rua Augusta, 500 - São Paulo/SP'),
('Fernanda Rocha Ribeiro', '32165498702', '11955554444', 'fernanda.rocha@email.com', 'Alameda Santos, 200 - São Paulo/SP'),
('Rodrigo Alves Martins', '78912345605', '11944443333', 'rodrigo.alves@email.com', 'Rua Haddock Lobo, 800 - São Paulo/SP'),
('Juliana Mendes Antunes', '65432198703', '11933334444', 'juliana.antunes@email.com', 'Av. Brigadeiro Luis Antonio, 1500 - São Paulo/SP'),
('Marcos Vinicius Rocha', '74185296302', '11922225555', 'marcos.rocha@email.com', 'Rua da Consolação, 900 - São Paulo/SP'),
('Camila Duarte Santos', '36925814701', '11911116666', 'camila.santos@email.com', 'Praça da Sé, 50 - São Paulo/SP');

INSERT INTO Funcionario (nm_funcionario, nr_cpf, nr_telefone, ds_cargo) VALUES
('Roberto Mendes', '11122233344', '11933332222', 'Vendedor Sênior'),
('Ana Paula Lima', '55566677788', '11922221111', 'Gerente de Vendas'),
('Juliana Prado', '88899900011', '11911110000', 'Vendedora Pleno'),
('Marcos Vinicius', '22233344455', '11955556677', 'Vendedor Júnior'),
('Patricia Souza', '33344455566', '11944447788', 'Consultora de Financiamentos'),
('Lucas Gabriel', '44455566677', '11933338899', 'Atendente de Pátio');

INSERT INTO Veiculo (ds_chassi, nm_marca, nm_modelo, nr_ano, vl_preco, tp_veiculo, st_veiculo) VALUES
('9BWZZZ474T001234', 'Chevrolet', 'Onix Plus', 2020, 85000.00, 'Sedan', 'Disponivel'),
('9BWZZZ377VT001234', 'Chevrolet', 'Onix Plus', 2024, 85000.00, 'Sedan', 'Vendido'),
('93HZZZ255MK987654', 'Toyota', 'Corolla Cross', 2025, 160000.00, 'SUV', 'Vendido'),
('9BMZZZ488KL456789', 'Volkswagen', 'Nivus Highline', 2024, 125000.00, 'SUV', 'Disponível'),
('9FDRRR222MM112233', 'Ford', 'Ranger XLT', 2023, 210000.00, 'Pickup', 'Disponível'),
('9BGZZZ555NN334455', 'Fiat', 'Pulse Impetus', 2024, 105000.00, 'Hatch', 'Em Manutenção'),
('9BWZZZ111VT009988', 'Chevrolet', 'Tracker Premier', 2024, 135000.00, 'SUV', 'Disponível'),
('93HZZZ333MK887766', 'Toyota', 'Hilux SRX', 2023, 245000.00, 'Pickup', 'Vendido'),
('9BMZZZ555KL112233', 'Volkswagen', 'Polo TSI', 2024, 90000.00, 'Hatch', 'Disponível'),
('9FDRRR444MM334455', 'Jeep', 'Compass Limited', 2024, 175000.00, 'SUV', 'Reservado'),
('9BGZZZ789NN221133', 'Hyundai', 'Creta Ultimate', 2024, 150000.00, 'SUV', 'Disponível'),
('9BWZZZ999VT554433', 'Honda', 'Civic Touring', 2023, 140000.00, 'Sedan', 'Vendido'),
('93HZZZ111MK223344', 'Nissan', 'Kicks Exclusive', 2024, 120000.00, 'SUV', 'Disponível'),
('9BMZZZ777KL998877', 'Renault', 'Duster Iconic', 2023, 110000.00, 'SUV', 'Em Manutenção'),
('9FDRRR555MM667788', 'Chevrolet', 'S10 High Country', 2023, 230000.00, 'Pickup', 'Disponível'),
('9BGZZZ333NN110022', 'Fiat', 'Toro Volcano', 2024, 155000.00, 'Pickup', 'Vendido'),
('9BWZZZ444VT223355', 'Volkswagen', 'Taos Highline', 2024, 170000.00, 'SUV', 'Disponível'),
('93HZZZ555MK445566', 'Toyota', 'Yaris Hatch', 2023, 82000.00, 'Hatch', 'Disponível'),
('9BMZZZ888KL332211', 'Jeep', 'Renegade Longitude', 2024, 130000.00, 'SUV', 'Disponível');

INSERT INTO Banco (nm_banco, nr_cnpj, nr_telefone) VALUES
('Banco Itaú S.A.', '60701190000104', '08007280728'),
('Banco Santander Brasil', '90400888000142', '08007627777'),
('Banco Bradesco S.A.', '60746948000112', '08007048383');

INSERT INTO Venda (id_cliente, id_funcionario, id_veiculo, dt_venda, vl_total, ds_forma_pagamento, st_venda) VALUES
(1, 1, 2, '2026-10-15 14:30:00', 160000.00, 'Financiamento', 'Concluída'),
(2, 2, 1, '2026-10-20 11:00:00', 85000.00, 'PIX', 'Concluída'),
(3, 3, 7, '2026-10-21 09:15:00', 245000.00, 'Financiamento', 'Concluída'),
(4, 1, 11, '2026-10-22 16:45:00', 140000.00, 'À Vista', 'Concluída'),
(5, 4, 15, '2026-10-23 10:30:00', 155000.00, 'Misto', 'Concluída'),
(6, 2, 3, '2026-10-24 14:00:00', 125000.00, 'Financiamento', 'Pendente'),
(7, 3, 9, '2026-10-25 11:30:00', 175000.00, 'Cartão de Crédito', 'Aprovada'),
(8, 1, 4, '2026-10-26 15:20:00', 210000.00, 'Financiamento', 'Cancelada'),
(1, 2, 6, '2026-10-27 10:00:00', 135000.00, 'PIX', 'Concluída'),
(2, 3, 8, '2026-10-28 13:45:00', 90000.00, 'À Vista', 'Concluída'),
(3, 4, 10, '2026-10-29 16:10:00', 150000.00, 'Financiamento', 'Concluída'),
(4, 1, 12, '2026-10-30 09:30:00', 120000.00, 'PIX', 'Concluída'),
(5, 2, 14, '2026-10-31 11:20:00', 230000.00, 'Financiamento', 'Concluída'),
(6, 3, 16, '2026-11-01 14:50:00', 170000.00, 'À Vista', 'Concluída'),
(7, 4, 18, '2026-11-02 15:00:00', 130000.00, 'Cartão de Crédito', 'Concluída');

INSERT INTO Financiamento (id_banco, id_venda, vl_financiado, qt_parcelas, vl_parcela, st_financiamento) VALUES
(1, 1, 130000.00, 48, 3500.00, 'Aprovado'),
(2, 3, 200000.00, 60, 4800.00, 'Aprovado'),
(3, 5, 100000.00, 36, 3200.00, 'Aprovado'),
(1, 6, 100000.00, 48, 2900.00, 'Em Análise'),
(2, 8, 180000.00, 60, 4300.00, 'Recusado'),
(3, 11, 120000.00, 48, 3400.00, 'Aprovado'),
(1, 13, 180000.00, 60, 4500.00, 'Aprovado');

INSERT INTO Pedido_de_venda (id_venda, dt_pedido, nr_nota_fiscal, nm_cartorio, st_pedido) VALUES
(1, '2026-10-16 10:00:00', 'NF-98321', '1º Cartório de Notas SP', 'Faturado'),
(2, '2026-10-20 14:00:00', 'NF-98322', '3º Cartório de Títulos SP', 'Faturado'),
(3, '2026-10-22 09:00:00', 'NF-98323', '2º Cartório de Notas SP', 'Faturado'),
(4, '2026-10-22 17:00:00', 'NF-98324', '1º Cartório de Notas SP', 'Faturado'),
(5, '2026-10-23 11:00:00', 'NF-98325', '4º Cartório de Notas SP', 'Faturado'),
(9, '2026-10-27 10:30:00', 'NF-98326', '1º Cartório de Notas SP', 'Faturado'),
(10, '2026-10-28 14:00:00', 'NF-98327', '2º Cartório de Títulos SP', 'Faturado'),
(11, '2026-10-29 17:00:00', 'NF-98328', '3º Cartório de Notas SP', 'Faturado'),
(12, '2026-10-30 10:00:00', 'NF-98329', '1º Cartório de Notas SP', 'Faturado'),
(13, '2026-10-31 12:00:00', 'NF-98330', '4º Cartório de Notas SP', 'Faturado'),
(14, '2026-11-01 15:30:00', 'NF-98331', '2º Cartório de Notas SP', 'Faturado'),
(15, '2026-11-02 16:00:00', 'NF-98332', '1º Cartório de Notas SP', 'Faturado');

INSERT INTO Entrega (id_venda, dt_prevista, dt_entrega, ds_endereco_entrega, st_entrega) VALUES
(1, '2026-10-18', '2026-10-18 16:00:00', 'Av. Paulista, 1000 - São Paulo/SP', 'Entregue'),
(2, '2026-10-22', '2026-10-22 10:30:00', 'Rua das Flores, 123 - São Paulo/SP', 'Entregue'),
(3, '2026-10-25', '2026-10-25 15:00:00', 'Rua Augusta, 500 - São Paulo/SP', 'Entregue'),
(4, '2026-10-26', '2026-10-26 11:00:00', 'Alameda Santos, 200 - São Paulo/SP', 'Entregue'),
(5, '2026-10-27', '2026-10-27 14:30:00', 'Rua Haddock Lobo, 800 - São Paulo/SP', 'Entregue'),
(9, '2026-10-30', '2026-10-30 16:00:00', 'Av. Brigadeiro Luis Antonio, 1500 - São Paulo/SP', 'Entregue'),
(10, '2026-11-01', '2026-11-01 11:00:00', 'Rua da Consolação, 900 - São Paulo/SP', 'Entregue'),
(11, '2026-11-02', '2026-11-02 13:30:00', 'Praça da Sé, 50 - São Paulo/SP', 'Entregue'),
(12, '2026-11-03', NULL, 'Av. Paulista, 1000 - São Paulo/SP', 'Pronto para Retirada'),
(13, '2026-11-04', NULL, 'Rua das Flores, 123 - São Paulo/SP', 'Em Preparação');

UPDATE Veiculo 
SET st_veiculo = 'Reservado' 
WHERE id_veiculo = 9;

DELETE FROM Cliente 
WHERE id_cliente = 7 
  AND id_cliente NOT IN (SELECT id_cliente FROM Venda);

-- =====================================================================
-- CONSULTAS GERENCIAIS (G01 - G08)
-- =====================================================================

-- G01: Histórico comercial integrado envolvendo todas as tabelas principais
-- Atende: P1 (Organização e recuperação dos registros comerciais e comprovantes)
SELECT 
    v.id_venda,
    v.dt_venda,
    c.nm_cliente,
    f.nm_funcinario AS nm_funcionario,
    ve.nm_marca,
    ve.nm_modelo,
    ve.ds_chassi,
    v.vl_total,
    v.ds_forma_pagamento,
    v.st_venda,
    b.nm_banco,
    fn.vl_financiado,
    pv.nr_nota_fiscal,
    e.st_entrega
FROM Venda v
JOIN Cliente c ON v.id_cliente = c.id_cliente
JOIN Funcionario f ON v.id_funcionario = f.id_funcionario
JOIN Veiculo ve ON v.id_veiculo = ve.id_veiculo
LEFT JOIN Financiamento fn ON v.id_venda = fn.id_venda
LEFT JOIN Banco b ON fn.id_banco = b.id_banco
LEFT JOIN Pedido_de_venda pv ON v.id_venda = pv.id_venda
LEFT JOIN Entrega e ON v.id_venda = e.id_venda;

-- G02: Quantidade de vendas concluídas e Faturamento concluído (KPI01 e KPI02)
SELECT 
    COUNT(id_venda) AS quantidade_vendas_concluidas,
    SUM(vl_total) AS faturamento_concluido
FROM Venda
WHERE st_venda = 'Concluída';

-- G03: Ticket médio das vendas concluídas (KPI03)
SELECT 
    AVG(vl_total) AS ticket_medio
FROM Venda
WHERE st_venda = 'Concluída';

-- G04: Taxa de cancelamento de vendas (KPI04)
SELECT 
    (SUM(CASE WHEN st_venda = 'Cancelada' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS taxa_cancelamento_percentual
FROM Venda;

-- G05: Visão do estoque por situação (KPI05)
SELECT 
    st_veiculo,
    COUNT(*) AS quantidade_veiculos
FROM Veiculo
GROUP BY st_veiculo;

-- G06: Taxa de aprovação de financiamento por instituição (KPI06)
SELECT 
    b.nm_banco,
    COUNT(f.id_financiamento) AS total_analisados,
    SUM(CASE WHEN f.st_financiamento = 'Aprovado' THEN 1 ELSE 0 END) AS total_aprovados,
    (SUM(CASE WHEN f.st_financiamento = 'Aprovado' THEN 1 ELSE 0 END) * 100.0) / COUNT(f.id_financiamento) AS taxa_aprovacao_percentual
FROM Financiamento f
JOIN Banco b ON f.id_banco = b.id_banco
GROUP BY b.id_banco, b.nm_banco;

-- G07: Tempo médio entre venda e entrega em dias (KPI07)
SELECT 
    AVG(DATEDIFF(e.dt_entrega, v.dt_venda)) AS tempo_medio_venda_entrega_dias
FROM Venda v
JOIN Entrega e ON v.id_venda = e.id_venda
WHERE e.st_entrega = 'Entregue' AND e.dt_entrega IS NOT NULL;

-- G08: Desempenho e volume de vendas por funcionário (KPI08)
SELECT 
    f.nm_funcionario,
    f.ds_cargo,
    COUNT(v.id_venda) AS qtd_vendas,
    COALESCE(SUM(v.vl_total), 0.00) AS valor_total_vendido
FROM Funcionario f
LEFT JOIN Venda v ON f.id_funcionario = v.id_funcionario AND v.st_venda = 'Concluída'
GROUP BY f.id_funcionario, f.nm_funcionario, f.ds_cargo
ORDER BY valor_total_vendido DESC;

-- =====================================================================
-- CONSULTAS DE AUDITORIA (A01 - A03)
-- =====================================================================

-- A01: Vendas sem funcionário válido vinculado
-- Verifica: RN01 / RN02 (Toda venda deve ser intermediada por um funcionário válido)
SELECT v.id_venda, v.dt_venda, v.vl_total
FROM Venda v
LEFT JOIN Funcionario f ON v.id_funcionario = f.id_funcionario
WHERE f.id_funcionario IS NULL;

-- A02: Veículos vendidos e concluídos sem Pedido de Venda associado
-- Verifica: RN06 (Toda venda concluída gera obrigatoriamente um pedido)
SELECT v.id_venda, ve.nm_modelo, v.st_venda
FROM Venda v
JOIN Veiculo ve ON v.id_veiculo = ve.id_veiculo
LEFT JOIN Pedido_de_venda pv ON v.id_venda = pv.id_venda
WHERE v.st_venda = 'Concluída' AND pv.id_pedido IS NULL;

-- A03: Financiamento registrado para vendas com forma de pagamento à vista ou PIX
-- Verifica: RN04 (Financiamento condicional à forma de pagamento)
SELECT f.id_financiamento, v.id_venda, v.ds_forma_pagamento
FROM Financiamento f
JOIN Venda v ON f.id_venda = v.id_venda
WHERE v.ds_forma_pagamento NOT IN ('Financiamento', 'Misto');
