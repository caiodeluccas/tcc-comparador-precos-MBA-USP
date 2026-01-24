-- Inserindo os indicadores específicos da OIT (ILO) vinculados à Source 1
INSERT INTO salary_indicators (id_indicator, indicator_code, description, unit, id_source)
VALUES 
    -- MÉDIA (Ganhos Reais da População)
    (1, 'EAR_4MTH_SEX_CUR_NB', 'Média Salarial Mensal', 'Mensal', 1), -- O dado que você já tem
    (2, 'EAR_4HOU_SEX_CUR_NB', 'Média Salarial por Hora', 'Hora', 1),   -- O que você quer para a paridade
    
    -- MÍNIMO (Piso legal fixado pelo governo)
    (3, 'MWG_2MTH_SEX_CUR_NB', 'Salário Mínimo Mensal', 'Mensal', 1),
    
    -- REFERÊNCIA DE JORNADA
    (5, 'QLS_HW_AVE_NB', 'Média de horas semanais trabalhadas', 'Horas', 1)
ON CONFLICT (indicator_code) DO NOTHING;