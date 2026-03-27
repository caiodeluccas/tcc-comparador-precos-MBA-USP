-- Inserindo os indicadores específicos da OIT (ILO) vinculados à Source 1
INSERT INTO labor_indicators (id_indicator, indicator_code, description, unit, id_source)
VALUES 
    -- MÉDIA (Ganhos Reais da População)
    (1, 'EAR_EMTA_SEX_NB_A', 'Média Salarial Mensal', 'Mensal', 1), -- O dado que você já tem
    (2, 'EAR_EHRA_SEX_AGE_NB_A', 'Média Salarial por Hora', 'Hora', 1),   -- O que você quer para a paridade
    
    -- MÍNIMO (Piso legal fixado pelo governo)
    (3, 'EAR_INEE_NOC_NB_A', 'Salário Mínimo Mensal', 'Mensal', 1),
    
    -- REFERÊNCIA DE JORNADA
    (5, 'HOW_2EMP_SEX_NB', 'Média de horas semanais trabalhadas', 'Horas', 1)
ON CONFLICT (indicator_code) DO NOTHING;