CREATE OR REPLACE VIEW vw_bancos AS (
    SELECT numero, nome, ativo
    FROM banco
);

CREATE OR REPLACE VIEW vw_agencias AS (
    SELECT banco_numero, numero, nome, ativo
    FROM agencia
);

CREATE OR REPLACE VIEW vw_bancos_agencias (
    banco_numero,
    banco_nome,
    agencia_numero,
    agencia_nome,
    agencia_ativo
) AS (
    SELECT  banco.numero AS banco_numero,
            banco.nome AS banco_nome,
            agencia.numero AS agencia_numero,
            agencia.nome AS agencia_nome,
            agencia.ativo AS agencia_ativo
    FROM banco
    LEFT JOIN agencia ON agencia.banco_numero = banco.numero
);

CREATE OR REPLACE VIEW vw_cliente AS (
    SELECT numero, nome, email, ativo
    FROM cliente
);

CREATE OR REPLACE VIEW vw_tipo_transacao AS (
    SELECT id, nome
    FROM tipo_transacao
);

CREATE OR REPLACE VIEW vw_conta_corrente AS (
    SELECT  banco_numero,
            agencia_numero,
            numero,
            digito,
            cliente_numero,
            ativo
    FROM conta_corrente
);

CREATE OR REPLACE VIEW cliente_conta_corrente (
    banco_numero,
    banco_nome,
    agencia_numero,
    agencia_nome,
    conta_corrente_numero,
    conta_corrente_digito,
    cliente_numero,
    cliente_nome
) AS (
        SELECT  banco.numero AS banco_numero,
                banco.nome AS banco_nome,
                agencia.numero AS agencia_numero,
                agencia.nome AS agencia_nome,
                conta_corrente.numero AS conta_corrente_numero,
                conta_corrente.digito AS conta_corrente_digito,
                cliente.numero AS cliente_numero,
                cliente.nome AS cliente_nome
        FROM cliente
        JOIN conta_corrente ON conta_corrente.cliente_numero = cliente.numero
        JOIN agencia ON agencia.numero = conta_corrente.agencia_numero
        JOIN banco ON banco.numero = agencia.banco_numero AND banco.numero = conta_corrente.banco_numero
);

CREATE OR REPLACE VIEW vw_cliente_transacoes (
    cliente_numero,
    cliente_nome,
    banco_nome,
    agencia_nome,
    conta_corrente_numero,
    conta_corrente_digito,
    transacao_nome,
    valor
    
) AS (
    SELECT  cliente.numero AS cliente_numero,
            cliente.nome AS cliente_nome,
            banco.nome AS banco_nome,
            agencia.nome AS agencia_nome,
            cliente_transacoes.conta_corrente_numero,
            cliente_transacoes.conta_corrente_digito,
            tipo_transacao.nome AS transacao_nome,
            cliente_transacoes.valor
    FROM cliente
    JOIN cliente_transacoes ON cliente_transacoes.cliente_numero = cliente.numero
    JOIN agencia ON agencia.numero = cliente_transacoes.agencia_numero
    JOIN banco ON banco.numero = cliente_transacoes.banco_numero
    JOIN tipo_transacao ON tipo_transacao.id = cliente_transacoes.tipo_transacao_id
);